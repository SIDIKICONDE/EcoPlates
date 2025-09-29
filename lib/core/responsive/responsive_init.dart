import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Configuration d'initialisation du système responsif
class ResponsiveConfig {
  static const Size designSize = Size(
    430,
    932,
  ); // iPhone 14 Pro Max comme référence

  // Design sizes pour différents types d'appareils
  static const Size mobileDesignSize = Size(375, 812); // iPhone X/XS/11 Pro
  static const Size tabletDesignSize = Size(768, 1024); // iPad
  static const Size desktopDesignSize = Size(1440, 900); // Desktop standard

  /// Choisit le design size approprié selon le type d'appareil
  static Size getDesignSizeForDevice(BuildContext context) {
    try {
      final breakpoints = ResponsiveBreakpoints.of(context);
      if (breakpoints.isMobile) return mobileDesignSize;
      if (breakpoints.isTablet) return tabletDesignSize;
      return desktopDesignSize;
    } catch (_) {
      // Fallback robuste si ResponsiveBreakpoints n'est pas dispo dans ce contexte
      final width = MediaQuery.of(context).size.width;
      if (width < 600) return mobileDesignSize;
      if (width < 905) return tabletDesignSize;
      return desktopDesignSize;
    }
  }

  /// Vérifie si ScreenUtil est déjà initialisé (sans dépendre d'une extension externe)
  static bool _isScreenUtilInitialized() {
    try {
      final sw = ScreenUtil().screenWidth;
      final sh = ScreenUtil().screenHeight;
      return sw.isFinite && sh.isFinite && sw > 0 && sh > 0;
    } catch (_) {
      return false;
    }
  }

  /// Initialise ScreenUtil avec la taille de design appropriée (idempotent)
  static void initScreenUtil(BuildContext context) {
    // Éviter la double initialisation qui peut conduire à un scale minuscule sur mobile
    if (_isScreenUtilInitialized()) return;

    final deviceDesignSize = getDesignSizeForDevice(context);

    ScreenUtil.init(
      context,
      designSize: deviceDesignSize,
    );
  }

  /// Configuration du ResponsiveFramework
  static List<Breakpoint> get breakpoints => [
    // Alignés avec ResponsiveUtils: mobile < 600, tablet < 905, desktop >= 1240
    const Breakpoint(start: 0, end: 599, name: MOBILE),
    const Breakpoint(start: 600, end: 904, name: TABLET),
    const Breakpoint(start: 905, end: 1239, name: 'TABLET_LARGE'),
    const Breakpoint(start: 1240, end: 1439, name: DESKTOP),
    const Breakpoint(
      start: 1440,
      end: 1919,
      name: 'DESKTOP_LARGE',
    ), // Breakpoint spécifique pour 1440px+
    const Breakpoint(start: 1920, end: double.infinity, name: '4K'),
  ];

  /// Wrapper pour initialiser le système responsif
  static Widget wrapApp(Widget app) {
    return ResponsiveBreakpoints.builder(
      child: app,
      breakpoints: breakpoints,
    );
  }
}

/// Extension pour faciliter l'utilisation des breakpoints
extension ResponsiveBreakpointExtension on BuildContext {
  /// Vérifie si on est sur un mobile
  bool get isMobileSize => ResponsiveBreakpoints.of(this).isMobile;

  /// Vérifie si on est sur une tablette
  bool get isTabletSize => ResponsiveBreakpoints.of(this).isTablet;

  /// Vérifie si on est sur un desktop
  bool get isDesktopSize => ResponsiveBreakpoints.of(this).isDesktop;

  /// Vérifie si on est sur un petit écran
  bool get isSmallScreen => ResponsiveBreakpoints.of(this).screenWidth <= 600;

  /// Vérifie si on est sur un grand écran (1440px+)
  bool get isLargeScreen => ResponsiveBreakpoints.of(this).screenWidth >= 1440;

  /// Retourne la largeur de l'écran
  double get scaledWidth => ResponsiveBreakpoints.of(this).screenWidth;

  /// Retourne la hauteur de l'écran
  double get scaledHeight => ResponsiveBreakpoints.of(this).screenHeight;

  /// Retourne les dimensions
  Size get scaledSize => Size(scaledWidth, scaledHeight);
}

/// Mixin pour les widgets qui ont besoin d'initialisation responsive
mixin ResponsiveInitMixin<T extends StatefulWidget> on State<T> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ResponsiveConfig.initScreenUtil(context);
  }
}

/// Widget helper pour initialiser la responsivité dans un écran
class ResponsiveInit extends StatelessWidget {
  const ResponsiveInit({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Toujours s'assurer que l'init est appelée ici sans lire d'abord
    ResponsiveConfig.initScreenUtil(context);
    return child;
  }
}

/// Scaffold responsif avec initialisation automatique
class ResponsiveScaffoldInit extends StatelessWidget {
  const ResponsiveScaffoldInit({
    required this.body,
    super.key,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ResponsiveInit(
      child: Scaffold(
        appBar: appBar,
        drawer: drawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor,
        body: body,
      ),
    );
  }
}
