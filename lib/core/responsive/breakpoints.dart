import 'package:flutter/widgets.dart';

/// Types d'appareils supportés par le système responsive EcoPlates
enum DeviceType {
  mobile,
  tablet,
  desktop,
  desktopLarge,
}

/// Définition des breakpoints (basée sur la largeur en points logiques)
///
/// Alignés avec l'existant où une tablette commence à 768 px.
class Breakpoints {
  Breakpoints._();

  /// Max inclus pour mobile
  static const double mobileMax = 767;

  /// Min inclus pour tablette, max inclus
  static const double tabletMin = 768;
  static const double tabletMax = 1023;

  /// Min inclus pour desktop, max inclus
  static const double desktopMin = 1024;
  static const double desktopMax = 1439;

  /// Min inclus pour grand desktop
  static const double desktopLargeMin = 1440;

  /// Détermine le [DeviceType] à partir d'une largeur donnée
  static DeviceType deviceTypeForWidth(double width) {
    if (width <= mobileMax) return DeviceType.mobile;
    if (width >= tabletMin && width <= tabletMax) return DeviceType.tablet;
    if (width >= desktopMin && width <= desktopMax) return DeviceType.desktop;
    return DeviceType.desktopLarge;
  }

  /// Détermine le [DeviceType] à partir du contexte (MediaQuery)
  static DeviceType deviceTypeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return deviceTypeForWidth(width);
  }

  /// Raccourcis booléens pratiques
  static bool isMobile(BuildContext context) =>
      deviceTypeOf(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      deviceTypeOf(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      deviceTypeOf(context) == DeviceType.desktop;

  static bool isDesktopLarge(BuildContext context) =>
      deviceTypeOf(context) == DeviceType.desktopLarge;
}
