import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../urgent_offers_animation_manager.dart';

/// Widget logo adaptatif avec animation et responsivité dynamique
class LogoMeal extends StatelessWidget {
  const LogoMeal({
    super.key,
    this.animationManager,
    this.emoji = '🍽️',
    this.mobileSize = 20.0,
    this.tabletSize = 24.0,
    this.desktopSize = 28.0,
    this.desktopLargeSize = 32.0,
  });

  final UrgentOffersAnimationManager? animationManager;
  final String emoji;
  final double mobileSize;
  final double tabletSize;
  final double desktopSize;
  final double desktopLargeSize;

  @override
  Widget build(BuildContext context) {
    // Taille responsive dynamique selon le device
    final dynamicSize = ResponsiveUtils.responsiveValue(
      context,
      mobile: mobileSize,
      tablet: tabletSize,
      tabletLarge: tabletSize * 1.1, // Légèrement plus grand sur tablette large
      desktop: desktopSize,
      desktopLarge: desktopLargeSize,
    );

    final logoText = Text(
      emoji,
      style: TextStyle(
        fontSize: dynamicSize,
        // Ajout d'une hauteur de ligne adaptative pour de meilleurs emojis
        height: ResponsiveUtils.responsiveValue(
          context,
          mobile: 1.2,
          tablet: 1.1,
          desktop: 1.0,
        ),
      ),
    );

    if (animationManager != null) {
      return animationManager!.buildPulsingWidget(
        animation: animationManager!.pulseAnimation,
        child: logoText,
      );
    }

    return logoText;
  }
}
