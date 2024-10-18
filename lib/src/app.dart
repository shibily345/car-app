import 'package:car_app_beta/core/routes/routes.dart';
import 'package:car_app_beta/core/theme/app_themes.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'settings/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthenticationProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => CarsProvider()..eitherFailureOrCars(),
            ),
            ChangeNotifierProvider(
              create: (context) => CarCreateProvider()..clearAll(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserProvider()..loadUser(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, widget) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: widget!,
              );
            },
            supportedLocales: L10n.all,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            onGenerateRoute: AppRoutes.onGenerateRoutes,
          ),
        );
      },
    );
  }
}
