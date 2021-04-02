import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/night_mode.dart';

ThemeData basicTheme() {
  bool nightMode = isNightMode();

  InputDecorationTheme _basicInputTheme(InputDecorationTheme base) {
    final errorColor = Color(0xffa30015);
    final borderColor = nightMode? Colors.white: Colors.black;
    return base.copyWith(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 3.0)
      ),
      filled: true,
      fillColor: nightMode? Colors.grey[900]: Colors.grey[100],
      contentPadding: EdgeInsets.all(10),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 2.0)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 3.0)
      ),
      errorStyle: TextStyle(
        color: errorColor
      ),
      hintStyle: TextStyle(color: nightMode? Colors.white38: Colors.black38)
    );
  }

  TextTheme _basicTextTheme(TextTheme base) {
    final textColorPrimary = nightMode? Colors.black: Colors.white;

    return base.copyWith(
      headline1: GoogleFonts.workSansTextTheme(base).headline1.copyWith(
        color: textColorPrimary
      ),
      headline2: GoogleFonts.workSansTextTheme(base).headline2.copyWith(
        color: textColorPrimary
      ),
      headline3: GoogleFonts.workSansTextTheme(base).headline3.copyWith(
        color: textColorPrimary
      ),
      headline4: GoogleFonts.workSansTextTheme(base).headline4.copyWith(
        color: textColorPrimary
      ),
      headline5: GoogleFonts.workSansTextTheme(base).headline5.copyWith(
        color: textColorPrimary
      ),
      headline6: GoogleFonts.workSansTextTheme(base).headline6.copyWith(
        color: textColorPrimary
      ),
      subtitle1: GoogleFonts.workSansTextTheme(base).subtitle1.copyWith(
        color: textColorPrimary
      ),
      subtitle2: GoogleFonts.workSansTextTheme(base).subtitle2.copyWith(
        color: textColorPrimary
      ),
      overline: GoogleFonts.workSansTextTheme(base).overline.copyWith(
        color: textColorPrimary
      ),
      bodyText1: GoogleFonts.karlaTextTheme(base).bodyText1.copyWith(
        color: textColorPrimary
      ),
      bodyText2: GoogleFonts.karlaTextTheme(base).bodyText2.copyWith(
        color: textColorPrimary
      ),
      button: GoogleFonts.karlaTextTheme(base).button.copyWith(
        color: textColorPrimary,
        fontSize: 18
      ),
    );
  }

  ThemeData basicTheme = nightMode? ThemeData.dark(): ThemeData.light();

  return basicTheme.copyWith(
    textTheme: _basicTextTheme(basicTheme.textTheme),
    colorScheme: basicTheme.colorScheme.copyWith(
      primary: Color(0xff3a6a8c),
      primaryVariant: Color(0xff6c8a9d),
      secondary: Color(0xff99b2dd),
      secondaryVariant: Color(0xffb4e5a0),
      background: nightMode? Colors.black: Colors.white,
      surface: Color(0xff89a1b0),
    ),
    disabledColor: Color(0xff76a5c6),
    inputDecorationTheme: _basicInputTheme(basicTheme.inputDecorationTheme),
  );
}