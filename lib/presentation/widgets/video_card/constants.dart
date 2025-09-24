/// Constantes pour les widgets vidéo - Élimination des nombres magiques
class VideoCardConstants {
  // Dimensions des cartes (format compact)
  static const double defaultWidth = 140;
  static const double defaultHeight = 210;
  static const double borderRadius = 10;

  // Espacement et marges
  static const double contentPadding = 12;
  static const double badgeTopPosition = 8;
  static const double badgeRightPosition = 8;
  static const double indicatorBottomPosition = 80;
  static const double indicatorRightPosition = 12;

  // Tailles d'icônes
  static const double errorIconSize = 40;
  static const double playIconBadgeSize = 14;
  static const double playIconIndicatorSize = 20;

  // Tailles de police
  static const double merchantNameFontSize = 12;
  static const double durationFontSize = 11;

  // Animations (durées en millisecondes)
  static const int animationDurationFast = 150;
  static const int animationDurationNormal = 200;
  static const int animationDurationSlow = 500;

  // Opacités
  static const double pressedOpacity = 0.9;
  static const double normalOpacity = 0.7;
  static const double gradientStartOpacity = 0.5;
  static const double gradientEndOpacity = 0.7;
  static const double pressedGradientEndOpacity = 0.8;
  static const double shadowDarkOpacity = 0.3;
  static const double shadowLightOpacity = 0.15;
  static const double badgeBackgroundOpacity = 0.7;
  static const double indicatorBackgroundOpacity = 0.2;
  static const double indicatorBorderOpacity = 0.3;

  // Échelles d'animation
  static const double normalScale = 1.0;
  static const double pressedScale = 0.98;

  // Gradient stops
  static const double gradientStartStop = 0.5;
  static const double gradientEndStop = 1.0;

  // Espacement des lignes de texte
  static const double titleLineHeight = 1.2;

  // Padding et marges pour badges/indicateurs
  static const double badgeHorizontalPadding = 6;
  static const double badgeVerticalPadding = 4;
  static const double badgeBorderRadius = 6;
  static const double indicatorPadding = 8;
  static const double indicatorBorderWidth = 1.5;
  static const double textIconSpacing = 2;

  // Couleurs de fallback (indices pour grey[])
  static const int placeholderDarkGreyIndex = 800;
  static const int placeholderLightGreyIndex = 300;
  static const int errorDarkGreyIndex = 900;
  static const int errorLightGreyIndex = 200;
}

class VideoSliderConstants {
  // Dimensions et layout
  static const double defaultHeight = 210; // Même hauteur que les cartes
  static const double defaultHorizontalPadding = 16;
  static const double headerSpacing = 12;

  // Animations
  static const int sliderAnimationDuration = 500;

  // Header styling
  static const double letterSpacing = -0.5;
  static const double buttonHorizontalPadding = 12;
  static const double buttonVerticalPadding = 6;
  static const double buttonBorderRadius = 20;
  static const double buttonTextIconSpacing = 4;
  static const double buttonIconSize = 20;

  // Item layout
  static const double itemWidth = 142; // 140 (width) + 2 pour marges
  static const double itemMargin = 1; // Espacement minimal de 2px entre cartes
  static const double parallaxFactor = 0.05;

  // Responsive design
  static const double responsiveBreakpoint = 600;
  static const int mobileCrossAxisCount = 2;
  static const int desktopCrossAxisCount = 3;

  // Grid layout
  static const double gridPadding = 9; // 11 * 0.8 = 8.8 ≈ 9 (-18% supplémentaire)
  static const double gridCrossAxisSpacing = 9; // 11 * 0.8 = 8.8 ≈ 9 (-18% supplémentaire)
  static const double gridMainAxisSpacing = 11; // 14 * 0.8 = 11.2 ≈ 11 (-21% supplémentaire)
}

class VideoGridConstants {
  // Utilise les constantes de VideoSliderConstants pour la cohérence
  static const double padding = VideoSliderConstants.gridPadding;
  static const double crossAxisSpacing = VideoSliderConstants.gridCrossAxisSpacing;
  static const double mainAxisSpacing = VideoSliderConstants.gridMainAxisSpacing;
  static const double responsiveBreakpoint = VideoSliderConstants.responsiveBreakpoint;
  static const int mobileCrossAxisCount = VideoSliderConstants.mobileCrossAxisCount;
  static const int desktopCrossAxisCount = VideoSliderConstants.desktopCrossAxisCount;
}

class VideoSectionConstants {
  // Dimensions et layout
  static const double videoSliderHeight = 180; // Hauteur compacte pour la section

  // Textes et labels
  static const String sectionTitle = '🎬 Découvrir en vidéo';

  // Routes de navigation
  static const String merchantRoute = '/merchant/';
  static const String videosRoute = '/videos';
}