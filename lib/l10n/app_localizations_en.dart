// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get dashboard_goto => 'Go to Dashboard';

  @override
  String get flashcards_title => 'Flashcards';

  @override
  String get flashcards_goto => 'Go to Flashcards';

  @override
  String get lessons_title => 'Lessons';

  @override
  String get lessons_goto => 'Go to your Lessons';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_goto => 'Go to Settings';

  @override
  String get voced_title => 'VocEd';

  @override
  String get voced_goto => 'Go to the VocEd';

  @override
  String get voced_create_vocdata => 'Create new voc data';

  @override
  String get voced_create_lesson => 'Create new lesson';

  @override
  String get generic_tags => 'Tags';

  @override
  String get generic_theme => 'Theme';

  @override
  String get generic_dark => 'Dark';

  @override
  String get generic_light => 'Light';

  @override
  String get generic_report_bugs => 'Report Bugs';

  @override
  String get generic_accessibility => 'Accessibility';

  @override
  String get generic_info => 'Info';

  @override
  String get action_reload_lessons => 'Reload Lessons';

  @override
  String get action_open_locale_settings => 'Open settings';

  @override
  String settings_toggle_mode(String mode) {
    return 'Change to $mode mode';
  }

  @override
  String get settings_change_locale => 'Change Locale';

  @override
  String get snackbar_locale_definement =>
      'Locales are currently defined by your device settings!';
}
