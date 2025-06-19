import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:leejw/voced/json/json.dart';

part 'metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class VocMetaData {
  final String word;
  final String identifier;
  @LocaleJsonConverter()
  @JsonKey(name: 'origin_locale')
  final Locale originLocale;
  @DateTimeJsonConverter()
  final DateTime modified;

  VocMetaData(this.word, this.identifier, this.originLocale, this.modified,);

  factory VocMetaData.fromJson(Map<String, dynamic> json) => _$VocMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$VocMetaDataToJson(this);
}