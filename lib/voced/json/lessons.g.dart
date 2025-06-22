// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonMetaData _$LessonMetaDataFromJson(Map<String, dynamic> json) =>
    LessonMetaData(
      json['title'] as String,
      json['description'] as String,
      (json['tags'] as List<dynamic>)
          .map((e) => LessonTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LessonMetaDataToJson(LessonMetaData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
    };

LessonTag _$LessonTagFromJson(Map<String, dynamic> json) =>
    LessonTag(json['name'] as String);

Map<String, dynamic> _$LessonTagToJson(LessonTag instance) => <String, dynamic>{
  'name': instance.name,
};

VocWord _$VocWordFromJson(Map<String, dynamic> json) => VocWord(
  (json['translations'] as List<dynamic>)
      .map((e) => Translation.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['meanings'] as List<dynamic>)
      .map((e) => Meaning.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VocWordToJson(VocWord instance) => <String, dynamic>{
  'translations': instance.translations.map((e) => e.toJson()).toList(),
  'meanings': instance.meanings.map((e) => e.toJson()).toList(),
};

Translation _$TranslationFromJson(Map<String, dynamic> json) => Translation(
  const LocaleJsonConverter().fromJson(json['locale'] as String),
  json['translation'] as String,
);

Map<String, dynamic> _$TranslationToJson(Translation instance) =>
    <String, dynamic>{
      'locale': const LocaleJsonConverter().toJson(instance.locale),
      'translation': instance.translation,
    };

Meaning _$MeaningFromJson(Map<String, dynamic> json) => Meaning(
  const LocaleJsonConverter().fromJson(json['locale'] as String),
  json['meaning'] as String,
);

Map<String, dynamic> _$MeaningToJson(Meaning instance) => <String, dynamic>{
  'locale': const LocaleJsonConverter().toJson(instance.locale),
  'meaning': instance.meaning,
};
