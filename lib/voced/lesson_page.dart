import 'package:flutter/material.dart';
import 'package:leejw/voced/json/lessons.dart';
import 'package:leejw/voced/voced.dart';
import 'package:provider/provider.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    var vocState = Provider.of<VocEdState>(context);

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => vocState.loadLessons(),
          label: Text("Reload Lessons"),
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