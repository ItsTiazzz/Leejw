import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  @JsonKey(defaultValue: "dark")
  String theme;

  Settings(this.theme);

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
