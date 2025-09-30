import 'package:flutter/cupertino.dart';
import 'tokens/deep_color_tokens.dart';

class CupertinoThemeConfig {
  static const Color primaryColor = DeepColorTokens.primary;
  static const Color secondaryColor = DeepColorTokens.secondary;
  static const Color errorColor = DeepColorTokens.error;

  static CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    primaryContrastingColor: DeepColorTokens.neutral0,
    barBackgroundColor: DeepColorTokens.neutral0,
    scaffoldBackgroundColor: DeepColorTokens.neutral0,
    textTheme: CupertinoTextThemeData(
      primaryColor: DeepColorTokens.neutral900,
      textStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: DeepColorTokens.neutral900,
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
        color: DeepColorTokens.neutral900,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 34,
        letterSpacing: 0.41,
        fontWeight: FontWeight.w700,
        color: DeepColorTokens.neutral900,
      ),
    ),
  );

  static CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    primaryContrastingColor: DeepColorTokens.surface,
    barBackgroundColor: DeepColorTokens.surface,
    scaffoldBackgroundColor: DeepColorTokens.surface,
    textTheme: CupertinoTextThemeData(
      primaryColor: DeepColorTokens.neutral0,
      textStyle: TextStyle(
        fontFamily: '.SF UI Text',
        fontSize: 17,
        letterSpacing: -0.41,
        color: DeepColorTokens.neutral0,
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
        color: DeepColorTokens.neutral0,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: '.SF UI Display',
        fontSize: 34,
        letterSpacing: 0.41,
        fontWeight: FontWeight.w700,
        color: DeepColorTokens.neutral0,
      ),
    ),
  );
}
