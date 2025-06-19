import 'package:flutter/material.dart';
import 'package:leejw/main.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();

    return ListView(
      children: [
        SettingTitleCard(title: "Theme", icon: Icon(Icons.format_paint_outlined),),
        SettingCard(
          message: "Change to ${gState.isDarkMode() ? "light" : "dark"} mode.",
          icon: Icon(gState.isDarkMode() ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onTap: () => gState.nextMode(),
        ),
        SettingTitleCard(title: "Accessibility", icon: Icon(Icons.accessibility_new_outlined),),
        LocaleSettingCard(),
      ],
    );
  }
}

class SettingTitleCard extends StatelessWidget {
  const SettingTitleCard({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(20, 30))),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        leading: icon,
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.message,
    required this.onTap,
    required this.icon,
  });

  final String message;
  final Function() onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        leading: icon,
        title: Text(message),
        onTap: () => onTap(),
      ),
    );
  }
}

class LocaleSettingCard extends StatelessWidget {
  const LocaleSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        leading: Icon(Icons.language_outlined),
        title: Text("Change locale."),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Locales are currently defined by your device settings!"),
              showCloseIcon: true,
              // width: 280.0,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 8.0,
              // ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            )
          );
        },
      ),
    );
  }
}