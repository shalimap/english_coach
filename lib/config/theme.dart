import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/color.dart';

class Themes {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      splashColor: splashColor,
      hoverColor: splashColor,
      highlightColor: splashColor,
      textTheme: GoogleFonts.solwayTextTheme(Theme.of(context).textTheme),
      fontFamily: GoogleFonts.solway().fontFamily,
      primarySwatch: primarySwatch,
      appBarTheme: AppBarTheme(
        backgroundColor: appbarcolor,
        // textTheme: GoogleFonts.solwayTextTheme(Theme.of(context).textTheme),
      ),
      primaryTextTheme:
          GoogleFonts.solwayTextTheme(Theme.of(context).textTheme),
    );
  }
}
