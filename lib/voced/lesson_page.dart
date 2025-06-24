import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';
import 'package:leejw/voced/voced.dart';
import 'package:provider/provider.dart';

var initialised = false;

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    var l10n = AppLocalizations.of(context)!;

    if (!initialised) {
      vocState.loadLessons();
      
      initialised = true;
    }

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => vocState.loadLessons(),
          label: Text(l10n.action_reload_lessons),
          icon: Icon(Icons.loop),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var lsn in vocState.lessons)
                LessonCard(lesson: lsn),
            ],
          ),
        ),
      ],
    );
  }
}

class Lesson {
  final LessonMetaData metaData;
  final List<VocDataBundle> vocEntries;

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
              Text(widget.lesson.metaData.description, style: theme.textTheme.labelSmall,),
              Wrap(
                children: [
                  for (var tag in widget.lesson.metaData.tags)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
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
                        for (var translation in vce.vocData.translations)
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