import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Colors.transparent),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Muli',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      appBarTheme: appBarTheme());
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0XFF8B8B8B)),
    titleTextStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    primaryColor: const Color.fromARGB(255, 242, 205, 248),
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    hoverColor: Colors.black,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 43, 43, 43),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateColor.resolveWith(
          (states) => Theme.of(context).colorScheme.primary,
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(indicatorColor: Colors.white),
    // dialogTheme: DialogTheme(
    //   surfaceTintColor: Theme.of(context).colorScheme.primary,
    //   iconColor: Theme.of(context).colorScheme.primary,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    // ),
  );
}

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
