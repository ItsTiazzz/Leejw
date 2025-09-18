import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:leejw/voced/voced.dart';
import 'package:provider/provider.dart';

class VocEditorPage extends StatelessWidget {
  const VocEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context);

    if (!initialised) {
      vocState.load();

      initialised = true;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 4),
            ElevatedButton.icon(
              icon: Icon(Icons.add_card_outlined),
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: VocDataHolderEditForm(
                        null,
                        (newValue) => vocState.addVocHolder(newValue),
                      ),
                    ),
                  );
                },
              ),
              label: Text(l10n.voced_create_vocdata),
            ),
            SizedBox(width: 4),
            ElevatedButton.icon(
              icon: Icon(Icons.note_add_outlined),
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LessonEditForm(
                        null,
                        (newValue) => vocState.addLesson(newValue),
                      ),
                    ),
                  );
                },
              ),
              label: Text(l10n.voced_create_lesson),
            ),
          ],
        ),
        Divider(
          thickness: 3,
          color: theme.buttonTheme.colorScheme?.primary,
          endIndent: 15,
          indent: 15,
          radius: BorderRadius.circular(30),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) =>
                VocHolderCard(holder: vocState.getVocHolders()[index]),
            itemCount: vocState.getVocHolders().length,
          ),
        ),
      ],
    );
  }
}

class VocHolderCard extends StatefulWidget {
  final VocDataHolder holder;

  const VocHolderCard({super.key, required this.holder});

  @override
  State<VocHolderCard> createState() => _VocHolderCardState();
}

class _VocHolderCardState extends State<VocHolderCard> {
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
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.holder.information.metaData.word,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.holder.information.metaData.identifier,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: widget.holder.information.metaData.identifier,
                        ),
                      );
                    },
                    icon: Icon(Icons.content_copy_outlined),
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: VocDataHolderEditForm(
                              widget.holder,
                              (newValue) => null,
                            ),
                          ),
                        );
                      },
                    ),
                    icon: Icon(Icons.edit_note_outlined),
                  ),
                ],
              ),
              SizedBox(width: 4),
              ElevatedButton.icon(
                onPressed: () => showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog.adaptive(
                      actions: [
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.holder.delete();
                            Navigator.pop(context);
                            Provider.of<VocEdState>(
                              context,
                              listen: false,
                            ).load();
                          },
                          label: Text("Delete forever"),
                          icon: Icon(Icons.delete_forever_outlined),
                        ),
                      ],
                      title: Text('Are you sure you want to delete this word?'),
                      icon: Icon(Icons.warning_amber_outlined),
                      actionsAlignment: MainAxisAlignment.center,
                    );
                  },
                ),
                label: Icon(Icons.delete_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
