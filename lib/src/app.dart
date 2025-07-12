import 'package:car_app_beta/core/routes/routes.dart';
import 'package:car_app_beta/core/theme/app_themes.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.grey[50]
      ..contentPadding = const EdgeInsets.all(25)
      ..maskColor = Colors.transparent
      ..indicatorColor = Colors.grey
      ..textColor = Theme.of(context).colorScheme.primary
      ..indicatorSize = 45
      ..radius = 10
      ..userInteractions = false
      ..indicatorType = EasyLoadingIndicatorType.threeBounce;
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
      child: ScreenUtilInit(
        designSize: const Size(430, 932), // Set your design size here
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: EasyLoading.init(
              builder: (context, widget) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: widget!,
                );
              },
            ),
            supportedLocales: L10n.all,
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,
            theme: lightTheme(context),
            // darkTheme: darkTheme(context),
            onGenerateRoute: AppRoutes.onGenerateRoutes,
          );
        },
      ),
    );
  }
}
