import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light(useMaterial3: true).copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: contentColorLightTheme),
      textTheme: GoogleFonts.manropeTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: contentColorLightTheme),
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: contentColorLightTheme.withOpacity(0.7),
          unselectedItemColor: contentColorLightTheme.withOpacity(0.32),
          selectedIconTheme: const IconThemeData(color: primaryColor)));
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      primaryTextTheme: GoogleFonts.kdamThmorProTextTheme(),
      scaffoldBackgroundColor: contentColorLightTheme,
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: contentColorDarkTheme),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: contentColorDarkTheme),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: contentColorLightTheme,
          selectedItemColor: Colors.white70,
          unselectedItemColor: contentColorDarkTheme.withOpacity(0.32),
          selectedIconTheme: const IconThemeData(color: primaryColor)));
}

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  backgroundColor: primaryColor,
  iconTheme: IconThemeData(color: Colors.white,),
  titleSpacing: 0,
);
