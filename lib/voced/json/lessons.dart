import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/voced.dart';

part 'lessons.g.dart';

class Lesson {
  final LessonMetaData metaData;
  final List<VocEdEntry> vocEntries;

  Lesson(this.metaData, this.vocEntries);
}

@JsonSerializable(explicitToJson: true)
class LessonMetaData {
  final String title;
  final String description;
  final List<LessonTag> tags;

  LessonMetaData(this.title, this.description, this.tags);

  factory LessonMetaData.fromJson(Map<String, dynamic> json) => _$LessonMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$LessonMetaDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LessonTag {
  final String name;

  LessonTag(this.name);

  factory LessonTag.fromJson(Map<String, dynamic> json) => _$LessonTagFromJson(json);
  Map<String, dynamic> toJson() => _$LessonTagToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VocWord {
  final List<Translation> translations;
  final List<Meaning> meanings;

  VocWord(this.translations, this.meanings);

  factory VocWord.fromJson(Map<String, dynamic> json) => _$VocWordFromJson(json);
  Map<String, dynamic> toJson() => _$VocWordToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Translation {
  @LocaleJsonConverter()
  final Locale locale;
  final String translation;

  Translation(this.locale, this.translation);

  factory Translation.fromJson(Map<String, dynamic> json) => _$TranslationFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Meaning {
  @LocaleJsonConverter()
  final Locale locale;
  final String meaning;
  Meaning(this.locale, this.meaning);

  factory Meaning.fromJson(Map<String, dynamic> json) => _$MeaningFromJson(json);
  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}