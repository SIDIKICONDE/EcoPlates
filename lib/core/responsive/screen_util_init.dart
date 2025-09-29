import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'responsive_init.dart';

/// Widget d'initialisation robuste pour ScreenUtil
class ResponsiveScreenUtilInit extends StatelessWidget {
  const ResponsiveScreenUtilInit({
    required this.child,
    super.key,
    this.minTextAdapt = true,
    this.splitScreenMode = true,
    this.useInheritedMediaQuery = true,
  });

  final Widget child;
  final bool minTextAdapt;
  final bool splitScreenMode;
  final bool useInheritedMediaQuery;

  @override
  Widget build(BuildContext context) {
    // Utiliser ResponsiveConfig pour obtenir la taille de design appropriée
    return ResponsiveBreakpoints.builder(
      breakpoints: ResponsiveConfig.breakpoints,
      child: Builder(
        builder: (context) {
          final designSize = ResponsiveConfig.getDesignSizeForDevice(context);

          // Initialiser ScreenUtil avec la taille adaptative
          return ScreenUtilInit(
            designSize: designSize,
            minTextAdapt: false, // Désactivé pour éviter les textes trop petits
            splitScreenMode: false, // Désactivé pour un meilleur scaling
            useInheritedMediaQuery: useInheritedMediaQuery,
            builder: (context, widget) => child,
          );
        },
      ),
    );
  }
}

/// Fonction helper pour initialiser ScreenUtil manuellement
void initScreenUtil(BuildContext context, {Size? designSize}) {
  // Appeler init sans lire ScreenUtil au préalable (idempotent dans la pratique)
  ScreenUtil.init(
    context,
    designSize: designSize ?? const Size(375, 812),
    minTextAdapt: false,
    splitScreenMode: false,
  );
}

/// Extension pour vérifier si ScreenUtil est initialisé
extension ScreenUtilExtension on ScreenUtil {
  bool get isInitialized {
    try {
      return screenWidth.isFinite && screenHeight.isFinite;
    } catch (_) {
      return false;
    }
  }
}
