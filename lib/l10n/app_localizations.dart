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

  /// No description provided for @voced_create_lesson.
  ///
  /// In en, this message translates to:
  /// **'Create new lesson'**
  String get voced_create_lesson;

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

  /// No description provided for @generic_report_bugs.
  ///
  /// In en, this message translates to:
  /// **'Report Bugs'**
  String get generic_report_bugs;

  /// No description provided for @generic_accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get generic_accessibility;

  /// No description provided for @generic_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get generic_info;

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

  /// No description provided for @settings_toggle_mode.
  ///
  /// In en, this message translates to:
  /// **'Change to {mode} mode'**
  String settings_toggle_mode(String mode);

  /// No description provided for @settings_change_locale.
  ///
  /// In en, this message translates to:
  /// **'Change Locale'**
  String get settings_change_locale;

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
