import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'json.dart';

part 'voc_data.g.dart';

@JsonSerializable(explicitToJson: true,)
class VocDataBundle {
  final VocMetaData metadata;
  @JsonKey(name: "voc_data")
  final VocData vocData;
  
  VocDataBundle(this.metadata, this.vocData);

  factory VocDataBundle.fromJson(Map<String, dynamic> json) => _$VocDataBundleFromJson(json);
  Map<String, dynamic> toJson() => _$VocDataBundleToJson(this);

  @override
  String toString() {
    return '${toJson()}';
  }
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