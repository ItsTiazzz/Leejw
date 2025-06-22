import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class LocaleJsonConverter extends JsonConverter<Locale, String> {
  const LocaleJsonConverter();

  @override
  Locale fromJson(String json) {
    return Locale(json);
  }

  @override
  String toJson(Locale object) {
    return object.languageCode;
  }
}

class DateTimeJsonConverter extends JsonConverter<DateTime, String> {
  const DateTimeJsonConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toString();
  }
}