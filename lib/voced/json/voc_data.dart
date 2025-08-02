import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'json.dart';

part 'voc_data.g.dart';

@JsonSerializable(explicitToJson: true)
class VocDataHolder {
  final VocMetaData metadata;
  @JsonKey(name: "voc_data")
  final VocData vocData;
  
  VocDataHolder(this.metadata, this.vocData);

  factory VocDataHolder.fromJson(Map<String, dynamic> json) => _$VocDataHolderFromJson(json);
  Map<String, dynamic> toJson() => _$VocDataHolderToJson(this);

  @override
  String toString() {
    return '${toJson()}';
  }
}

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

@JsonSerializable(explicitToJson: true)
class VocData {
  @JsonKey(defaultValue: <Addition>[])
  final List<Addition> additions;
  @JsonKey(defaultValue: <Translation>[])
  final List<Translation> translations;
  @JsonKey(defaultValue: <Meaning>[])
  final List<Meaning> meanings;

  VocData(this.additions, this.translations, this.meanings);

  factory VocData.fromJson(Map<String, dynamic> json) => _$VocDataFromJson(json);
  Map<String, dynamic> toJson() => _$VocDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Addition {
  @JsonKey(defaultValue: false)
  final bool required;
  final String addition;

  Addition(this.required, this.addition);

  factory Addition.fromJson(Map<String, dynamic> json) => _$AdditionFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionToJson(this);

  String getFormattedString() {
    return required ? '[+$addition]' : '(+$addition)';
  }
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