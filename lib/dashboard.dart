import 'package:flutter/material.dart';
import 'package:leejw/main.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DashboardEntry(text: "Your progress:", icon: Icon(Icons.flash_on_outlined), onPressed: (gState) => gState.setSelectedIndex(1),),
              DashboardEntry(text: "Settings:", icon: Icon(Icons.settings_suggest_outlined), onPressed: (gState) => gState.setSelectedIndex(2),),
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
      elevation: 8,
      child: Padding(
      padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: theme.textTheme.displaySmall,
            ),
            SizedBox(height: 10,),
            IconButton(
              onPressed: () => onPressed(gState),
              icon: icon,
            ),
          ],
        ),
      ),
    );
  }
}