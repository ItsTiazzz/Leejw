import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/lessons.dart';
import 'package:leejw/voced/voced.dart';
import 'package:provider/provider.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool initLoad = false;

  @override
  void initState() {
    setState(() {
      initLoad = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);
    var l10n = AppLocalizations.of(context)!;

    if (!initLoad) {
      vocState.loadLessons();
      
      setState(() {
        initLoad = true;
      });
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