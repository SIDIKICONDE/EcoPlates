import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Extensions `BuildContext` pour un accès simple aux infos responsives
extension ContextResponsiveExtensions on BuildContext {
  /// Retourne le type d'appareil courant
  DeviceType get deviceType => Breakpoints.deviceTypeOf(this);

  /// Raccourcis booléens pour la lisibilité
  /// Noms distinctifs pour éviter les collisions avec d'autres extensions
  bool get isMobileDevice => Breakpoints.isMobile(this);
  bool get isTabletDevice => Breakpoints.isTablet(this);
  bool get isDesktopDevice => Breakpoints.isDesktop(this);
  bool get isDesktopLargeDevice => Breakpoints.isDesktopLarge(this);

  /// Sélectionne une valeur selon le device type
  ///
  /// Exemple:
  /// `context.responsiveValue(mobile: 12.0, tablet: 14.0, desktop: 16.0)`
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? desktopLarge,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? desktop ?? desktopLarge ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? desktopLarge ?? mobile;
      case DeviceType.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobile;
    }
  }
}
