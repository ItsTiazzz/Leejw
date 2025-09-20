import 'package:json_annotation/json_annotation.dart';

part 'lessons.g.dart';

@JsonSerializable(explicitToJson: true)
class LessonMetaData {
  final String title;
  final String description;
  @JsonKey(defaultValue: <String>[])
  final List<String> tags;
  @JsonKey(defaultValue: <String>[], name: "voc_holder_ids")
  final List<String> vocHolderIdentifiers;

  LessonMetaData(
    this.title,
    this.description,
    this.tags,
    this.vocHolderIdentifiers,
  );

  factory LessonMetaData.fromJson(Map<String, dynamic> json) =>
      _$LessonMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$LessonMetaDataToJson(this);
}
