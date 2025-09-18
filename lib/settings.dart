import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:leejw/l10n/app_localizations.dart';
import 'package:leejw/main.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

const titleShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(20, 30)));
const shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)));
const snackBarShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)));

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var gState = context.watch<GlobalState>();
    var l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        SettingTitleCard(title: l10n.generic_theme, icon: Icon(Icons.format_paint_outlined),),
        SettingCard(
          title: Text(l10n.settings_toggle_mode(gState.isDarkMode() ? l10n.generic_light : l10n.generic_dark)),
          icon: Icon(gState.isDarkMode() ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onTap: () => gState.nextMode(),
        ),
        SettingTitleCard(title: l10n.generic_accessibility, icon: Icon(Icons.accessibility_new_outlined),),
        LocaleSettingCard(),
        SettingTitleCard(title: l10n.generic_info, icon: Icon(Icons.info_outlined)),
        ExternalLinkSettingCard(title: l10n.generic_report_bugs, uri: Uri.parse('https://github.com/ItsTiazzz/Leejw/issues')),
        StatefulBuilder(
            builder: (context, setState) => SettingCard(
              title: Text('${DateTimeFormat.onlyTimeAndSinceStart(DateTime.now())}\nClick to refresh'),
              icon: Icon(Icons.timer_outlined),
              onTap: () => setState(() {
                return;
              },),
            ),
        ),
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
      shape: titleShape,
      child: ListTile(
        shape: shape,
        leading: icon,
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium,),
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final Widget title;
  final Function() onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape,
      child: ListTile(
        shape: shape,
        leading: icon,
        title: title,
        onTap: () => onTap(),
      ),
    );
  }
}

class LocaleSettingCard extends StatelessWidget {
  const LocaleSettingCard({super.key});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return Card(
      shape: shape,
      child: ListTile(
        shape: shape,
        leading: Icon(Icons.language_outlined),
        title: Text(l10n.settings_change_locale),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.snackbar_locale_definement),
              showCloseIcon: true,
              action: SnackBarAction(
                label: l10n.action_open_locale_settings,
                onPressed: () {
                  try {
                    if (Platform.isIOS) launchUrlString("prefs:root=General&path=INTERNATIONAL/DEVICE_LANGUAGE");
                    else if (Platform.isWindows) launchUrlString("ms-settings:keyboard");
                    else if (Platform.isAndroid) AppSettings.openAppSettings(type: AppSettingsType.generalSettings); // Best I can do
                    else AppSettings.openAppSettings(type: AppSettingsType.settings); // Last resort only
                  } catch(e) {
                    logger.f('We currently can\'t open settings for ${Platform.operatingSystem} in any way.', error: e);
                  }
                },
              ),
              shape: snackBarShape,
              behavior: SnackBarBehavior.floating,
            )
          );
        },
      ),
    );
  }
}

class ExternalLinkSettingCard extends StatelessWidget {
  final String title;
  final Uri uri;
  const ExternalLinkSettingCard({super.key, required this.title, required this.uri});

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;

    return Card(
      shape: shape,
      child: ListTile(
        shape: shape,
        leading: Icon(Icons.link_outlined),
        title: Text(l10n.generic_report_bugs),
        onTap: () {
          launchUrl(uri);
        },
      ),
    );
  }
}