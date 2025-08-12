// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get language => 'العربية';

  @override
  String get appTitle => 'Car Zone';

  @override
  String get welcome => 'أهلاً بك!';

  @override
  String get tagLine => 'قم بإنشاء عادات تدوم، وشاهد النتائج تلمع.';

  @override
  String get notCompleted => 'لم يكتمل';

  @override
  String get completed => 'مكتمل';

  @override
  String get notToday => 'ليس اليوم';

  @override
  String get all => 'الكل';

  @override
  String get streak => 'سلسلة';

  @override
  String get currentStreak => 'سلسلتك الحالية';

  @override
  String get habitFinished => 'العادة\nمنتهية';

  @override
  String get completionRate => 'معدل\nالإكمال';

  @override
  String times(String value) {
    return '$value مرات';
  }

  @override
  String today(String count) {
    return 'اليوم: $count';
  }

  @override
  String percentage(String roundedValue) {
    return '$roundedValue %';
  }

  @override
  String habitProgress(String doneDates, String needToDone) {
    return '$doneDates/$needToDone عادة';
  }

  @override
  String get successToday => 'تمت بنجاح اليوم';

  @override
  String doneToday(String count, String repeatPerDay) {
    return 'تم $count/$repeatPerDay';
  }

  @override
  String get reminders => 'تذكيرات';

  @override
  String get noTimesSelected => 'لم يتم تحديد أوقات';

  @override
  String get calendar => 'التقويم';

  @override
  String get yourHabitStatistics => 'إحصائيات عاداتك';

  @override
  String completionStats(String completionStats) {
    return '$completionStats   مكتمل   ';
  }

  @override
  String get startNewHabit => 'ابدأ عادة جديدة!';

  @override
  String get languagen => 'اللغة';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get settings => 'الإعدادات';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get confirmLogout => 'تأكيد تسجيل الخروج';

  @override
  String get confirm => 'تأكيد';

  @override
  String get theme => 'السمة';

  @override
  String get selectTheme => 'اختر السمة';
}
