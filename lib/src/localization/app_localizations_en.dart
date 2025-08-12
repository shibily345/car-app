// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get appTitle => 'Car Zone';

  @override
  String get welcome => 'Welcome!';

  @override
  String get tagLine => 'Create Habits That Stick, See Results That Shine.';

  @override
  String get notCompleted => 'Not Completed';

  @override
  String get completed => 'Completed';

  @override
  String get notToday => 'Not Today';

  @override
  String get all => 'All';

  @override
  String get streak => 'Streak';

  @override
  String get currentStreak => 'Your current streak';

  @override
  String get habitFinished => 'Habit\nFinished';

  @override
  String get completionRate => 'Completion\nRate';

  @override
  String times(String value) {
    return '$value Times';
  }

  @override
  String today(String count) {
    return 'Today: $count';
  }

  @override
  String percentage(String roundedValue) {
    return '$roundedValue %';
  }

  @override
  String habitProgress(String doneDates, String needToDone) {
    return '$doneDates/$needToDone Habit';
  }

  @override
  String get successToday => 'Successfully Completed Today';

  @override
  String doneToday(String count, String repeatPerDay) {
    return 'Done $count/$repeatPerDay';
  }

  @override
  String get reminders => 'Reminders';

  @override
  String get noTimesSelected => 'No times selected';

  @override
  String get calendar => 'Calendar';

  @override
  String get yourHabitStatistics => 'Your Habit Statistics';

  @override
  String completionStats(String completionStats) {
    return '$completionStats   Completed   ';
  }

  @override
  String get startNewHabit => 'Start a new habit!';

  @override
  String get languagen => 'Language';

  @override
  String get logOut => 'Log Out';

  @override
  String get settings => 'Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get confirm => 'Confirm';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Select Theme';
}
