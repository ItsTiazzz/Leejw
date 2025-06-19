// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voced.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocEdEntry _$VocEdEntryFromJson(Map<String, dynamic> json) => VocEdEntry(
  VocMetaData.fromJson(json['metadata'] as Map<String, dynamic>),
  VocWord.fromJson(json['voc_data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VocEdEntryToJson(VocEdEntry instance) =>
    <String, dynamic>{
      'metadata': instance.metadata.toJson(),
      'voc_data': instance.vocWord.toJson(),
    };
