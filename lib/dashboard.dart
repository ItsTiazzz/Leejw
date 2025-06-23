import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/main.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          Wrap(
            children: [
              DashboardEntry(text: l10n.lessons_goto, icon: Icon(Icons.collections_bookmark_outlined), onPressed: (gState) => gState.setSelectedIndex(1),),
              DashboardEntry(text: l10n.settings_goto, icon: Icon(Icons.settings_suggest_outlined), onPressed: (gState) => gState.setSelectedIndex(2),),
            ],
          )
        ],
      ),
    );
  }
}

class DashboardEntry extends StatelessWidget {
  const DashboardEntry({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Icon icon;
  final Function(GlobalState gState) onPressed;

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();
    var theme = Theme.of(context);

    return Card(
      elevation: 20,
      color: theme.cardColor.withAlpha(100),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: theme.textTheme.titleLarge,
            ),
            IconButton.filled(
              onPressed: () => onPressed(gState),
              icon: icon,
            ),
          ],
        ),
      ),
    );
  }
}