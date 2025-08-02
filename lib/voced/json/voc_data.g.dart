// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voc_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VocDataHolder _$VocDataHolderFromJson(Map<String, dynamic> json) =>
    VocDataHolder(
      VocMetaData.fromJson(json['metadata'] as Map<String, dynamic>),
      VocData.fromJson(json['voc_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VocDataHolderToJson(VocDataHolder instance) =>
    <String, dynamic>{
      'metadata': instance.metadata.toJson(),
      'voc_data': instance.vocData.toJson(),
    };

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

VocData _$VocDataFromJson(Map<String, dynamic> json) => VocData(
  (json['additions'] as List<dynamic>?)
          ?.map((e) => Addition.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  (json['translations'] as List<dynamic>?)
          ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  (json['meanings'] as List<dynamic>?)
          ?.map((e) => Meaning.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$VocDataToJson(VocData instance) => <String, dynamic>{
  'additions': instance.additions.map((e) => e.toJson()).toList(),
  'translations': instance.translations.map((e) => e.toJson()).toList(),
  'meanings': instance.meanings.map((e) => e.toJson()).toList(),
};

Addition _$AdditionFromJson(Map<String, dynamic> json) =>
    Addition(json['required'] as bool? ?? false, json['addition'] as String);

Map<String, dynamic> _$AdditionToJson(Addition instance) => <String, dynamic>{
  'required': instance.required,
  'addition': instance.addition,
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
