// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonMetaData _$LessonMetaDataFromJson(Map<String, dynamic> json) =>
    LessonMetaData(
      json['title'] as String,
      json['description'] as String,
      (json['tags'] as List<dynamic>?)
              ?.map((e) => LessonTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
