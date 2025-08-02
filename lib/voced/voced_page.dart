import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/voced/json/json.dart';

class VocEditorPage extends StatelessWidget {
  const VocEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.note_add_outlined),
          onPressed: () {
            
          },
          label: Text(l10n.voced_create_lesson)
        ),
      ],
    );
  }
}

class VocDataBundleCard extends StatelessWidget {
  final VocDataBundle entry;
  const VocDataBundleCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    // var l10n = AppLocalizations.of(context)!;
    var theme = Theme.of(context);

    return Card(
      elevation: 10,
      color: Theme.of(context).cardColor.withAlpha(180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(entry.metadata.word, style: theme.textTheme.headlineMedium,),
            SizedBox(height: 10,),
            for (var translation in entry.vocData.translations)
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.5),
                      child: CircleAvatar(radius: 14, child: Icon(Icons.language_outlined)),
                    ),
                    Text(translation.translation),
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }
}