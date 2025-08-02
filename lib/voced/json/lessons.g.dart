// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonMetaData _$LessonMetaDataFromJson(Map<String, dynamic> json) =>
    LessonMetaData(
      json['title'] as String,
      json['description'] as String,
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      (json['voc_holder_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$LessonMetaDataToJson(LessonMetaData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'tags': instance.tags,
      'voc_holder_ids': instance.vocHolderIdentifiers,
    };
