import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utilitaires pour la responsivité selon les recommandations Google
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Breakpoints alignés avec ResponsiveFramework
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 905;
  static const double tabletLargeBreakpoint = 1240;
  static const double desktopBreakpoint = 1440;

  /// Détecte le type d'appareil basé sur la largeur
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getDeviceTypeFromWidth(width);
  }

  /// Détecte le type d'appareil basé sur une largeur donnée
  static DeviceType getDeviceTypeFromWidth(double width) {
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Détecte si c'est une grande tablette (>= 905px)
  static bool isTabletLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint &&
      MediaQuery.of(context).size.width < tabletLargeBreakpoint;

  /// Vérifie si on est sur mobile
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  /// Vérifie si on est sur tablette
  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  /// Vérifie si on est sur desktop
  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  /// Vérifie si on est sur un grand écran desktop (>= 1440px)
  static bool isDesktopLarge(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop &&
      MediaQuery.of(context).size.width >= 1440;

  /// Retourne une valeur responsive basée sur le type d'appareil
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? tabletLarge, // Nouveau : pour les tablettes larges 905-1239px
    T? desktop,
    T? desktopLarge, // Pour les écrans >= 1440px
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < mobileBreakpoint) {
      return mobile;
    } else if (screenWidth < tabletBreakpoint) {
      return tablet ?? mobile;
    } else if (screenWidth < tabletLargeBreakpoint) {
      return tabletLarge ?? tablet ?? mobile;
    } else if (screenWidth >= desktopBreakpoint && desktopLarge != null) {
      return desktopLarge;
    } else {
      return desktop ?? tabletLarge ?? tablet ?? mobile;
    }
  }

  /// Calcule des colonnes responsives pour un grid
  static int getResponsiveColumns(
    BuildContext context, {
    int mobileColumns = 1,
    int? tabletColumns,
    int? tabletLargeColumns, // Nouveau : pour les tablettes larges
    int? desktopColumns,
    int? desktopLargeColumns, // Pour les grands écrans
  }) {
    return responsiveValue(
      context,
      mobile: mobileColumns,
      tablet: tabletColumns ?? 2,
      tabletLarge: tabletLargeColumns ?? tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
      desktopLarge: desktopLargeColumns ?? 5,
    );
  }

  /// Calcule le padding responsive
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return responsiveValue(
      context,
      mobile: const EdgeInsets.all(24), // Valeur fixe plus grande
      tablet: const EdgeInsets.all(32),
      tabletLarge: const EdgeInsets.all(
        40,
      ), // Padding intermédiaire pour tablettes larges
      desktop: const EdgeInsets.all(48),
      desktopLarge: const EdgeInsets.all(56),
    );
  }

  /// Calcule la largeur maximale du contenu principal
  static double getMaxContentWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: double.infinity,
      tablet: 720,
      tabletLarge: 960,
      desktop: 1200,
      desktopLarge: 1440,
    );
  }

  /// Calcule la taille de police responsive
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    // Suppression de l'initialisation locale: l'init doit se faire au niveau app

    return responsiveValue(
      context,
      mobile: baseFontSize,
      tablet: baseFontSize * 1.1,
      tabletLarge: baseFontSize * 1.2,
      desktop: baseFontSize * 1.3,
      desktopLarge: baseFontSize * 1.4,
    );
  }

  /// Calcule l'espacement vertical responsive
  static double getVerticalSpacing(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 24, // Valeur fixe plus grande
      tablet: 28,
      tabletLarge: 32,
      desktop: 40,
      desktopLarge: 48,
    );
  }

  /// Calcule l'espacement horizontal responsive
  static double getHorizontalSpacing(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 24, // Valeur fixe plus grande
      tablet: 28,
      tabletLarge: 32,
      desktop: 40,
      desktopLarge: 48,
    );
  }

  /// Détermine si on doit utiliser une mise en page en colonnes
  static bool shouldUseColumnLayout(BuildContext context) {
    return !isMobile(context);
  }

  /// Calcule la largeur d'un élément dans une grille responsive
  static double getGridItemWidth(
    BuildContext context,
    int totalColumns, {
    double spacing = 16,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth =
        screenWidth - (getResponsivePadding(context).horizontal);
    final spacingTotal = spacing * (totalColumns - 1);
    return (availableWidth - spacingTotal) / totalColumns;
  }

  /// Retourne la hauteur d'app bar responsive
  static double getAppBarHeight(BuildContext context) {
    return responsiveValue(
      context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 4,
      tabletLarge: kToolbarHeight + 8,
      desktop: kToolbarHeight + 12,
      desktopLarge: kToolbarHeight + 16,
    );
  }

  /// Calcule le radius des bordures responsive
  static double getBorderRadius(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 12,
      tablet: 14,
      tabletLarge: 16,
      desktop: 20,
      desktopLarge: 24,
    );
  }

  /// Calcule la taille d'icônes responsive
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    return responsiveValue(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.15,
      tabletLarge: baseSize * 1.25,
      desktop: baseSize * 1.35,
      desktopLarge: baseSize * 1.45,
    );
  }

  /// Calcule la hauteur des boutons responsive
  static double getButtonHeight(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 56, // Valeur fixe plus grande
      tablet: 60,
      tabletLarge: 64,
      desktop: 68,
      desktopLarge: 72,
    );
  }

  /// Détermine l'orientation optimale pour les listes
  static Axis getOptimalListDirection(BuildContext context) {
    return isMobile(context) ? Axis.vertical : Axis.horizontal;
  }

  /// Calcule le nombre d'éléments par ligne dans un wrap
  static int getWrapItemsPerLine(BuildContext context, double itemWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth =
        screenWidth - getResponsivePadding(context).horizontal;
    return math.max(1, (availableWidth / itemWidth).floor());
  }

  /// Vérifie si l'écran est en mode paysage
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Vérifie si l'écran est en mode portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Calcule la marge responsive pour centrer le contenu
  static EdgeInsets getCenterContentMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = getMaxContentWidth(context);

    if (screenWidth <= maxWidth) {
      return EdgeInsets.zero;
    }

    final horizontalMargin = (screenWidth - maxWidth) / 2;
    return EdgeInsets.symmetric(horizontal: horizontalMargin);
  }

  /// Calcule l'aspect ratio responsive pour les cards
  static double getCardAspectRatio(BuildContext context) {
    return responsiveValue(
      context,
      mobile: 16 / 9,
      tablet: 5 / 4,
      tabletLarge: 4 / 3,
      desktop: 3 / 2,
      desktopLarge: 5 / 3,
    );
  }

  /// Retourne la densité de pixels pour les images
  static double getPixelDensity(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Calcule la taille d'image responsive
  static Size getResponsiveImageSize(
    BuildContext context, {
    required Size baseSize,
  }) {
    final multiplier = responsiveValue(
      context,
      mobile: 1.0,
      tablet: 1.15,
      tabletLarge: 1.25,
      desktop: 1.35,
      desktopLarge: 1.45,
    );

    return Size(
      baseSize.width * multiplier,
      baseSize.height * multiplier,
    );
  }
}

/// Types d'appareils basés sur les breakpoints Material Design
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Classe pour centraliser les tailles de polices
class FontSizes {
  const FontSizes._();

  // Tailles pour les titres principaux
  static const FontSize titleLarge = FontSize(
    mobile: 32,
    tablet: 38,
    desktop: 44,
  );
  static const FontSize titleMedium = FontSize(
    mobile: 28,
    tablet: 32,
    desktop: 36,
  );
  static const FontSize titleSmall = FontSize(
    mobile: 24,
    tablet: 28,
    desktop: 32,
  );

  // Tailles pour les sous-titres
  static const FontSize subtitleLarge = FontSize(
    mobile: 20,
    tablet: 24,
    desktop: 28,
  );
  static const FontSize subtitleMedium = FontSize(
    mobile: 18,
    tablet: 20,
    desktop: 24,
  );
  static const FontSize subtitleSmall = FontSize(
    mobile: 16,
    tablet: 18,
    desktop: 20,
  );

  // Tailles pour le contenu
  static const FontSize bodyLarge = FontSize(
    mobile: 18,
    tablet: 20,
    desktop: 22,
  );
  static const FontSize bodyMedium = FontSize(
    mobile: 16,
    tablet: 18,
    desktop: 20,
  );
  static const FontSize bodySmall = FontSize(
    mobile: 14,
    tablet: 16,
    desktop: 18,
  );

  // Tailles pour les éléments d'interface
  static const FontSize buttonLarge = FontSize(
    mobile: 18,
    tablet: 20,
    desktop: 22,
  );
  static const FontSize buttonMedium = FontSize(
    mobile: 16,
    tablet: 18,
    desktop: 20,
  );
  static const FontSize buttonSmall = FontSize(
    mobile: 14,
    tablet: 16,
    desktop: 18,
  );

  // Tailles pour les labels et captions
  static const FontSize label = FontSize(mobile: 14, tablet: 15, desktop: 16);
  static const FontSize caption = FontSize(mobile: 12, tablet: 13, desktop: 14);
}

/// Classe pour représenter une taille de police responsive
class FontSize {
  const FontSize({
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.tabletLarge, // Nouveau : pour les tablettes larges
  });

  final double mobile;
  final double tablet;
  final double? tabletLarge;
  final double desktop;

  /// Retourne la taille appropriée selon le contexte
  double getSize(BuildContext context) {
    return ResponsiveUtils.responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      tabletLarge: tabletLarge ?? tablet,
      desktop: desktop,
      desktopLarge: desktop,
    );
  }
}

/// Extension sur BuildContext pour un accès facile aux utilitaires
extension ResponsiveContext on BuildContext {
  /// Type d'appareil actuel
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

  /// Vérifie si c'est un mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Vérifie si c'est une tablette
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Vérifie si c'est un desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Vérifie si c'est une grande tablette (>= 905px)
  bool get isTabletLarge => ResponsiveUtils.isTabletLarge(this);

  /// Vérifie si c'est un desktop large (>= 1440px)
  bool get isDesktopLarge => ResponsiveUtils.isDesktopLarge(this);

  /// Retourne une valeur responsive
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? tabletLarge, // Nouveau : pour les tablettes larges 905-1239px
    T? desktop,
    T? desktopLarge, // Pour les écrans >= 1440px
  }) => ResponsiveUtils.responsiveValue(
    this,
    mobile: mobile,
    tablet: tablet,
    tabletLarge: tabletLarge,
    desktop: desktop,
    desktopLarge: desktopLarge,
  );

  /// Padding responsive
  EdgeInsets get responsivePadding =>
      ResponsiveUtils.getResponsivePadding(this);

  /// Largeur maximale du contenu
  double get maxContentWidth => ResponsiveUtils.getMaxContentWidth(this);

  /// Espacement vertical responsive
  double get verticalSpacing => ResponsiveUtils.getVerticalSpacing(this);

  /// Espacement horizontal responsive
  double get horizontalSpacing => ResponsiveUtils.getHorizontalSpacing(this);

  /// Hauteur d'app bar responsive
  double get appBarHeight => ResponsiveUtils.getAppBarHeight(this);

  /// Radius des bordures responsive
  double get borderRadius => ResponsiveUtils.getBorderRadius(this);

  /// Hauteur des boutons responsive
  double get buttonHeight => ResponsiveUtils.getButtonHeight(this);

  /// Marge pour centrer le contenu
  EdgeInsets get centerContentMargin =>
      ResponsiveUtils.getCenterContentMargin(this);
}
