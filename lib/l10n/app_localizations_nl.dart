// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get dashboard_title => 'Overzicht';

  @override
  String get dashboard_goto => 'Ga naar het Overzicht';

  @override
  String get flashcards_title => 'Flitskaartjes';

  @override
  String get flashcards_goto => 'Ga naar de Flitskaartjes';

  @override
  String get lessons_title => 'Lessen';

  @override
  String get lessons_goto => 'Ga naar jouw Lessen';

  @override
  String get settings_title => 'Instellingen';

  @override
  String get settings_goto => 'Ga naar de Instellingen';

  @override
  String get voced_title => 'VocEd';

  @override
  String get voced_goto => 'Ga naar de VocEd';

  @override
  String get voced_create_lesson => 'Maak nieuwe les';

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
