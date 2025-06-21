import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'voced.g.dart';

final List<Lesson> lessons = <Lesson>[];

void initVocEd() async {
  await loadLessons();
}

Future<void> loadLessons() async {
  lessons.clear();
  Directory? appDir = await getApplicationSupportDirectory();
  final Directory vocedDir = Directory('${appDir.path}/voced');
  final Directory lessonsDir = Directory('${appDir.path}/voced/lessons');

  await vocedDir.create(recursive: true);
  await lessonsDir.create(recursive: true);

  print('Initialised ${lessonsDir.path}');

  await for (var entity in lessonsDir.list(recursive: true, followLinks: false)) {
    if (entity is Directory) {
      LessonMetaData? metaData;
      List<VocEdEntry> vocEntries = <VocEdEntry>[];

      await for (var nestEntity in entity.list(followLinks: false)) {

        if (nestEntity is File) {
          File file = nestEntity;

          if (!basename(file.path).contains('json')) continue;

          String content = await file.readAsString();

          if (basename(file.path) == 'metadata.json') {
            metaData = LessonMetaData.fromJson(jsonDecode(content));
          } else {
            final vocEntry = VocEdEntry.fromJson(jsonDecode(content));
            vocEntries.add(vocEntry);
          }
        }
      }

      lessons.add(Lesson(metaData!, vocEntries));
    }
  }

  print('Lessons: ${lessons.length}');
}

class VocEditorPage extends StatelessWidget {
  const VocEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.note_add_outlined),
          onPressed: () {
            
          },
          label: Text(l10n.voced_create_lesson)
        ),
      ],
    );
  }
}

@JsonSerializable(explicitToJson: true,)
class VocEdEntry {
  final VocMetaData metadata;
  @JsonKey(name: "voc_data")
  final VocWord vocWord;
  
  VocEdEntry(this.metadata, this.vocWord);

  factory VocEdEntry.fromJson(Map<String, dynamic> json) => _$VocEdEntryFromJson(json);
  Map<String, dynamic> toJson() => _$VocEdEntryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

class VocEdEntryCard extends StatelessWidget {
  final VocEdEntry entry;
  const VocEdEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    // var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context);

    return Card(
      elevation: 10,
      color: Theme.of(context).cardColor.withAlpha(180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(entry.metadata.word, style: theme.textTheme.headlineMedium,),
            SizedBox(height: 10,),
            for (var translation in entry.vocWord.translations)
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: CircleAvatar(radius: 14, child: Icon(Icons.language_outlined)),
                    ),
                    Text(translation.translation),
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }
}

const exampleJson = '''
{
  "metadata": {
    "word": "Hello",
    "identifier": "hello",
    "origin_locale": "en",
    "modified": "2023-05-10"
  },
  "voc_data": {
    "translations": [
      {
        "locale": "nl",
        "translation": "Hallo"
      },
      {
        "locale": "fr",
        "translation": "Salut"
      },
      {
        "locale": "es",
        "translation": "Hola"
      }
    ],
    "meanings": [
      {
        "locale": "en",
        "meaning": "A greeting word."
      },
      {
        "locale": "nl",
        "meaning": "Een groetwoord."
      }
    ]
  }
}
''';