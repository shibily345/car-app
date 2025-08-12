import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
    Locale('hi')
  ];

  /// The current Language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Car Zone'**
  String get appTitle;

  /// The greeting to the application
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// default line
  ///
  /// In en, this message translates to:
  /// **'Create Habits That Stick, See Results That Shine.'**
  String get tagLine;

  /// filter not completed
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get notCompleted;

  /// default line
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// default line
  ///
  /// In en, this message translates to:
  /// **'Not Today'**
  String get notToday;

  /// default line
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Label for the current streak
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Description for the user's current streak
  ///
  /// In en, this message translates to:
  /// **'Your current streak'**
  String get currentStreak;

  /// Label for the completed habit count
  ///
  /// In en, this message translates to:
  /// **'Habit\nFinished'**
  String get habitFinished;

  /// Label for the habit completion rate
  ///
  /// In en, this message translates to:
  /// **'Completion\nRate'**
  String get completionRate;

  /// Finished Times
  ///
  /// In en, this message translates to:
  /// **'{value} Times'**
  String times(String value);

  /// Number of actions completed today
  ///
  /// In en, this message translates to:
  /// **'Today: {count}'**
  String today(String count);

  /// Percentage value
  ///
  /// In en, this message translates to:
  /// **'{roundedValue} %'**
  String percentage(String roundedValue);

  /// Habit progress showing completed habits out of total required
  ///
  /// In en, this message translates to:
  /// **'{doneDates}/{needToDone} Habit'**
  String habitProgress(String doneDates, String needToDone);

  /// Message indicating successful completion for today
  ///
  /// In en, this message translates to:
  /// **'Successfully Completed Today'**
  String get successToday;

  /// Shows how many times the habit is done today out of required repetitions
  ///
  /// In en, this message translates to:
  /// **'Done {count}/{repeatPerDay}'**
  String doneToday(String count, String repeatPerDay);

  /// Label for reminders section
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// Message indicating no times were selected
  ///
  /// In en, this message translates to:
  /// **'No times selected'**
  String get noTimesSelected;

  /// Label for the calendar
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Title for the habit statistics section
  ///
  /// In en, this message translates to:
  /// **'Your Habit Statistics'**
  String get yourHabitStatistics;

  /// Completion stats for a specific day
  ///
  /// In en, this message translates to:
  /// **'{completionStats}   Completed   '**
  String completionStats(String completionStats);

  /// Call to action to start a new habit
  ///
  /// In en, this message translates to:
  /// **'Start a new habit!'**
  String get startNewHabit;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languagen;

  /// Button or link to log out
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Label for the settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Prompt to select a language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Confirmation prompt for logging out
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Confirmation button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Label for theme selection
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Title for the theme selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;
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
      <String>['ar', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
