// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get language => 'हिन्दी';

  @override
  String get appTitle => 'Car Zone';

  @override
  String get welcome => 'स्वागत!';

  @override
  String get tagLine => 'ऐसी आदतें बनाएँ जो कायम रहें, परिणाम देखें जो चमकें।';

  @override
  String get notCompleted => 'पूरा नहीं हुआ';

  @override
  String get completed => 'पुरा होना';

  @override
  String get notToday => 'आज नहीं';

  @override
  String get all => 'सभी';

  @override
  String get streak => 'स्ट्रिक';

  @override
  String get currentStreak => 'आपकी वर्तमान स्ट्रिक';

  @override
  String get habitFinished => 'आदत\nपूरी हुई';

  @override
  String get completionRate => 'समाप्ति\nदर';

  @override
  String times(String value) {
    return '$value बार';
  }

  @override
  String today(String count) {
    return 'आज: $count';
  }

  @override
  String percentage(String roundedValue) {
    return '$roundedValue %';
  }

  @override
  String habitProgress(String doneDates, String needToDone) {
    return '$doneDates/$needToDone आदत';
  }

  @override
  String get successToday => 'आज सफलतापूर्वक पूरा हुआ';

  @override
  String doneToday(String count, String repeatPerDay) {
    return 'किया गया $count/$repeatPerDay';
  }

  @override
  String get reminders => 'अनुस्मारक';

  @override
  String get noTimesSelected => 'कोई समय चयनित नहीं';

  @override
  String get calendar => 'कैलेंडर';

  @override
  String get yourHabitStatistics => 'आपकी आदतों की सांख्यिकी';

  @override
  String completionStats(String completionStats) {
    return '$completionStats   पूर्ण   ';
  }

  @override
  String get startNewHabit => 'एक नई आदत शुरू करें!';

  @override
  String get languagen => 'भाषा';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get confirmLogout => 'लॉग आउट की पुष्टि करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get theme => 'थीम';

  @override
  String get selectTheme => 'थीम चुनें';
}
