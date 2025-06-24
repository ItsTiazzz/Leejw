import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class VocEdState with ChangeNotifier {
  final List<Lesson> lessons = <Lesson>[];

  void loadLessons() async {
    lessons.clear();
    Directory? appDir = await getApplicationSupportDirectory();
    final Directory vocedDir = Directory('${appDir.path}/voced');
    final Directory lessonsDir = Directory('${appDir.path}/voced/lessons');

    await vocedDir.create(recursive: true);
    await lessonsDir.create(recursive: true);

    log('Initialised ${lessonsDir.path}', time: DateTime.now(), name: 'Leejw|VocEd', level: Level.INFO.value,);

    await for (var entity in lessonsDir.list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        LessonMetaData? metaData;
        List<VocDataBundle> vocEntries = <VocDataBundle>[];

        await for (var nestEntity in entity.list(followLinks: false)) {

          if (nestEntity is File) {
            File file = nestEntity;

            if (!basename(file.path).contains('json')) continue;

            String content = await file.readAsString();

            if (basename(file.path) == 'metadata.json') {
              metaData = LessonMetaData.fromJson(jsonDecode(content));
            } else {
              final vocEntry = VocDataBundle.fromJson(jsonDecode(content));
              vocEntries.add(vocEntry);
            }
          }
        }

        lessons.add(Lesson(metaData!, vocEntries));
      }
    }

    log('Lessons: ${lessons.length}', time: DateTime.now(), name: 'Leejw|VocEd', level: Level.INFO.value,);

    notifyListeners();
  }
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

class VocDataBundleCard extends StatelessWidget {
  final VocDataBundle entry;
  const VocDataBundleCard({super.key, required this.entry});

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
            for (var translation in entry.vocData.translations)
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