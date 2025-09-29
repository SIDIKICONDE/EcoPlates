import 'package:flutter/cupertino.dart';

class CupertinoThemeConfig {
  static const Color primaryColor = CupertinoColors.systemGreen;
  static const Color secondaryColor = Color(0xFF8BC34A);
  static const Color errorColor = CupertinoColors.systemRed;

  static CupertinoThemeData lightTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryContrastingColor: CupertinoColors.white,
    barBackgroundColor: CupertinoColors.systemBackground,
    scaffoldBackgroundColor: CupertinoColors.systemBackground,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.label,
      textStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: CupertinoColors.label,
      ),
      actionTextStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: primaryColor,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 17,
        letterSpacing: -0.41,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.label,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 34,
        letterSpacing: 0.41,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.label,
      ),
    ),
  );

  static CupertinoThemeData darkTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    primaryContrastingColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.darkBackgroundGray,
    scaffoldBackgroundColor: CupertinoColors.black,
    textTheme: CupertinoTextThemeData(
      primaryColor: CupertinoColors.white,
      textStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: CupertinoColors.white,
      ),
      actionTextStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: primaryColor,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 17,
        letterSpacing: -0.41,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.white,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 34,
        letterSpacing: 0.41,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.white,
      ),
    ),
  );
}
