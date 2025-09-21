import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// No description provided for @dashboard_title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard_title;

  /// No description provided for @dashboard_goto.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get dashboard_goto;

  /// No description provided for @flashcards_title.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards_title;

  /// No description provided for @flashcards_goto.
  ///
  /// In en, this message translates to:
  /// **'Go to Flashcards'**
  String get flashcards_goto;

  /// No description provided for @lessons_title.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons_title;

  /// No description provided for @lessons_goto.
  ///
  /// In en, this message translates to:
  /// **'Go to your Lessons'**
  String get lessons_goto;

  /// No description provided for @lessons_lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lessons_lesson;

  /// No description provided for @lessons_lesson_this.
  ///
  /// In en, this message translates to:
  /// **'This Lesson'**
  String get lessons_lesson_this;

  /// No description provided for @lessons_lesson_this_.
  ///
  /// In en, this message translates to:
  /// **'this Lesson'**
  String get lessons_lesson_this_;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_goto.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get settings_goto;

  /// No description provided for @settings_accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settings_accessibility;

  /// No description provided for @settings_toggle_mode.
  ///
  /// In en, this message translates to:
  /// **'Change to {mode} mode'**
  String settings_toggle_mode(String mode);

  /// No description provided for @settings_change.
  ///
  /// In en, this message translates to:
  /// **'Change {change}'**
  String settings_change(String change);

  /// No description provided for @settings_report_bugs.
  ///
  /// In en, this message translates to:
  /// **'Report Bugs'**
  String get settings_report_bugs;

  /// No description provided for @voced_title.
  ///
  /// In en, this message translates to:
  /// **'VocEd'**
  String get voced_title;

  /// No description provided for @voced_goto.
  ///
  /// In en, this message translates to:
  /// **'Go to the VocEd'**
  String get voced_goto;

  /// No description provided for @voced_data.
  ///
  /// In en, this message translates to:
  /// **'Voc Data'**
  String get voced_data;

  /// No description provided for @voced_meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get voced_meaning;

  /// No description provided for @voced_meanings.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get voced_meanings;

  /// No description provided for @voced_translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get voced_translation;

  /// No description provided for @voced_translations.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get voced_translations;

  /// No description provided for @voced_addition.
  ///
  /// In en, this message translates to:
  /// **'Addition'**
  String get voced_addition;

  /// No description provided for @voced_additions.
  ///
  /// In en, this message translates to:
  /// **'Additions'**
  String get voced_additions;

  /// No description provided for @voced_word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get voced_word;

  /// No description provided for @voced_words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get voced_words;

  /// No description provided for @voced_word_this.
  ///
  /// In en, this message translates to:
  /// **'This Word'**
  String get voced_word_this;

  /// No description provided for @voced_word_this_.
  ///
  /// In en, this message translates to:
  /// **'this Word'**
  String get voced_word_this_;

  /// No description provided for @voced_word_id.
  ///
  /// In en, this message translates to:
  /// **'Word ID'**
  String get voced_word_id;

  /// No description provided for @voced_word_ids.
  ///
  /// In en, this message translates to:
  /// **'Word IDs'**
  String get voced_word_ids;

  /// No description provided for @generic_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get generic_tags;

  /// No description provided for @generic_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get generic_theme;

  /// No description provided for @generic_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get generic_dark;

  /// No description provided for @generic_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get generic_light;

  /// No description provided for @generic_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get generic_info;

  /// No description provided for @generic_value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get generic_value;

  /// No description provided for @generic_locale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get generic_locale;

  /// No description provided for @generic_locale_example.
  ///
  /// In en, this message translates to:
  /// **'Locale (e.g., en, de, fr)'**
  String get generic_locale_example;

  /// No description provided for @generic_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get generic_title;

  /// No description provided for @generic_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get generic_description;

  /// No description provided for @generic_commas.
  ///
  /// In en, this message translates to:
  /// **'Commas'**
  String get generic_commas;

  /// No description provided for @generic_entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get generic_entries;

  /// No description provided for @generic_field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get generic_field;

  /// No description provided for @generic_field_this.
  ///
  /// In en, this message translates to:
  /// **'This field'**
  String get generic_field_this;

  /// No description provided for @generic_field_this_.
  ///
  /// In en, this message translates to:
  /// **'this field'**
  String get generic_field_this_;

  /// No description provided for @error_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid!'**
  String get error_invalid;

  /// No description provided for @error_invalid_.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get error_invalid_;

  /// No description provided for @error_enter_value.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get error_enter_value;

  /// No description provided for @error_enter_locale.
  ///
  /// In en, this message translates to:
  /// **'Please enter a locale'**
  String get error_enter_locale;

  /// No description provided for @error_required.
  ///
  /// In en, this message translates to:
  /// **'{object} is required!'**
  String error_required(String object);

  /// No description provided for @error_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid {value} format'**
  String error_invalid_format(String value);

  /// No description provided for @warning_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {object}?'**
  String warning_delete(String object);

  /// No description provided for @hint_swipe_to_remove.
  ///
  /// In en, this message translates to:
  /// **'Swipe to remove'**
  String get hint_swipe_to_remove;

  /// No description provided for @hint_separate.
  ///
  /// In en, this message translates to:
  /// **'Separate {object} using {separators}'**
  String hint_separate(String object, Object separators);

  /// No description provided for @action_reload_lessons.
  ///
  /// In en, this message translates to:
  /// **'Reload Lessons'**
  String get action_reload_lessons;

  /// No description provided for @action_open_locale_settings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get action_open_locale_settings;

  /// No description provided for @action_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get action_confirm;

  /// No description provided for @action_click_refresh.
  ///
  /// In en, this message translates to:
  /// **'Click to refresh'**
  String get action_click_refresh;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_delete_forever.
  ///
  /// In en, this message translates to:
  /// **'Delete forever'**
  String get action_delete_forever;

  /// No description provided for @action_create_new.
  ///
  /// In en, this message translates to:
  /// **'Create new {object}'**
  String action_create_new(Object object);

  /// No description provided for @snackbar_locale_definement.
  ///
  /// In en, this message translates to:
  /// **'Locales are currently defined by your device settings!'**
  String get snackbar_locale_definement;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
