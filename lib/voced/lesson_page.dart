import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/voced_page.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tag_form_field/tag_field.dart';

var initialised = false;

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    var l10n = AppLocalizations.of(context)!;

    if (!initialised) {
      vocState.loadLessons();
      
      initialised = true;
    }

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => vocState.loadLessons(),
          label: Text(l10n.action_reload_lessons),
          icon: Icon(Icons.loop),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var lesson in vocState.lessons)
                TapRegion(
                  onTapInside: (event) {
                    Navigator.push<Widget>(context, 
                      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
                        return LessonInsightWidget(lesson);
                      },)
                    );
                    Feedback.forTap(context);
                  },
                  child: LessonCard(lesson: lesson)
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class LessonInsightWidget extends StatefulWidget {
  final Lesson lesson;
  const LessonInsightWidget(this.lesson, {super.key,});

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.collections_bookmark_outlined),
            SizedBox(width: 5,),
            Text(lesson!.metaData.title),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(context: context,
              builder: (context) {
                return Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LessonEditForm(lesson!, (newValue) => setState(() => lesson = newValue)),
                  ),
                );
              },
            ),
            icon: Icon(Icons.edit_note_outlined),
          ),
          IconButton(
            onPressed: () => showAdaptiveDialog(context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  actions: [
                    ElevatedButton.icon(
                      onPressed: () {
                        widget.lesson.delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Provider.of<VocEdState>(context, listen: false).loadLessons();
                      },
                      label: Text("Delete forever"),
                      icon: Icon(Icons.delete_forever_outlined),
                    )
                  ],
                  title: Text('Are you sure you want to delete this lesson?'),
                  icon: Icon(Icons.warning_amber_outlined),
                  actionsAlignment: MainAxisAlignment.center,
                );
              },
            ),
            icon: Icon(Icons.delete_outlined),
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
                for (var vocEntry in lesson!.vocEntries)
                  Chip(label: Text(vocEntry.metadata.word))
              ],
            ),
          ),
        )
      ),
    );
  }
}

class LessonEditForm extends StatefulWidget {
  final Lesson lesson;
  final Function(Lesson newValue) onLessonChanged;

  const LessonEditForm(this.lesson, this.onLessonChanged, {super.key});

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
    List<String> tags = widget.lesson.metaData.tags;
    _titleClr = TextEditingController.fromValue(TextEditingValue(text: widget.lesson.metaData.title));
    _descriptionClr = TextEditingController.fromValue(TextEditingValue(text: widget.lesson.metaData.description));

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
              labelText: 'Title',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              return null;
            },
          ),
          SizedBox(height: 12,),
          TextFormField(
            controller: _descriptionClr,
            maxLength: 64,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              return null;
            },
          ),
          TagFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tags',
              hintText: 'Separate tags using commas',
            ),
            onValueChanged: (value) => setState(() => tags = value,),
          ),
          SizedBox(height: 8,),
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.lesson.metaData = LessonMetaData(_titleClr!.text, _descriptionClr!.text, tags);
                widget.lesson.write();
                Navigator.pop(context);
                Provider.of<VocEdState>(context, listen: false).loadLessons();
                widget.onLessonChanged(widget.lesson);
                log('Lesson edited: ${widget.lesson}', name: 'Leejw|Lesson Editor', level: Level.INFO.value);
              }
            },
            label: const Text('Confirm'),
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

class Lesson {
  final Directory directory;
  LessonMetaData metaData;
  final List<VocDataBundle> vocEntries;

  Lesson(this.directory, this.metaData, this.vocEntries);

  void delete() async {
    await directory.delete(recursive: true);
  }

  void write() async {
    // Write metadata.json
    var metaDataFile = File('${directory.path}/metadata.json');
    await  metaDataFile.create();
    var sink = metaDataFile.openWrite();
    sink.write(jsonEncode(metaData.toJson()));
    await sink.close();

    // Write voc entry jsons
    for (var vocEntry in vocEntries) {
      var file = File('${directory.path}/${vocEntry.metadata.identifier}.json');
      await file.create();

      var sink = file.openWrite();
      sink.write(jsonEncode(vocEntry.toJson()));
      await sink.close();
    }
  }

  @override
  String toString() {
    return '{${metaData.toJson()},$vocEntries}';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.lesson.metaData.title, style: theme.textTheme.titleLarge,),
              SizedBox(height: 2,),
              Text(widget.lesson.metaData.description, style: theme.textTheme.labelSmall,),
              Wrap(
                children: [
                  for (var tag in widget.lesson.metaData.tags)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(tag, style: theme.textTheme.labelSmall,),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10,),
              Card(
                child: Wrap(
                  children: [
                    for (var vce in widget.lesson.vocEntries)
                      for (var translation in vce.vocData.translations)
                        Text('${translation.translation} ', overflow: TextOverflow.fade,),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}