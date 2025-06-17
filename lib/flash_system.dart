import 'package:flutter/material.dart';

class FlashCard extends StatelessWidget {
  const FlashCard({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(

    );
  }
}

class FlashWord {
  FlashWord({
    required this.word,
    this.locale,
  });

  final String word;
  Locale? locale;
}

class FlashTranslation extends FlashWord {
  FlashTranslation({
    required super.word,
    required this.translation,
  });

  final FlashWord translation;
}

class FlashMeaning extends FlashWord {
  FlashMeaning({
    required super.word,
    required this.meaning,
  });

  final FlashWord meaning;
}
