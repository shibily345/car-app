import 'package:car_app_beta/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(settingsController: settingsController));
}
