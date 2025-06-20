import 'dart:io';

import 'package:flutter/material.dart';
import 'package:leejw/voced/voced.dart';

class FlashPage extends StatelessWidget {
  const FlashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          for (var lsn in lessons)
            for (var vce in lsn.vocEntries)
              VocEdEntryCard(entry: vce),
        ],
      ),
    );
  }
}
