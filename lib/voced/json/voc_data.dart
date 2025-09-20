import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'json.dart';

part 'voc_data.g.dart';

class VocDataHolder {
  File file;
  VocDataHolderJson information;

  VocDataHolder(this.file, this.information);

  void delete() async {
    await file.delete(recursive: true);
  }

  void write() async {
    // Write .voc.json
    Directory appDir = await getApplicationSupportDirectory();
    File newFile = File(
      '${appDir.path}/voced/voc/${information.metaData.identifier}.voc.json',
    );
    await newFile.create();
    var sink = newFile.openWrite();
    sink.write(jsonEncode(information.toJson()));
    await sink.close();
    file = newFile;
  }

  @override
  String toString() {
    return '{${information.toJson()}}';
  }
}

@JsonSerializable(explicitToJson: true)
class VocDataHolderJson {
  @JsonKey(name: "metadata")
  final VocMetaData metaData;
  @JsonKey(name: "voc_data")
  final VocData vocData;

  VocDataHolderJson(this.metaData, this.vocData);

  factory VocDataHolderJson.fromJson(Map<String, dynamic> json) =>
      _$VocDataHolderJsonFromJson(json);
  Map<String, dynamic> toJson() => _$VocDataHolderJsonToJson(this);

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

  VocMetaData(this.word, this.identifier, this.originLocale);

  factory VocMetaData.fromJson(Map<String, dynamic> json) =>
      _$VocMetaDataFromJson(json);
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

  factory VocData.fromJson(Map<String, dynamic> json) =>
      _$VocDataFromJson(json);
  Map<String, dynamic> toJson() => _$VocDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Addition {
  @JsonKey(defaultValue: false)
  final bool required;
  final String addition;

  Addition(this.required, this.addition);

  factory Addition.fromJson(Map<String, dynamic> json) =>
      _$AdditionFromJson(json);
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
  @JsonKey(defaultValue: -1)
  final int group;

  Translation(this.locale, this.translation, this.group);

  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Meaning {
  @LocaleJsonConverter()
  final Locale locale;
  final String meaning;
  @JsonKey(defaultValue: -1)
  final int group;

  Meaning(this.locale, this.meaning, this.group);

  factory Meaning.fromJson(Map<String, dynamic> json) =>
      _$MeaningFromJson(json);
  Map<String, dynamic> toJson() => _$MeaningToJson(this);
}
