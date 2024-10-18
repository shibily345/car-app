import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SettingsProvider();

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode? get themeMode => _themeMode;

  void toggleTheme(ThemeMode theme) {
    _themeMode = theme;
    notifyListeners();
  }

  void showLanguageDialog(var ln, BuildContext ctx) {
    notifyListeners();
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ln.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: _locale.languageCode,
                onChanged: (String? value) {
                  setLocale(Locale(value!));
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Hindi'),
                value: 'hi',
                groupValue: _locale.languageCode,
                onChanged: (String? value) {
                  setLocale(Locale(value!));

                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('Arabic'),
                value: 'ar',
                groupValue: _locale.languageCode,
                onChanged: (String? value) {
                  setLocale(Locale(value!));

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showThemeDialog(BuildContext context, var ln) {
    notifyListeners();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ln.selectTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: _themeMode,
                onChanged: (ThemeMode? value) {
                  toggleTheme(value!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light Mode'),
                value: ThemeMode.light,
                groupValue: _themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    toggleTheme(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark Mode'),
                value: ThemeMode.dark,
                groupValue: _themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    toggleTheme(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showLogoutDialog(var ln, BuildContext ctx) {
    notifyListeners();
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(ln.confirmLogout),
          actions: [
            ButtonDef(
              width: 70,
              things: TextDef(ln.confirm),
              onTap: () {
                context.read<AuthenticationProvider>().logout(context);
              },
            )
          ],
        );
      },
    );
  }
}
