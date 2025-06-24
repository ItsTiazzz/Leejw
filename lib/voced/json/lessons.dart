import 'package:json_annotation/json_annotation.dart';

part 'lessons.g.dart';

@JsonSerializable(explicitToJson: true)
class LessonMetaData {
  final String title;
  final String description;
  @JsonKey(defaultValue: <LessonTag>[])
  final List<LessonTag> tags;

  LessonMetaData(this.title, this.description, this.tags);

  factory LessonMetaData.fromJson(Map<String, dynamic> json) => _$LessonMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$LessonMetaDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LessonTag {
  final String name;

  LessonTag(this.name);

  factory LessonTag.fromJson(Map<String, dynamic> json) => _$LessonTagFromJson(json);
  Map<String, dynamic> toJson() => _$LessonTagToJson(this);
}