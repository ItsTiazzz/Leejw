import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leejw/voced/json/lessons.dart';
import 'package:leejw/voced/json/voc_data.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class VocEdState with ChangeNotifier {
  final List<Lesson> _lessons = <Lesson>[];
  final List<VocDataHolder> _vocHolders = <VocDataHolder>[];

  Future<Map<String, List<dynamic>>> load() async {
    Directory? appDir = await getApplicationSupportDirectory();
    final Directory vocedDir = Directory('${appDir.path}/voced');
    final Directory lessonsDir = Directory('${appDir.path}/voced/lessons');
    final Directory vocDataDir = Directory('${appDir.path}/voced/voc');

    await vocedDir.create(recursive: true);
    await lessonsDir.create(recursive: true);
    await vocDataDir.create(recursive: true);

    log('Initialised ${lessonsDir.path} and ${vocDataDir.path}', time: DateTime.now(), name: 'Leejw|VocEd', level: Level.INFO.value,);

    _lessons.clear();
    await for (var entity in lessonsDir.list(followLinks: false)) {
      if (entity is File) {        
        if (basename(entity.path).endsWith(".meta.json")) {
          String content = await entity.readAsString();
          LessonMetaData metaData = LessonMetaData.fromJson(jsonDecode(content));
          _lessons.add(Lesson(entity, metaData));
        }
      } else await entity.delete(recursive: true);
    }

    log('Lessons: ${_lessons.length}', time: DateTime.now(), name: 'Leejw|VocEd', level: Level.INFO.value,);

    _vocHolders.clear();
    await for (var entity in vocDataDir.list(followLinks: false)) {
      if (entity is File) {
        if (basename(entity.path).endsWith(".voc.json")) {
          String content = await entity.readAsString();
          VocDataHolder holder = VocDataHolder.fromJson(jsonDecode(content));
          _vocHolders.add(holder);
        }
      } else await entity.delete(recursive: true);
    }

    log('Voc Data Holders: ${_vocHolders.length}', time: DateTime.now(), name: 'Leejw|VocEd', level: Level.INFO.value,);

    notifyListeners();
    return Future<Map<String, List<dynamic>>>(() {
      return {"lessons": _lessons, "voc": _vocHolders};
    });
  }

  Map<String, List<dynamic>> getAll() {
    return {"lessons": _lessons, "voc": _vocHolders};
  }

  List<Lesson> getLessons() {
    return _lessons;
  }

  List<VocDataHolder> getVocHolders() {
    return _vocHolders;
  }

  VocDataHolder? getVocHolder(String id) {
    try {
      return getVocHolders().singleWhere((element) => element.metadata.identifier == id,);
    } catch (e) {
      return null;
    }
  }
}