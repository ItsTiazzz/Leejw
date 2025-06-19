import 'dart:convert';

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
          VocEdEntryCard(entry: VocEdEntry.fromJson(jsonDecode(exampleJson))),
        ],
      ),
    );
  }
}
