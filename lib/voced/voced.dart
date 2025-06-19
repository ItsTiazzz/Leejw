import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leejw/voced/json/json.dart';

part 'voced.g.dart';

final Directory vocedDir = Directory.fromUri(Uri.directory('./voced/', windows: Platform.isWindows));
final Directory lessonsDir = Directory.fromUri(Uri.directory('./voced/lessons/', windows: Platform.isWindows));
final List<Directory> lessons = <Directory>[];

void initVocEd() {
  vocedDir.create();
  lessonsDir.create();

  for (var fileSystemEntity in lessonsDir.listSync()) if (fileSystemEntity is Directory) lessons.add(fileSystemEntity);
}

class VocEditorPage extends StatelessWidget {
  const VocEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
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
      },
      {
        "locale": "es",
        "translation": "Hola"
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