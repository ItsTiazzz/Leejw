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
  String get lessons_lesson => 'Lesson';

  @override
  String get lessons_lesson_this => 'This Lesson';

  @override
  String get lessons_lesson_this_ => 'this Lesson';

  @override
  String get settings_title => 'Instellingen';

  @override
  String get settings_goto => 'Ga naar de Instellingen';

  @override
  String get settings_accessibility => 'Accessibility';

  @override
  String settings_toggle_mode(String mode) {
    return 'Change to $mode mode';
  }

  @override
  String settings_change(String change) {
    return 'Change $change';
  }

  @override
  String get settings_report_bugs => 'Report Bugs';

  @override
  String get voced_title => 'VocEd';

  @override
  String get voced_goto => 'Ga naar de VocEd';

  @override
  String get voced_data => 'Voc Data';

  @override
  String get voced_meaning => 'Meaning';

  @override
  String get voced_meanings => 'Meanings';

  @override
  String get voced_translation => 'Translation';

  @override
  String get voced_translations => 'Translations';

  @override
  String get voced_addition => 'Addition';

  @override
  String get voced_additions => 'Additions';

  @override
  String get voced_word => 'Word';

  @override
  String get voced_words => 'Words';

  @override
  String get voced_word_this => 'This Word';

  @override
  String get voced_word_this_ => 'this Word';

  @override
  String get voced_word_id => 'Word ID';

  @override
  String get voced_word_ids => 'Word IDs';

  @override
  String get generic_tags => 'Tags';

  @override
  String get generic_theme => 'Theme';

  @override
  String get generic_dark => 'Dark';

  @override
  String get generic_light => 'Light';

  @override
  String get generic_info => 'Info';

  @override
  String get generic_value => 'Value';

  @override
  String get generic_locale => 'Locale';

  @override
  String get generic_locale_example => 'Locale (e.g., en, de, fr)';

  @override
  String get generic_title => 'Title';

  @override
  String get generic_description => 'Description';

  @override
  String get generic_commas => 'Commas';

  @override
  String get generic_entries => 'Entries';

  @override
  String get generic_field => 'Field';

  @override
  String get generic_field_this => 'This field';

  @override
  String get generic_field_this_ => 'this field';

  @override
  String get error_invalid => 'Invalid!';

  @override
  String get error_invalid_ => 'Invalid';

  @override
  String get error_enter_value => 'Please enter a value';

  @override
  String get error_enter_locale => 'Please enter a locale';

  @override
  String error_required(String object) {
    return '$object is required!';
  }

  @override
  String error_invalid_format(String value) {
    return 'Invalid $value format';
  }

  @override
  String warning_delete(String object) {
    return 'Are you sure you want to delete $object?';
  }

  @override
  String get hint_swipe_to_remove => 'Swipe to remove';

  @override
  String hint_separate(String object, String separators) {
    return 'Separate $object using $separators';
  }

  @override
  String get action_reload_lessons => 'Reload Lessons';

  @override
  String get action_open_locale_settings => 'Open settings';

  @override
  String get action_confirm => 'Confirm';

  @override
  String get action_click_refresh => 'Click to refresh';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_delete_forever => 'Delete forever';

  @override
  String action_create_new(Object object) {
    return 'Create new $object';
  }

  @override
  String get snackbar_locale_definement =>
      'Locales are currently defined by your device settings!';
}
