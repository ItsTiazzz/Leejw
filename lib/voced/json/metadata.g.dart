// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocMetaData _$VocMetaDataFromJson(Map<String, dynamic> json) => VocMetaData(
  json['word'] as String,
  json['identifier'] as String,
  const LocaleJsonConverter().fromJson(json['origin_locale'] as String),
  const DateTimeJsonConverter().fromJson(json['modified'] as String),
);

Map<String, dynamic> _$VocMetaDataToJson(
  VocMetaData instance,
) => <String, dynamic>{
  'word': instance.word,
  'identifier': instance.identifier,
  'origin_locale': const LocaleJsonConverter().toJson(instance.originLocale),
  'modified': const DateTimeJsonConverter().toJson(instance.modified),
};
