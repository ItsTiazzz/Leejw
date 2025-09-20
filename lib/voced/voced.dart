import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leejw/voced/json/lessons.dart';
import 'package:leejw/voced/json/voc_data.dart';
import 'package:leejw/voced/lesson_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../form_fields/form_fields.dart';
import '../main.dart';

var initialised = false;

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

    logger.i('Initialised ${lessonsDir.path} and ${vocDataDir.path}');

    _lessons.clear();
    await for (var entity in lessonsDir.list(followLinks: false)) {
      if (entity is File) {
        if (basename(entity.path).endsWith(".meta.json")) {
          String content = await entity.readAsString();
          LessonMetaData metaData = LessonMetaData.fromJson(
            jsonDecode(content),
          );
          _lessons.add(Lesson(entity, metaData));
        }
      } else
        await entity.delete(recursive: true);
    }

    logger.i('Lessons: ${_lessons.length}');

    _vocHolders.clear();
    await for (var entity in vocDataDir.list(followLinks: false)) {
      if (entity is File) {
        if (basename(entity.path).endsWith(".voc.json")) {
          String content = await entity.readAsString();
          VocDataHolder holder = VocDataHolder(
            entity,
            VocDataHolderJson.fromJson(jsonDecode(content)),
          );
          _vocHolders.add(holder);
        }
      } else
        await entity.delete(recursive: true);
    }

    logger.i('Voc Data Holders: ${_vocHolders.length}');

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

  List<Lesson> addLesson(Lesson lesson) {
    _lessons.add(lesson);
    lesson.write();
    notifyListeners();
    return _lessons;
  }

  List<VocDataHolder> getVocHolders() {
    return _vocHolders;
  }

  List<VocDataHolder> addVocHolder(VocDataHolder holder) {
    _vocHolders.add(holder);
    holder.write();
    notifyListeners();
    return _vocHolders;
  }

  VocDataHolder? getVocHolder(String id) {
    try {
      return getVocHolders().singleWhere(
        (element) => element.information.metaData.identifier == id,
      );
    } catch (e) {
      return null;
    }
  }
}

// ignore: must_be_immutable
class VocDataHolderEditForm extends StatefulWidget {
  VocDataHolder? holder;
  final Function(VocDataHolder holder) onSubmit;

  VocDataHolderEditForm(this.holder, this.onSubmit, {super.key});

  @override
  State<VocDataHolderEditForm> createState() => _VocDataHolderEditFormState();
}

class _VocDataHolderEditFormState extends State<VocDataHolderEditForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StringWithLocale? string;

  @override
  Widget build(BuildContext context) {
    List<StringWithLocale> meanings = [];
    List<StringWithLocale> translations = [];
    List<Requirement> additions = [];
    if (widget.holder != null) {
      string = StringWithLocale(
        widget.holder!.information.metaData.word,
        widget.holder!.information.metaData.originLocale,
        -1,
      );
      meanings.addAll(
        widget.holder!.information.vocData.meanings.map(
          (e) => StringWithLocale(e.meaning, e.locale, e.group),
        ),
      );
      translations.addAll(
        widget.holder!.information.vocData.translations.map(
          (e) => StringWithLocale(e.translation, e.locale, e.group),
        ),
      );
      additions.addAll(
        widget.holder!.information.vocData.additions.map(
          (e) => Requirement(e.addition, e.required),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StringWithLocaleFormField(
            string,
            (value) => setState(() => string = value),
          ),
          SizedBox(height: 8),
          StringWithLocaleListFormField(
            label: Text('Meanings'),
            initialValues: meanings,
            onValueChanged: (value) => meanings = value,
            validate: (value) => value.value.isNotEmpty,
          ),
          SizedBox(height: 8),
          StringWithLocaleListFormField(
            label: Text('Translations'),
            initialValues: translations,
            onValueChanged: (value) => translations = value,
            validate: (value) => value.value.isNotEmpty,
          ),
          SizedBox(height: 8),
          RequirementsFormField(
            initialRequirements: additions,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Additions',
              hintText: 'Seperate entries using commas',
            ),
            onValueChanged: (value) => additions = value,
          ),
          FilledButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.holder = VocDataHolder(
                  widget.holder?.file ?? File(''),
                  VocDataHolderJson(
                    VocMetaData(
                      string!.value,
                      string!.value.replaceAll(' ', '-').toLowerCase(),
                      string!.locale,
                    ),
                    VocData(
                      additions
                          .map((e) => Addition(e.required ?? true, e.value))
                          .toList(),
                      translations
                          .map((e) => Translation(e.locale, e.value, e.group))
                          .toList(),
                      meanings
                          .map((e) => Meaning(e.locale, e.value, e.group))
                          .toList(),
                    ),
                  ),
                );
                widget.holder!.write();
                Navigator.pop(context);
                Provider.of<VocEdState>(context, listen: false).load();
                widget.onSubmit(widget.holder!);
                logger.i('Holder edited: ${widget.holder}');
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
