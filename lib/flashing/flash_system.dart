import 'package:flutter/material.dart';
import 'package:leejw/main.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../voced/voced.dart';

class FlashState extends ChangeNotifier {
  /// The current lesson that is being flashed.
  Lesson? currentLesson;

  /// The current word that is being flashed.
  VocDataHolder? currentHolder;

  /// What "stage" the user is in in completing the current flashcard:
  /// * -1: Inactive/None
  /// * 0: Show
  /// * 1: Guess
  /// * 2: Feedback
  /// <br>Any higher than 100 are for custom events:
  /// * 100: Introduction
  /// * 101: Exit
  int stage = -1;
  int previousStage = -1;

  /// The index of the current word in the lesson's list of words.
  int index = 0;

  /// The results of the current lesson, mapping ids to whether they were guessed correctly.
  Map<String, bool> results = {};

  void startLesson(Lesson lesson, BuildContext context) {
    if (currentLesson != null) {
      logger.w(
        'A lesson is already in progress. Cannot start a new one.\nPlease end the current lesson first.',
      );
      return;
    }
    currentLesson = lesson;
    // If a lesson is started, we run a small intro card to explain the lesson that follows.
    stage = 100;
    index = 0;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FlashPage();
        },
      ),
    );

    notifyListeners();
  }

  void endGracefully() {
    stage = 101;
    notifyListeners();
    currentLesson = null;
    currentHolder = null;
    index = 0;
    stage = -1;
    previousStage = -1;
    logger.i('Flash session ended gracefully.');
    notifyListeners();
  }

  void endAbruptly(String reason) {
    currentLesson = null;
    currentHolder = null;
    stage = -1;
    logger.w('Flash session ended abruptly: $reason');
    notifyListeners();
  }

  void flip(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context, listen: false);

    logger.i(
      "Flipping stage $stage (previously $previousStage) with index $index",
    );

    if (stage == -1) {
      index = 0;
      logger.w('Cannot flip flashcard when no lesson is active.');
      return;
    }
    previousStage = stage;
    if (stage == 100) {
      stage = 0;
      currentHolder = vocState.getVocHolder(
        currentLesson!.metaData.vocHolderIdentifiers[index],
      );
      notifyListeners();
    } else if (stage == 101) {
      index = 0;
      logger.w('Cannot flip flashcard while exiting.');
    } else if (stage == 0) {
      stage = 1;
      results = {};
      notifyListeners();
    } else if (stage == 1) {
      stage = 2;
      notifyListeners();
    } else if (stage == 2) {
      index++;
      if (index >= currentLesson!.metaData.vocHolderIdentifiers.length) {
        endGracefully();
        Navigator.pop(context);
        return;
      }
      currentHolder = vocState.getVocHolder(
        currentLesson!.metaData.vocHolderIdentifiers[index],
      );
      stage = 0;
      notifyListeners();
    } else {
      logger.w('Unknown stage: $stage');
    }

    logger.i("Flipped to $stage (previously $previousStage) with index $index");
  }

  Map<String, bool> guess(List<String?> guesses) {
    if (currentHolder == null) {
      logger.w('Cannot make a guess when no word is active.');
      return {};
    }
    if (stage != 1) {
      logger.w('Cannot make a guess when not in the guessing stage.');
      return {};
    }

    for (
      int i = 0;
      i < currentHolder!.information.vocData.translations.length;
      i++
    ) {
      var translation =
          currentHolder!.information.vocData.translations[i].translation;
      var guess = guesses[i];
      if (guess == null || guess.isEmpty) {
        continue;
      } else if (translation != guess) {
        results[guess] = false;
      } else {
        results[guess] = true;
      }
    }
    logger.i(
      'Guessed ${currentHolder!.information.metaData.word} as ${guesses.join(', ')}',
    );
    notifyListeners();
    return results;
  }
}

class FlashPage extends StatelessWidget {
  const FlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var fState = Provider.of<FlashState>(context);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        fState.endGracefully();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flashing: ${fState.currentLesson?.metaData.title}"),
          leading: Icon(Icons.keyboard_double_arrow_right_outlined),
        ),
        body: FlashCard(),
      ),
    );
  }
}

class FlashCard extends StatelessWidget {
  const FlashCard({super.key});

  @override
  Widget build(BuildContext context) {
    var fState = Provider.of<FlashState>(context);
    var lesson = fState.currentLesson;
    var stage = fState.stage;

    if (lesson == null || stage == -1) {
      return Text('No active flashcard.');
    }

    Widget content;
    switch (fState.stage) {
      case 100:
        content = TapRegion(
          onTapInside: (event) => fState.flip(context),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Welcome to the flashcard lesson: ${lesson.metaData.title}:',
                  ),
                  Text(lesson.metaData.description),
                  Text(
                    'This lesson contains ${lesson.metaData.vocHolderIdentifiers.length} words.',
                  ),
                  Text('Click the card to begin.'),
                ],
              ),
            ),
          ),
        );
      case 0:
        content = _ShowCardContent();
      case 1:
        content = _GuessCardContent();
      case 2:
        content = _FeedbackCardContent();
      case 101:
        content = Center(child: Text("Closing..."));
      default:
        content = Placeholder();
    }

    return Padding(padding: const EdgeInsets.all(16.0), child: content);
  }
}

class _ShowCardContent extends StatelessWidget {
  const _ShowCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var fState = Provider.of<FlashState>(context);
    var children = <Widget>[];
    var additionString = " ";
    for (var addition in fState.currentHolder!.information.vocData.additions) {
      additionString += "${addition.getFormattedString()} ";
    }
    children.add(
      Text(
        "${fState.currentHolder!.information.metaData.word}$additionString",
        style: theme.textTheme.titleLarge,
      ),
    );
    for (
      int i = 0;
      i < fState.currentHolder!.information.vocData.translations.length;
      i++
    ) {
      var translation =
          fState.currentHolder!.information.vocData.translations[i].translation;
      var string = '';
      for (String _ in translation.characters) {
        string += 'x';
      }
      children.add(
        Row(
          children: [
            getIconForIndex(i, theme.iconTheme.size ?? 40),
            SizedBox(width: 10),
            Text(string, style: theme.textTheme.displaySmall),
          ],
        ),
      );
    }

    return TapRegion(
      onTapInside: (event) => fState.flip(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: children),
        ),
      ),
    );
  }
}

class _GuessCardContent extends StatelessWidget {
  const _GuessCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    var fState = Provider.of<FlashState>(context);
    var theme = Theme.of(context);
    var length = fState.currentHolder!.information.vocData.translations.length;

    var additionString = " ";
    for (var addition in fState.currentHolder!.information.vocData.additions) {
      additionString += "${addition.getFormattedString()} ";
    }
    var text = Text(
      "${fState.currentHolder!.information.metaData.word}$additionString",
      style: theme.textTheme.titleLarge,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.filled(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            children: [
                              Text(fState.currentHolder!.information.hint),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  icon: Icon(Icons.question_mark_outlined),
                ),
                text,
                IconButton.filled(
                  onPressed: () {},
                  icon: length == 1
                      ? Icon(Icons.looks_one_outlined)
                      : length == 2
                      ? Icon(Icons.looks_two_outlined)
                      : length > 2
                      ? Icon(Icons.looks_3_outlined)
                      : Icon(Icons.help_outline),
                ),
              ],
            ),
            Expanded(child: GuessForm(fState.currentHolder!, (holder) {})),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class GuessForm extends StatefulWidget {
  VocDataHolder holder;
  final Function(VocDataHolder holder) onSubmit;

  GuessForm(this.holder, this.onSubmit, {super.key});

  @override
  State<GuessForm> createState() => _GuessFormState();
}

class _GuessFormState extends State<GuessForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _one1;
  TextEditingController? _two2;
  TextEditingController? _three3;
  TextEditingController? _four4;
  TextEditingController? _five5;
  TextEditingController? _six6;

  @override
  void dispose() {
    _one1?.dispose();
    _two2?.dispose();
    _three3?.dispose();
    _four4?.dispose();
    _five5?.dispose();
    _six6?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _one1 = TextEditingController();
    _two2 = TextEditingController();
    _three3 = TextEditingController();
    _four4 = TextEditingController();
    _five5 = TextEditingController();
    _six6 = TextEditingController();

    var fState = Provider.of<FlashState>(context);
    var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var children = <Widget>[];
    for (
      int i = 0;
      i < fState.currentHolder!.information.vocData.translations.length;
      i++
    ) {
      var translation =
          fState.currentHolder!.information.vocData.translations[i].translation;
      var string = '';
      for (String _ in translation.characters) {
        string += 'x';
      }
      children.addAll([
        Row(
          children: [
            getIconForIndex(i, theme.iconTheme.size ?? 40),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                style: theme.textTheme.displaySmall,
                controller: i == 0
                    ? _one1
                    : i == 1
                    ? _two2
                    : i == 2
                    ? _three3
                    : i == 3
                    ? _four4
                    : i == 4
                    ? _five5
                    : i == 5
                    ? _six6
                    : null,
                decoration: InputDecoration(
                  labelText: l10n.voced_translation,
                  hintText: string,
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  logger.i("Validating input: $value");
                  if (value == null || value.isEmpty) {
                    return l10n.error_enter_value;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
      ]);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...children,
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                var guesses = <String?>[
                  _one1?.text,
                  _two2?.text,
                  _three3?.text,
                  _four4?.text,
                  _five5?.text,
                  _six6?.text,
                ];
                logger.i("Guesses: $guesses");
                fState.guess(guesses);
                fState.flip(context);
                widget.onSubmit(widget.holder);
              }
            },
            label: Text(l10n.action_confirm),
            icon: Icon(Icons.check_circle_outline_outlined),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCardContent extends StatelessWidget {
  const _FeedbackCardContent({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var fState = Provider.of<FlashState>(context);
    var children = <Widget>[];
    children.add(
      Text(
        fState.currentHolder!.information.metaData.word,
        style: theme.textTheme.titleLarge,
      ),
    );
    for (
      int i = 0;
      i < fState.currentHolder!.information.vocData.translations.length;
      i++
    ) {
      var translation =
          fState.currentHolder!.information.vocData.translations[i].translation;
      var answer = fState.results.keys.elementAt(i);
      children.add(
        Row(
          children: [
            Icon(
              fState.results[answer] == true
                  ? Icons.check_circle_outline_outlined
                  : Icons.cancel_outlined,
              color: fState.results[answer] == true ? Colors.green : Colors.red,
              size: theme.iconTheme.size ?? 40,
            ),
            SizedBox(width: 10),
            Text(
              fState.results[answer] == true
                  ? answer
                  : "$answer = $translation",
              style: theme.textTheme.displaySmall,
            ),
          ],
        ),
      );
    }

    return TapRegion(
      onTapInside: (event) => fState.flip(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: children),
        ),
      ),
    );
  }
}

Icon getIconForIndex(int index, double? size) {
  switch (index) {
    case 0:
      return Icon(Icons.looks_one_outlined, size: size);
    case 1:
      return Icon(Icons.looks_two_outlined, size: size);
    case 2:
      return Icon(Icons.looks_3_outlined, size: size);
    case 3:
      return Icon(Icons.looks_4_outlined, size: size);
    case 4:
      return Icon(Icons.looks_5_outlined, size: size);
    case 5:
      return Icon(Icons.looks_6_outlined, size: size);
    default:
      return Icon(Icons.help_outline, size: size);
  }
}
