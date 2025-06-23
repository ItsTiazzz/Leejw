import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/voced.dart';

part 'lessons.g.dart';

class Lesson {
  final LessonMetaData metaData;
  final List<VocEdEntry> vocEntries;

  Lesson(this.metaData, this.vocEntries);
}

class LessonCard extends StatefulWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var l10n = AppLocalizations.of(context)!;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 20,
        color: theme.cardColor.withAlpha(100),
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.lesson.metaData.title, style: theme.textTheme.titleLarge,),
              SizedBox(height: 2,),
              Text('${widget.lesson.metaData.description}; ${l10n.generic_tags}:', style: theme.textTheme.labelSmall,),
              Wrap(
                children: [
                  for (var tag in widget.lesson.metaData.tags)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(tag.name, style: theme.textTheme.labelSmall,),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 10,),
              for (var i = 0; i < 2; i++)
                Card(
                  color: theme.cardColor.withValues(),
                  child: Wrap(
                    children: [
                      for (var vce in widget.lesson.vocEntries)
                        for (var translation in vce.vocWord.translations)
                          Text('${translation.translation} ', overflow: TextOverflow.fade,),
                    ],
                  ),
                ),
            ],
          )
        ),
      ),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LessonMetaData {
  final String title;
  final String description;
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

@JsonSerializable(explicitToJson: true)
class VocWord {
  final List<Translation> translations;
  final List<Meaning> meanings;

  VocWord(this.translations, this.meanings);

  factory VocWord.fromJson(Map<String, dynamic> json) => _$VocWordFromJson(json);
  Map<String, dynamic> toJson() => _$VocWordToJson(this);
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