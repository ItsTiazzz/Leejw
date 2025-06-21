import 'package:flutter/material.dart';
import 'package:leejw/voced/json/lessons.dart';
import 'package:leejw/voced/voced.dart';

class FlashPage extends StatelessWidget {
  const FlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => loadLessons(),
          label: Text("Reload Lessons"),
          icon: Icon(Icons.loop),
        ),
        Expanded(
          child: ListView(
            children: [
              for (var lsn in lessons)
                LessonCard(lesson: lsn),
            ],
          ),
        ),
      ],
    );
  }
}
