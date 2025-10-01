import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leejw/flashing/flash_system.dart';
import 'package:leejw/form_fields/form_fields.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/voced.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    var l10n = AppLocalizations.of(context)!;

    if (!initialised) {
      vocState.load();

      initialised = true;
    }

    return Column(
      children: [
        SizedBox(height: 4),
        ElevatedButton.icon(
          onPressed: () => vocState.load(),
          label: Text(l10n.action_reload_lessons),
          icon: Icon(Icons.loop),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TapRegion(
                onTapInside: (event) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return LessonInsightWidget(
                          vocState.getLessons()[index],
                        );
                      },
                    ),
                  );
                  Feedback.forTap(context);
                },
                child: LessonCard(lesson: vocState.getLessons()[index]),
              );
            },
            itemCount: vocState.getLessons().length,
          ),
        ),
      ],
    );
  }
}

class LessonInsightWidget extends StatefulWidget {
  final Lesson lesson;
  const LessonInsightWidget(this.lesson, {super.key});

  @override
  State<LessonInsightWidget> createState() => _LessonInsightWidgetState();
}

class _LessonInsightWidgetState extends State<LessonInsightWidget> {
  Lesson? lesson;

  @override
  Widget build(BuildContext context) {
    setState(() {
      lesson = widget.lesson;
    });
    var l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.collections_bookmark_outlined),
            SizedBox(width: 5),
            Text(lesson!.metaData.title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LessonEditForm(
                      lesson!,
                      (newValue) => setState(() => lesson = newValue),
                    ),
                  ),
                );
              },
            ),
            icon: Icon(Icons.edit_note_outlined),
          ),
          IconButton(
            onPressed: () => showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.lesson.delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Provider.of<VocEdState>(context, listen: false).load();
                      },
                      label: Text(l10n.action_delete_forever),
                      icon: Icon(Icons.delete_forever_outlined),
                    ),
                  ],
                  title: Text(l10n.warning_delete(l10n.lessons_lesson_this_)),
                  icon: Icon(Icons.warning_amber_outlined),
                  actionsAlignment: MainAxisAlignment.center,
                );
              },
            ),
            icon: Icon(Icons.delete_outlined),
          ),
          IconButton(
            onPressed: () => Provider.of<FlashState>(
              context,
              listen: false,
            ).startLesson(lesson!, context),
            icon: Icon(Icons.not_started_outlined),
          ),
        ],
      ),
      body: Expanded(
        child: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var vocEntry in lesson!.getEntries(context))
                  Chip(label: Text(vocEntry.information.metaData.word)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LessonEditForm extends StatefulWidget {
  Lesson? lesson;
  final Function(Lesson newValue) onSubmit;

  LessonEditForm(this.lesson, this.onSubmit, {super.key});

  @override
  State<LessonEditForm> createState() => _LessonEditFormState();
}

class _LessonEditFormState extends State<LessonEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _titleClr;
  TextEditingController? _descriptionClr;

  @override
  void dispose() {
    _titleClr?.dispose();
    _descriptionClr?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tags = widget.lesson?.metaData.tags ?? [];
    List<String> vocEntries =
        widget.lesson?.metaData.vocHolderIdentifiers ?? [];
    _titleClr = TextEditingController.fromValue(
      TextEditingValue(text: widget.lesson?.metaData.title ?? ''),
    );
    _descriptionClr = TextEditingController.fromValue(
      TextEditingValue(text: widget.lesson?.metaData.description ?? ''),
    );
    var vocState = Provider.of<VocEdState>(context, listen: false);
    var l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: _titleClr,
            maxLength: 24,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.generic_title,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return l10n.error_required(l10n.generic_field_this);
              }
              return null;
            },
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _descriptionClr,
            maxLength: 64,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.generic_description,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return l10n.error_required(l10n.generic_field_this);
              }
              return null;
            },
          ),
          TagFormField(
            initialTags: tags,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.generic_tags,
              hintText: l10n.hint_separate(
                l10n.generic_tags,
                l10n.generic_commas,
              ),
            ),
            onValueChanged: (value) => tags = value,
          ),
          SizedBox(height: 8),
          ListFormField(
            initialList: vocEntries,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: l10n.generic_entries,
              hintText: l10n.hint_separate(
                l10n.voced_word_ids,
                l10n.generic_commas,
              ),
            ),
            onValueChanged: (value) => vocEntries = value,
            validate: (value) => vocState.getVocHolder(value) != null,
          ),
          SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.lesson == null) {
                  widget.lesson = Lesson(
                    File(''),
                    LessonMetaData(
                      _titleClr!.text,
                      _descriptionClr!.text,
                      tags,
                      vocEntries,
                    ),
                  );
                }
                _formKey.currentState!.save();
                widget.lesson!.metaData = LessonMetaData(
                  _titleClr!.text,
                  _descriptionClr!.text,
                  tags,
                  vocEntries,
                );
                widget.lesson!.write();
                Navigator.pop(context);
                Provider.of<VocEdState>(context, listen: false).load();
                widget.onSubmit(widget.lesson!);
                logger.i('Lesson edited: ${widget.lesson}');
              }
            },
            label: Text(l10n.action_confirm),
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class Lesson {
  File file;
  LessonMetaData metaData;

  Lesson(this.file, this.metaData);

  void delete() async {
    await file.delete(recursive: true);
  }

  void write() async {
    // Write .meta.json
    Directory appDir = await getApplicationSupportDirectory();
    File newFile = File(
      '${appDir.path}/voced/lessons/${metaData.title}.meta.json',
    );
    await newFile.create();
    var sink = newFile.openWrite();
    sink.write(jsonEncode(metaData.toJson()));
    await sink.close();
    file = newFile;
  }

  List<VocDataHolder> getEntries(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    List<VocDataHolder> list = [];

    for (var id in metaData.vocHolderIdentifiers) {
      VocDataHolder? holder = vocState.getVocHolder(id);
      if (holder != null) {
        list.add(holder);
      } else {
        logger.w(
          'Tried to find Voc Holder with id $id but returned incorrect type $holder.',
        );
      }
    }
    return list;
  }

  @override
  String toString() {
    return '{${metaData.toJson()}}';
  }
}

class LessonCard extends StatefulWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 20,
        color: theme.cardColor.withAlpha(100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                widget.lesson.metaData.title,
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 2),
              Text(
                widget.lesson.metaData.description,
                style: theme.textTheme.labelSmall,
              ),
              Wrap(
                children: [
                  for (var tag in widget.lesson.metaData.tags)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(tag, style: theme.textTheme.labelSmall),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                child: Wrap(
                  children: [
                    for (var vce in widget.lesson.getEntries(context))
                      for (var translation
                          in vce.information.vocData.translations)
                        Text(
                          '${translation.translation} ',
                          overflow: TextOverflow.fade,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
