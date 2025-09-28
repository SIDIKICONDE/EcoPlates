import 'package:flutter/material.dart';
import 'context_responsive_extensions.dart';

/// Design tokens responsives pour EcoPlates
/// Centralise toutes les valeurs d'espacement, typographie, dimensions, etc.
/// pour une cohérence parfaite à travers l'application

/// Constantes numériques de base pour réduire la duplication
class DesignConstants {
  const DesignConstants._();

  // === VALEURS DE BASE FRÉQUEMMENT UTILISÉES ===
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double xxxxl = 48.0;

  // === VALEURS COURANTES ===
  static const double ten = 10.0;
  static const double fourteen = 14.0;
  static const double fifteen = 15.0;
  static const double eighteen = 18.0;
  static const double twenty = 20.0;
  static const double twentyFour = 24.0;
  static const double twentyEight = 28.0;
  static const double thirtyTwo = 32.0;
  static const double thirtySix = 36.0;
  static const double forty = 40.0;
  static const double fortyEight = 48.0;
  static const double fifty = 50.0;
  static const double fiftySix = 56.0;
  static const double sixtyFour = 64.0;
  static const double seventyTwo = 72.0;
  static const double eighty = 80.0;

  // === VALEURS DÉCIMALES COURANTES ===
  static const double zeroPointFive = 0.5;
  static const double one = 1.0;
  static const double onePointFive = 1.5;
  static const double onePointFour = 1.4;
  static const double two = 2.0;
  static const double twoPointFive = 2.5;
  static const double three = 3.0;
  static const double four = 4.0;
  static const double five = 5.0;
  static const double six = 6.0;

  // === VALEURS DE POURCENTAGE ===
  static const double opacityDisabled = 0.5;
  static const double opacityHover = 0.1;
  static const double opacityPressed = 0.2;
  static const double opacityOverlay = 0.8;
  static const double opacityGradientPrimary = 0.8;
  static const double opacityGradientSecondary = 0.6;
  static const double opacityTextSecondary = 0.7;
  static const double opacityDecorative = 0.24;
  static const double opacitySemiTransparent = 0.5;
  static const double opacityVeryTransparent = 0.1;
  static const double opacityAlmostOpaque = 0.9;
  static const double opacityVeryOpaque = 0.95;
  static const double opacitySubtle = 0.3;
  static const double opacityAnalyticsBackground = 0.98;
  static const double opacityVerySubtle = 0.01;
  static const double opacityEmptyStateIcon = 0.3;

  // === VALEURS DE DIMENSIONS ===
  static const double infinity = double.infinity;
  static const double zero = 0.0;
  static const double hundred = 100.0;
  static const double oneHundredTwenty = 120.0;
  static const double twoHundred = 200.0;
  static const double threeHundred = 300.0;
  static const double threeHundredForty = 340.0;
  static const double fourHundred = 400.0;
  static const double fourHundredEighty = 480.0;
  static const double fiveHundred = 500.0;
  static const double sixHundred = 600.0;
  static const double sevenHundred = 700.0;
  static const double sevenHundredSixtyEight = 768.0;
  static const double eightHundred = 800.0;
  static const double oneThousand = 1000.0;
  static const double oneThousandNineHundredTwenty = 1920.0;
  static const double oneThousandEighty = 1080.0;
  static const double twelveHundred = 1200.0;
  static const double fourteenHundred = 1440.0;

  // === BREAKPOINTS ===
  static const double tabletBreakpoint = 768.0;
  static const double verySmallScreenThreshold = 600.0;
  static const double mediumScreenBreakpoint = 900.0;
  static const double veryNarrowScreenThreshold = 360.0;
  static const double largeDesktopThreshold = 1440.0;
  static const double threeHundredSixty = 360.0;

  // === FACTEURS ===
  static const double modalHeightFactorDefault = 0.7;
  static const double modalMinHeightFactor = 0.3;
  static const double modalMaxHeightFactor = 0.5;
  static const double largeIconMultiplier = 1.5;
  static const double verySmallScreenFactor = 0.8;
  static const double extendedSpacingFactor = 2.5;
  static const double selectedBorderMultiplier = 1.5;

  // === RATIOS ===
  static const double landscapeContainerRatio = 0.6;
  static const double portraitContainerRatio = 0.8;
  static const double minContainerHeightRatio = 0.8;
  static const double textLineHeight = 1.4;
  static const double imageAspectRatio = 16 / 9;
  static const double categoryModalHeightRatio = 0.75;
  static const double unitModalHeightRatio = 0.6;
  static const double filtersModalHeightRatio = 0.8;
  static const double profileEditModalInitialSize = 0.9;
  static const double profileEditModalMinSize = 0.5;
  static const double profileEditModalMaxSize = 0.95;
  static const double qrScannerOverlayOpacity = 0.5;
  static const double qrControlsOpacity = 0.9;
  static const double pulseEnd = 1.05;
  static const double urgentOffersModalHeightRatio = 0.9;
  static const double baseDistance = 0.3;
  static const double distanceIncrement = 0.1;
  static const double mobileGridAspectRatio = 16 / 10;
  static const double tabletGridAspectRatio = 16 / 11;
  static const double desktopGridAspectRatio = 16 / 12;
  static const double desktopLargeGridAspectRatio = 16 / 13;
  static const double thumbnailAspectRatio = 16 / 9;

  // === TAILLES SPÉCIALES ===
  static const double qrScannerBorderLength = 30.0;
  static const double qrScannerCutOutSize = 300.0;
  static const double errorStateIconSize = 64.0;
  static const double emptyStateIconSize = 100.0;
  static const double errorViewIconSize = 80.0;
  static const double actionCardShadowBlurRadius = 8.0;
  static const double actionCardShadowOpacity = 0.1;
  static const double qrScannerBorderRadius = 10.0;
  static const double qrScannerBorderWidth = 5.0;
}

/// Patterns de responsive prédéfinis pour réduire la duplication
class ResponsivePatterns {
  const ResponsivePatterns._();

  // Patterns de base avec incrémentation de 4
  static const double _baseIncrement = DesignConstants.xs;

  /// Pattern de base : génère [start, start+4, start+8, start+12]
  static List<double> _generatePattern(double start) => [
    start,
    start + _baseIncrement,
    start + 2 * _baseIncrement,
    start + 3 * _baseIncrement,
  ];

  /// Pattern avec incrémentation personnalisée (step au lieu de 4)
  static List<double> _generateStepPattern(double start, double step) => [
    start,
    start + step,
    start + 2 * step,
    start + 3 * step,
  ];

  // Patterns compacts avec progression cohérente (+2/+3/+4)
  static List<double> get xsToLg => [3.0, 5.0, 7.0, 9.0]; // 3→5→7→9
  static List<double> get smToXl => [6.0, 9.0, 12.0, 15.0]; // 6→9→12→15
  static List<double> get mdToXxl => [10.0, 14.0, 18.0, 22.0]; // 10→14→18→22
  static List<double> get lgToXxxl => [14.0, 18.0, 22.0, 28.0]; // 14→18→22→28
  // Spécifique: échelle plus fine pour micro-espacements (2/4/6/8)
  static List<double> get xxsToMd =>
      _generateStepPattern(DesignConstants.xxs, 2.0);

  // Polices compactes et cohérentes
  static List<double> get fontStandard => [
    13.0,
    15.0,
    16.0,
    17.0,
  ]; // 13→15→16→17
  static List<double> get fontSmall => [11.0, 12.0, 13.0, 14.0]; // 11→12→13→14
  static List<double> get fontLarge => [16.0, 18.0, 20.0, 22.0]; // 16→18→20→22

  // Titres compacts et cohérents (18→24→28→32)
  static List<double> get fontTitle => [18.0, 24.0, 28.0, 32.0];

  // Sous-titres compacts et cohérents (14→18→20→22)
  static List<double> get fontSubtitle => [14.0, 18.0, 20.0, 22.0];

  /// Pattern spécial pour field radius : MD → LG → LG → XL
  static List<double> get fieldRadius => [12.0, 16.0, 16.0, 20.0];

  /// Icônes compactes : 18 → 20 → 22 → 24
  static List<double> get iconStandard => [18.0, 20.0, 22.0, 24.0];

  /// Indicateurs compacts : 6 → 8 → 10 → 12
  static List<double> get indicator => [6.0, 8.0, 10.0, 12.0];

  /// Hauteurs de boutons compactes : 44 → 48 → 52 → 56
  static List<double> get buttonHeight => [44.0, 48.0, 52.0, 56.0];

  /// Pattern pour l'espacement des lettres : 1.0 → 1.0 → 2.0 → 2.0
  static List<double> get titleLetterSpacing => [1.0, 1.0, 2.0, 2.0];

  /// Pattern pour les largeurs de formulaire : ∞ → ∞ → 600 → 700
  static List<double> get formWidth => [
    double.infinity,
    double.infinity,
    600.0,
    700.0,
  ];

  /// Pattern pour les largeurs de modal : ∞ → 500 → 600 → 700
  static List<double> get modalWidth => [double.infinity, 500.0, 600.0, 700.0];

  /// Pattern pour les largeurs de bouton : ∞ → 420 → 500 → 560
  static List<double> get buttonWidth => [double.infinity, 420.0, 500.0, 560.0];

  /// Pattern pour les facteurs de largeur : 0.85 → 0.5 → 0.5 → 0.5
  static List<double> get buttonWidthFactor => [0.85, 0.5, 0.5, 0.5];

  /// Pattern pour les largeurs de conteneur : ∞ → 600 → 500 → 600
  static List<double> get contentContainerWidth => [
    double.infinity,
    600.0,
    500.0,
    600.0,
  ];

  /// Pattern pour les largeurs principales : ∞ → 600 → 1200 → 1400
  static List<double> get mainContainerWidth => [
    double.infinity,
    600.0,
    1200.0,
    1400.0,
  ];

  /// Pattern pour les largeurs de bouton de section : ∞ → 500 → 400 → 500
  static List<double> get buttonSectionWidth => [
    double.infinity,
    500.0,
    400.0,
    500.0,
  ];

  /// Pattern pour les lignes de description : 4 → 5 → 6 → 6
  static List<int> get descriptionLines => [4, 5, 6, 6];

  /// Pattern pour les hauteurs de modale : 0.7 → 0.6 → 0.5 → 0.5
  static List<double> get modalHeightFactor => [0.7, 0.6, 0.5, 0.5];

  /// Pattern pour le padding de section : 16 → 24 → 48 → 60 (saut de +8 puis +24 puis +12)
  static List<double> get sectionPadding => [16.0, 24.0, 48.0, 60.0];

  /// Pattern pour les hauteurs de cartes marchands : 280 → 320 → 360 → 400
  static List<double> get merchantCardHeight =>
      _generateStepPattern(280.0, 20.0);

  /// Pattern pour les hauteurs de conteneur de graphique : 180 → 200 → 220 → 240
  static List<double> get chartContainerHeight =>
      _generateStepPattern(180.0, 20.0);

  /// Pattern pour les largeurs de barre : 20 → 24 → 28 → 32
  static List<double> get barWidth => _generatePattern(20.0);

  /// Pattern pour l'espacement entre barres : 6 → 8 → 10 → 12
  static List<double> get barSpacing => _generatePattern(6.0);

  /// Pattern pour les hauteurs maximales de barres : 80 → 100 → 120 → 140
  static List<double> get maxBarHeight => _generateStepPattern(80.0, 20.0);

  /// Pattern pour les paddings de graphique : 12 → 16 → 20 → 24
  static List<double> get chartPadding => _generatePattern(12.0);

  /// Pattern pour les espacements d'éléments de header : 6 → 8 → 10 → 12
  static List<double> get headerElementSpacing => _generatePattern(6.0);

  /// Pattern pour les espacements d'icônes : 14 → 16 → 18 → 20
  static List<double> get iconSize => _generateStepPattern(14.0, 2.0);

  /// Pattern pour les espacements d'icônes et texte : 4 → 6 → 8 → 10
  static List<double> get iconTextSpacing => _generatePattern(4.0);

  /// Pattern pour les hauteurs de texte de valeur : 18 → 20 → 22 → 24
  static List<double> get valueTextHeight => _generatePattern(18.0);

  /// Pattern pour les rayons de points de connexion : 5 → 6 → 7 → 8
  static List<double> get connectionPointRadius => [5.0, 6.0, 7.0, 8.0];

  /// Pattern pour les rayons de fond de points : 6 → 7 → 8 → 9
  static List<double> get connectionPointBackgroundRadius => [
    6.0,
    7.0,
    8.0,
    9.0,
  ];

  /// Pattern pour les tailles de badge de rang : 24 → 28 → 32 → 36
  static List<double> get rankBadgeSize => _generateStepPattern(24.0, 4.0);

  /// Pattern pour les tailles de badge de rang hauteur : 24 → 28 → 32 → 36
  static List<double> get rankBadgeHeight => _generateStepPattern(24.0, 4.0);

  /// Pattern pour les tailles internes de rang : 18 → 20 → 22 → 24
  static List<double> get rankInnerSize => _generatePattern(18.0);

  /// Pattern pour les tailles d'icône KPI : 16 → 18 → 20 → 22
  static List<double> get kpiCardIconSize => _generatePattern(16.0);

  /// Pattern pour les tailles de police KPI : 12 → 13 → 14 → 15
  static List<double> get kpiCardTitleFontSize => [12.0, 13.0, 14.0, 15.0];

  /// Pattern pour les tailles de valeur KPI : 20 → 22 → 24 → 26
  static List<double> get kpiCardValueFontSize => _generatePattern(20.0);

  /// Pattern pour les tailles de croissance KPI : 10 → 11 → 12 → 12
  static List<double> get kpiCardGrowthFontSize => [10.0, 11.0, 12.0, 12.0];

  /// Pattern pour les paddings KPI : 14 → 16 → 18 → 20
  static List<double> get kpiCardPadding => _generatePattern(14.0);

  /// Pattern pour les espacements horizontaux KPI : 8 → 10 → 12 → 12
  static List<double> get kpiCardHeaderHorizontalSpacing => [
    8.0,
    10.0,
    12.0,
    12.0,
  ];

  /// Pattern pour les espacements verticaux KPI : 10 → 12 → 14 → 16
  static List<double> get kpiCardHeaderVerticalSpacing =>
      _generatePattern(10.0);

  /// Pattern pour les espacements de valeur KPI : 6 → 8 → 10 → 10
  static List<double> get kpiCardValueVerticalSpacing => [6.0, 8.0, 10.0, 10.0];

  /// Pattern pour les paddings de croissance horizontaux : 6 → 8 → 10 → 10
  static List<double> get kpiCardGrowthHorizontalPadding => [
    6.0,
    8.0,
    10.0,
    10.0,
  ];

  /// Pattern pour les paddings de croissance verticaux : 3 → 4 → 5 → 5
  static List<double> get kpiCardGrowthVerticalPadding => [3.0, 4.0, 5.0, 5.0];

  /// Pattern pour les espacements internes de croissance : 4 → 6 → 8 → 8
  static List<double> get kpiCardGrowthInnerSpacing => [4.0, 6.0, 8.0, 8.0];

  /// Pattern pour les rayons de bordure KPI : 14 → 16 → 18 → 18
  static List<double> get kpiCardBorderRadius => [14.0, 16.0, 18.0, 18.0];

  /// Pattern pour les tailles d'icône de tendance KPI : 12 → 14 → 16 → 16
  static List<double> get kpiCardTrendIconSize => [12.0, 14.0, 16.0, 16.0];

  /// Helper pour créer des getters de pattern responsive
  static double pattern(BuildContext context, List<double> values) =>
      context.responsiveValue(
        mobile: values[0],
        tablet: values[1],
        desktop: values[2],
        desktopLarge: values[3],
      );
}

/// Helpers prédéfinis pour réduire la duplication dans responsiveValue()
extension ResponsiveValueHelpers on BuildContext {
  /// Méthode générique pour appliquer un pattern responsive
  double _applyPattern(List<double> pattern) => responsiveValue(
    mobile: pattern[0],
    tablet: pattern[1],
    desktop: pattern[2],
    desktopLarge: pattern[3],
  );

  /// Extension pour accéder à _applyPattern depuis n'importe quel contexte
  double applyPattern(List<double> pattern) => _applyPattern(pattern);

  // === PATTERNS DE BASE (réduits avec approche générique) ===

  /// Génère un scale pattern depuis ResponsivePatterns
  double scalePattern(List<double> pattern) => _applyPattern(pattern);

  /// Génère un scale pattern avec progression linéaire
  double scaleLinear(double start, double step) => _applyPattern([
    start,
    start + step,
    start + 2 * step,
    start + 3 * step,
  ]);

  /// Génère un scale pattern avec valeurs personnalisées
  double scaleCustom(List<double> values) => _applyPattern(values);

  // === RACCOURCIS POUR PATTERNS COURANTS ===

  double get scaleXS_SM_MD_LG => scalePattern(ResponsivePatterns.xsToLg);
  double get scaleSM_MD_LG_XL => scalePattern(ResponsivePatterns.smToXl);
  double get scaleMD_LG_XL_XXL => scalePattern(ResponsivePatterns.mdToXxl);
  double get scaleLG_XL_XXL_XXXL => scalePattern(ResponsivePatterns.lgToXxxl);
  double get scaleXXS_XS_SM_MD => scalePattern(ResponsivePatterns.xxsToMd);

  /// Alias pour compatibilité
  double scaleFromXS() => scaleXS_SM_MD_LG;
  double scaleFromSM() => scaleSM_MD_LG_XL;
  double scaleFromMD() => scaleMD_LG_XL_XXL;
  double scaleFromLG() => scaleLG_XL_XXL_XXXL;
  double scaleFromXXS() => scaleXXS_XS_SM_MD;

  // === TYPOGRAPHIE ===

  double get fontScaleStandard => scalePattern(ResponsivePatterns.fontStandard);
  double get fontScaleSmall => scalePattern(ResponsivePatterns.fontSmall);
  double get fontScaleLarge => scalePattern(ResponsivePatterns.fontLarge);

  double get fontScaleTitle => responsiveValue(
    mobile: ResponsivePatterns.fontTitle[0],
    tablet: ResponsivePatterns.fontTitle[1],
    desktop: ResponsivePatterns.fontTitle[2],
    desktopLarge: ResponsivePatterns.fontTitle[3],
  );

  double get fontScaleSubtitle => responsiveValue(
    mobile: ResponsivePatterns.fontSubtitle[0],
    tablet: ResponsivePatterns.fontSubtitle[1],
    desktop: ResponsivePatterns.fontSubtitle[2],
    desktopLarge: ResponsivePatterns.fontSubtitle[3],
  );

  // === CONSTANTES ET VALEURS SPÉCIALES ===

  double constant(double value) => responsiveValue(
    mobile: value,
    tablet: value,
    desktop: value,
    desktopLarge: value,
  );

  /// Pattern progression de +20
  double scaleStep20(double start) => scaleLinear(start, 20.0);

  // === PATTERNS SPÉCIALISÉS ===

  double get scaleFieldRadius => scalePattern(ResponsivePatterns.fieldRadius);
  double get scaleIconStandard => scalePattern(ResponsivePatterns.iconStandard);
  double get scaleIndicator => scalePattern(ResponsivePatterns.indicator);
  double get scaleButtonHeight => scalePattern(ResponsivePatterns.buttonHeight);
  double get scaleTitleLetterSpacing =>
      scalePattern(ResponsivePatterns.titleLetterSpacing);
  double get scaleFormWidth => scalePattern(ResponsivePatterns.formWidth);
  double get scaleModalWidth => scalePattern(ResponsivePatterns.modalWidth);
  double get scaleButtonWidth => scalePattern(ResponsivePatterns.buttonWidth);
  double get scaleButtonWidthFactor =>
      scalePattern(ResponsivePatterns.buttonWidthFactor);
}

class EcoPlatesDesignTokens {
  const EcoPlatesDesignTokens._();

  /// Espacement (spacing) responsif
  static const Spacing spacing = Spacing._();

  /// Rayons de bordure (border radius)
  static const BorderRadiusTokens radius = BorderRadiusTokens._();

  /// Typographie (font sizes)
  static const Typography typography = Typography._();

  /// Dimensions (sizes)
  static const Size size = Size._();

  /// Dimensions et contraintes de layout
  static const Layout layout = Layout._();

  /// Élevations (shadows)
  static const Elevation elevation = Elevation._();

  /// Couleurs
  static const ColorTokens colors = ColorTokens._();

  /// Opacités
  static const OpacityTokens opacity = OpacityTokens._();

  /// Animations et durées
  static const AnimationTokens animation = AnimationTokens._();

  /// Couleurs d'erreur basées sur le thème
  static Color errorColorNetwork(BuildContext context) =>
      Theme.of(context).colorScheme.secondary; // Orange-like

  static Color errorColorAuth(BuildContext context) =>
      Theme.of(context).colorScheme.error; // Red

  static Color errorColorValidation(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary; // Amber-like

  static Color errorColorPayment(BuildContext context) =>
      Theme.of(context).colorScheme.errorContainer; // Deep orange-like

  static Color errorColorGeneral(BuildContext context) =>
      Theme.of(context).colorScheme.error; // Red

  /// Couleurs pour les textes d'erreur dans les dialogues
  static Color errorTextSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color errorFieldText(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  /// Couleurs pour les notifications
  static Color notificationError(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color notificationSuccess(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color notificationInfo(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  static Color notificationWarning(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;

  /// Couleur pour le statut actif
  static Color statusActive(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// Couleur pour le statut inactif
  static Color statusInactive(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;

  /// Tailles d'icônes pour les erreurs
  static double get errorIconSize => DesignConstants.xxl;

  /// Tailles d'icônes pour les notifications
  static double get notificationIconSize => DesignConstants.xxl;

  /// Espacement entre l'icône et le texte dans les notifications
  static double get notificationIconSpacing => DesignConstants.md;

  /// Espacement dans les dialogues d'erreur
  static double get errorDialogSpacing => DesignConstants.sm;
  static double get errorDialogFieldSpacing => DesignConstants.md;
  static double get errorFieldErrorSpacing => DesignConstants.xs;

  /// Propriétés pour les dialogues et bottom sheets
  static double get dialogBorderRadius => DesignConstants.lg;
  static double get dialogPadding => DesignConstants.xxl;
  static double get dividerHeight => DesignConstants.one;
  static double get bottomSheetEndSpacing => DesignConstants.lg;

  /// Breakpoints
  static double get tabletBreakpoint => DesignConstants.tabletBreakpoint;

  /// Constantes de validation pour les formulaires
  static const Validation validation = Validation._();

  /// Constantes pour les vidéos
  static const Video video = Video._();

  /// Constantes pour les offres urgentes
  static const UrgentOffers urgentOffers = UrgentOffers._();

  /// Constantes pour l'écran d'accueil
  static const HomeScreen homeScreen = HomeScreen._();

  /// Constantes pour les charts analytics
  static const AnalyticsCharts analyticsCharts = AnalyticsCharts._();

  /// Constantes pour la barre d'application analytics
  static const AnalyticsAppBarTokens analyticsAppBar =
      AnalyticsAppBarTokens._();
}

/// Espacement (spacing) responsif
class Spacing {
  const Spacing._();

  double get xxs => DesignConstants.xs; // 4.0
  double get xs => DesignConstants.sm; // 8.0
  double get sm => DesignConstants.md; // 12.0
  double get md => DesignConstants.lg; // 16.0
  double get lg => DesignConstants.xl; // 20.0
  double get xl => DesignConstants.xxl; // 24.0
  double get xxl => DesignConstants.xxxl; // 32.0
  double get xxxl => DesignConstants.xxxxl; // 48.0

  /// Espacement adaptatif selon le breakpoint
  double responsive(BuildContext context) => context.scaleMD_LG_XL_XXL;

  /// Espacement pour contenu (padding interne)
  EdgeInsets contentPadding(BuildContext context) => EdgeInsets.symmetric(
    horizontal: context.scaleSM_MD_LG_XL,
    vertical: context.scaleSM_MD_LG_XL,
  );

  /// Espacement pour sections (marges entre éléments)
  double sectionSpacing(BuildContext context) => context.scaleMD_LG_XL_XXL;

  /// Padding pour les chips SKU
  EdgeInsets get skuChipPadding =>
      const EdgeInsets.symmetric(horizontal: 6, vertical: 2);

  /// Padding pour les chips de catégorie
  EdgeInsets get categoryChipPadding =>
      const EdgeInsets.symmetric(horizontal: 8, vertical: 3);

  /// Espacement entre éléments rapprochés (petit gap)
  double smallGap(BuildContext context) => context.scaleXS_SM_MD_LG;

  /// Espacement entre éléments très rapprochés (micro gap)
  double microGap(BuildContext context) => context.scaleXXS_XS_SM_MD;

  /// Espacement entre éléments d'interface (interface gap)
  double interfaceGap(BuildContext context) => context.scaleSM_MD_LG_XL;

  /// Espacement dans les dialogues et boîtes de dialogue (dialog gap)
  double dialogGap(BuildContext context) => context.scaleMD_LG_XL_XXL;

  /// Padding pour les tuiles de statistiques
  EdgeInsets get statTilePadding =>
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  /// Marge du chip hors ligne
  EdgeInsets get offlineChipMargin => const EdgeInsets.only(right: 8);

  /// Padding des éléments de dialogue QR
  EdgeInsets get qrDialogItemPadding => const EdgeInsets.only(left: 8, top: 4);
}

/// Rayons de bordure (border radius)
class BorderRadiusTokens {
  const BorderRadiusTokens._();

  double get none => DesignConstants.zero;
  double get xs => DesignConstants.xs;
  double get sm => DesignConstants.sm;
  double get md => DesignConstants.md;
  double get lg => DesignConstants.lg;
  double get xl => DesignConstants.xl;
  double get xxl => DesignConstants.twentyEight;

  /// Rayon adaptatif pour boutons
  double buttonRadius(BuildContext context) => context.constant(xxl);

  /// Rayon adaptatif pour champs de formulaire
  double fieldRadius(BuildContext context) => context.scaleFieldRadius;
}

/// Typographie (font sizes et weights)
class Typography {
  const Typography._();

  /// Tailles de police pour les labels de formulaire
  double label(BuildContext context) => context.fontScaleStandard;

  /// Tailles de police pour le texte de formulaire
  double text(BuildContext context) => context.fontScaleStandard;

  /// Tailles de police pour les hints
  double hint(BuildContext context) => context.fontScaleSmall;

  /// Tailles de police pour les titres de modal
  double modalTitle(BuildContext context) => context.fontScaleLarge;

  /// Tailles de police pour le contenu de modal
  double modalContent(BuildContext context) => context.fontScaleStandard;

  /// Tailles de police pour les boutons
  double button(BuildContext context) => context.fontScaleStandard;

  /// Tailles de police pour les titres principaux
  double titleSize(BuildContext context) => context.fontScaleTitle;

  /// Tailles de police pour les sous-titres
  double subtitleSize(BuildContext context) => context.fontScaleSubtitle;

  /// Tailles de police pour les sous-titres de modal
  double modalSubtitle(BuildContext context) => context.fontScaleSmall;

  /// Poids de police standard
  FontWeight get regular => FontWeight.w400;

  /// Poids de police moyen
  FontWeight get medium => FontWeight.w500;

  /// Poids de police semi-bold
  FontWeight get semiBold => FontWeight.w600;

  /// Poids de police bold
  FontWeight get bold => FontWeight.w700;

  /// Poids de police pour les titres
  FontWeight get title => FontWeight.w600;

  /// Poids de police pour les labels
  FontWeight get labelWeight => FontWeight.w500;

  /// Poids de police pour les boutons
  FontWeight get buttonWeight => FontWeight.w600;

  /// Espacement des lettres pour les titres
  double titleLetterSpacing(BuildContext context) =>
      context.scaleTitleLetterSpacing;
}

/// Dimensions (sizes)
class Size {
  const Size._();

  /// Tailles d'icônes adaptatives
  double icon(BuildContext context) => context.scaleIconStandard;

  /// Tailles d'icônes pour modals
  double modalIcon(BuildContext context) => context.scaleIconStandard;

  /// Tailles des indicateurs (dots, status indicators)
  double indicator(BuildContext context) => context.scaleIndicator;

  /// Hauteurs de boutons adaptatives
  double buttonHeight(BuildContext context) => context.scaleButtonHeight;

  /// Hauteur minimale d'accessibilité
  double get minTouchTarget => DesignConstants.xxxxl;

  /// Multiplicateur pour les icônes grandes (boutons, logos)
  double get largeIconMultiplier => DesignConstants.largeIconMultiplier;
}

/// Dimensions et contraintes de layout
class Layout {
  const Layout._();

  /// Largeur maximale des champs de formulaire
  double formFieldMaxWidth(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.formWidth);

  /// Largeur maximale des modals
  double modalMaxWidth(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.modalWidth);

  /// Largeur maximale des boutons
  double buttonMaxWidth(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.buttonWidth);

  /// Facteur de largeur pour les boutons sur grand écran
  double buttonWidthFactor(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.buttonWidthFactor);

  /// Hauteur maximale des modals (en pourcentage de l'écran)
  double get modalMaxHeightFactor => DesignConstants.modalHeightFactorDefault;

  /// Facteur multiplicatif pour la hauteur minimale des modales
  double get modalMinHeightFactor => DesignConstants.modalMinHeightFactor;

  /// Largeur maximale des conteneurs de contenu
  double contentContainerMaxWidth(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.contentContainerWidth);

  /// Largeur maximale des conteneurs principaux
  double mainContainerMaxWidth(BuildContext context) {
    final value = context.applyPattern(ResponsivePatterns.mainContainerWidth);
    // Éviter de propager une largeur infinie dans des contextes non contraints
    // (ex: éléments d'une liste horizontale). On borne à la largeur d'écran.
    return value.isFinite ? value : MediaQuery.of(context).size.width;
  }

  /// Largeur minimale des conteneurs principaux
  double get mainContainerMinWidth => DesignConstants.fourHundred;

  /// Hauteur du séparateur visuel
  double get separatorHeight => DesignConstants.twoHundred;

  /// Marge horizontale du séparateur
  double get separatorHorizontalMargin => DesignConstants.xl;

  /// Padding des sections principales
  double sectionPadding(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.sectionPadding);

  /// Largeur maximale des boutons dans les sections
  double buttonSectionMaxWidth(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.buttonSectionWidth);

  /// Espacement pour écrans très petits (mobile compact)
  double get compactScreenSpacing => DesignConstants.ten;

  /// Espacement standard pour écrans mobiles
  double get mobileScreenSpacing => DesignConstants.xl;

  /// Espacement pour le contenu principal sur mobile
  double get mobileContentSpacing => DesignConstants.forty;

  /// Espacement pour les sections sur mobile
  double get mobileSectionSpacing => DesignConstants.seventyTwo;

  /// Nombre de lignes pour les champs de description (responsive)
  int descriptionLines(BuildContext context) => context.responsiveValue<int>(
    mobile: ResponsivePatterns.descriptionLines[0],
    tablet: ResponsivePatterns.descriptionLines[1],
    desktop: ResponsivePatterns.descriptionLines[2],
    desktopLarge: ResponsivePatterns.descriptionLines[3],
  );

  /// Facteurs de hauteur maximale pour les modales (responsive)
  double modalHeightFactor(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.modalHeightFactor);

  /// Hauteur seuil pour les très petits écrans
  double get verySmallScreenThreshold =>
      DesignConstants.verySmallScreenThreshold;

  /// Largeur seuil pour les écrans très étroits
  double get veryNarrowScreenThreshold =>
      DesignConstants.veryNarrowScreenThreshold;

  /// Largeur seuil pour les grands desktops
  double get largeDesktopThreshold => DesignConstants.largeDesktopThreshold;

  /// Ratio de largeur pour les conteneurs landscape
  double get landscapeContainerRatio => DesignConstants.landscapeContainerRatio;

  /// Ratio de largeur pour les conteneurs portrait
  double get portraitContainerRatio => DesignConstants.portraitContainerRatio;

  /// Ratio de hauteur minimale pour les conteneurs
  double get minContainerHeightRatio => DesignConstants.minContainerHeightRatio;

  /// Flex principal pour desktop large
  int get largeDesktopMainFlex => 3;

  /// Flex secondaire pour desktop large
  int get largeDesktopSecondaryFlex => 2;

  /// Flex standard
  int get standardFlex => 2;

  /// Largeur du séparateur vertical
  double get verticalSeparatorWidth => DesignConstants.one;

  /// Facteur de réduction pour très petits écrans
  double get verySmallScreenFactor => DesignConstants.verySmallScreenFactor;

  /// Facteur multiplicatif pour espacement étendu
  double get extendedSpacingFactor => DesignConstants.extendedSpacingFactor;

  /// Hauteur de ligne pour le texte
  double get textLineHeight => DesignConstants.textLineHeight;

  /// Épaisseur de bordure des boutons (responsive)
  double buttonBorderWidth(BuildContext context) =>
      context.applyPattern([2.0, 2.5, 3.0, 5.0]);

  /// Taille de l'indicateur de chargement
  double get loadingIndicatorSize => DesignConstants.xxl;

  /// Épaisseur du trait de l'indicateur de chargement
  double get loadingIndicatorStrokeWidth => DesignConstants.twoPointFive;

  /// Espacement entre icône et texte dans les boutons
  double get buttonIconTextSpacing => DesignConstants.md;

  /// Espacement des lettres dans les boutons
  double get buttonLetterSpacing => DesignConstants.zeroPointFive;

  /// Ratio d'aspect standard pour les images (16:9)
  double get imageAspectRatio => DesignConstants.imageAspectRatio;

  /// Largeur de bordure pour les éléments décoratifs
  double get decorativeBorderWidth => DesignConstants.two;

  /// Hauteur minimale pour les conteneurs d'images
  double get imageMinHeight => DesignConstants.oneHundredTwenty;

  /// Largeur maximale pour les images sélectionnées
  double get imageMaxWidth => DesignConstants.oneThousandNineHundredTwenty;

  /// Hauteur maximale pour les images sélectionnées
  double get imageMaxHeight => DesignConstants.oneThousandEighty;

  /// Qualité de compression des images
  int get imageQuality => 85;

  /// Taille de l'icône d'erreur
  double get errorIconSize => DesignConstants.forty;

  /// Taille de l'icône du chip hors ligne
  double get offlineChipIconSize => DesignConstants.lg;

  /// Marge droite du chip hors ligne
  double get offlineChipRightMargin => DesignConstants.sm;

  /// Largeur de bordure subtile
  double get subtleBorderWidth => DesignConstants.zeroPointFive / 2;

  /// Largeur de bordure standard pour les cartes
  double get cardBorderWidth => DesignConstants.zeroPointFive;

  /// Nombre maximum de lignes pour les titres
  int get titleMaxLines => 2;

  /// Taille du point de statut
  double get statusDotSize => DesignConstants.ten;

  /// Taille du handle bar des modales
  double get modalHandleWidth => DesignConstants.forty;
  double get modalHandleHeight => DesignConstants.xs;

  /// Taille des icônes de titre de modale
  double get modalTitleIconSize => DesignConstants.twentyEight;

  /// Taille des icônes de catégorie dans la grille
  double get categoryGridIconSize => DesignConstants.twentyEight;

  /// Taille du point de sélection de catégorie
  double get categorySelectionDotSize => DesignConstants.six;

  /// Taille des icônes d'unité
  double get unitIconSize => DesignConstants.twentyEight;

  /// Taille des icônes de statut
  double get statusIconSize => DesignConstants.thirtyTwo;

  /// Taille des icônes de validation
  double get checkIconSize => DesignConstants.twentyEight;

  /// Hauteur des modales de catégorie (ratio de l'écran)
  double get categoryModalHeightRatio =>
      DesignConstants.categoryModalHeightRatio;

  /// Hauteur des modales d'unité (ratio de l'écran)
  double get unitModalHeightRatio => DesignConstants.unitModalHeightRatio;

  /// Nombre de colonnes dans la grille de catégories
  int get categoryGridCrossAxisCount => 3;

  /// Largeur du conteneur d'unité
  double get unitContainerWidth => DesignConstants.fiftySix;
  double get unitContainerHeight => DesignConstants.fiftySix;

  /// Largeur du conteneur de statut
  double get statusContainerWidth => DesignConstants.fiftySix;
  double get statusContainerHeight => DesignConstants.fiftySix;

  /// Largeur de bordure sélectionnée
  double get selectedBorderWidth => DesignConstants.two;

  /// Largeur de bordure non sélectionnée
  double get unselectedBorderWidth => DesignConstants.one;

  /// Hauteur standard des dividers
  double get standardDividerHeight => DesignConstants.one;

  /// Épaisseur standard des dividers
  double get standardDividerThickness => DesignConstants.zeroPointFive;

  /// Indentation standard des dividers
  double get standardDividerIndent => DesignConstants.lg;

  /// Espacement vertical pour les filtres d'analytics
  double get analyticsFiltersVerticalSpacing => DesignConstants.md;

  /// Nombre maximum de lignes pour les textes courts
  int get shortTextMaxLines => 1;

  /// Nombre minimum de caractères pour le nom d'un article
  int get itemNameMinLength => 3;

  /// Nombre maximum de lignes pour les descriptions
  int get descriptionMaxLines => 4;

  /// Flex pour les champs larges (quantité)
  int get wideFieldFlex => 2;

  /// Hauteur des modales de filtres (ratio de l'écran)
  double get filtersModalHeightRatio => DesignConstants.filtersModalHeightRatio;

  /// Tailles de modal pour l'édition de profil
  double get profileEditModalInitialSize =>
      DesignConstants.profileEditModalInitialSize;
  double get profileEditModalMinSize => DesignConstants.profileEditModalMinSize;
  double get profileEditModalMaxSize => DesignConstants.profileEditModalMaxSize;

  /// Paramètres d'ombre pour les cartes d'actions
  double get actionCardShadowBlurRadius =>
      DesignConstants.actionCardShadowBlurRadius;
  Offset get actionCardShadowOffset => const Offset(0, 2);
  double get actionCardShadowOpacity => DesignConstants.actionCardShadowOpacity;

  /// Paramètres du scanner QR
  double get qrScannerBorderRadius => DesignConstants.qrScannerBorderRadius;
  double get qrScannerBorderLength => DesignConstants.qrScannerBorderLength;
  double get qrScannerBorderWidth => DesignConstants.qrScannerBorderWidth;
  double get qrScannerCutOutSize => DesignConstants.qrScannerCutOutSize;
  double get qrScannerOverlayOpacity => DesignConstants.qrScannerOverlayOpacity;
  double get qrControlsOpacity => DesignConstants.qrControlsOpacity;

  /// Durée de l'animation de transition entre vues
  Duration get viewTransitionDuration => const Duration(milliseconds: 300);

  /// Durée de réinitialisation du scan QR
  Duration get qrScanResetDuration => const Duration(seconds: 2);

  /// Coordonnées par défaut pour les scans QR (Paris)
  Map<String, double> get defaultScanLocation => const {
    'lat': 48.8566,
    'lng': 2.3522,
  };

  /// Stops du gradient pour les pages analytics
  List<double> get analyticsGradientStops => const [
    0.0,
    0.15,
    0.35,
    0.65,
    0.85,
    1.0,
  ];

  /// Taille des icônes d'erreur dans les états d'erreur
  double get errorStateIconSize => DesignConstants.errorStateIconSize;

  /// Taille des icônes pour les états vides
  double get emptyStateIconSize => DesignConstants.emptyStateIconSize;

  /// Taille des icônes d'erreur dans les vues d'erreur
  double get errorViewIconSize => DesignConstants.errorViewIconSize;

  /// Hauteur des cartes marchands
  double merchantCardHeight(BuildContext context) =>
      context.applyPattern(ResponsivePatterns.merchantCardHeight);
}

/// Animations et durées
class AnimationTokens {
  const AnimationTokens._();

  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 250);
  Duration get slow => const Duration(milliseconds: 350);
}

/// Élevations (shadows)
class Elevation {
  const Elevation._();

  double button(BuildContext context) =>
      context.isDesktopDevice ? DesignConstants.md : DesignConstants.sm;
  double get card => DesignConstants.xs;
  double get modal => DesignConstants.lg;

  /// Rayon de flou pour les petites ombres
  double get smallBlur => DesignConstants.three;

  /// Rayon de flou pour les ombres moyennes
  double get mediumBlur => DesignConstants.xs;

  /// Rayon de flou pour les grandes ombres
  double get largeBlur => DesignConstants.six;

  /// Offset standard pour les ombres
  Offset get standardOffset => const Offset(0, 1);

  /// Offset pour les ombres élevées
  Offset get elevatedOffset => const Offset(0, 2);
}

/// Couleurs
class ColorTokens {
  const ColorTokens._();

  /// Couleur pour le texte principal
  Color get textPrimary => Colors.white;

  /// Couleur pour le texte secondaire
  Color get textSecondary => Colors.white70;

  /// Couleur pour les éléments décoratifs
  Color get decorative => Colors.white24;

  /// Couleur pour les effets de survol (hover)
  Color get hoverEffect => Colors.white;

  /// Couleur pour les effets de pression (pressed)
  Color get pressedEffect => Colors.white;

  /// Couleur pour les SnackBar de succès
  Color get snackbarSuccess => Colors.green;

  /// Couleur pour les SnackBar d'avertissement
  Color get snackbarWarning => Colors.orange;

  /// Couleur pour les SnackBar d'erreur
  Color get snackbarError => Colors.red;

  /// Couleur de fond pour les modales
  Color get modalBackground => Colors.white;

  /// Couleur des bordures subtiles
  Color get subtleBorder => const Color(0xFFE0E0E0); // Colors.grey[200]

  /// Couleur de superposition pour traitement
  Color get processingOverlay => Colors.black54;

  /// Couleur blanche pour indicateurs
  Color get indicatorWhite => Colors.white;

  /// Couleur noire pour overlays
  Color get overlayBlack => Colors.black;
}

/// Opacités
class OpacityTokens {
  const OpacityTokens._();

  double get disabled => DesignConstants.opacityDisabled;
  double get hover => DesignConstants.opacityHover;
  double get pressed => DesignConstants.opacityPressed;
  double get overlay => DesignConstants.opacityOverlay;

  double get gradientPrimary => DesignConstants.opacityGradientPrimary;
  double get gradientSecondary => DesignConstants.opacityGradientSecondary;
  double get textSecondary => DesignConstants.opacityTextSecondary;
  double get decorative => DesignConstants.opacityDecorative;
  double get semiTransparent => DesignConstants.opacitySemiTransparent;
  double get veryTransparent => DesignConstants.opacityVeryTransparent;
  double get almostOpaque => DesignConstants.opacityAlmostOpaque;
  double get veryOpaque => DesignConstants.opacityVeryOpaque;
  double get subtle => DesignConstants.opacitySubtle;
  double get analyticsBackground => DesignConstants.opacityAnalyticsBackground;
  double get verySubtle => DesignConstants.opacityVerySubtle;
  double get emptyStateIconOpacity => DesignConstants.opacityEmptyStateIcon;
  double get selectedBorderMultiplier =>
      DesignConstants.selectedBorderMultiplier;
}

/// Constantes de validation pour les formulaires
class Validation {
  const Validation._();

  /// Longueurs minimales et maximales pour les titres
  int get titleMinLength => 5;
  int get titleMaxLength => 100;

  /// Longueur minimale pour les descriptions
  int get descriptionMinLength => 20;

  /// Espacement standard pour les dialogues
  double get dialogContentSpacing => DesignConstants.lg;
}

/// Constantes pour les offres urgentes
class UrgentOffers {
  const UrgentOffers._();

  /// Durée de l'animation de pulsation
  Duration get pulseAnimationDuration => const Duration(seconds: 2);

  /// Valeurs de l'animation de pulsation
  double get pulseBegin => DesignConstants.one;
  double get pulseEnd => DesignConstants.pulseEnd;

  /// Opacité pour les arrière-plans d'urgence
  double get backgroundOpacity => DesignConstants.opacitySubtle;
  double get shadowOpacity => DesignConstants.opacityPressed;
  double get overlayOpacity => DesignConstants.opacityVeryTransparent;

  /// Multiplicateur pour l'icône d'état vide
  double get emptyStateIconMultiplier => DesignConstants.largeIconMultiplier;

  /// Hauteur de la modale d'offre urgente (ratio de l'écran)
  double get modalHeightRatio => DesignConstants.urgentOffersModalHeightRatio;

  /// Espace pour la barre de réservation
  double get reservationBarSpacing => DesignConstants.hundred;

  /// Multiplicateur de distance pour les cartes
  double get baseDistance => DesignConstants.baseDistance;
  double get distanceIncrement => DesignConstants.distanceIncrement;

  /// Seuils de temps pour l'urgence (en minutes)
  int get criticalTimeThreshold => 30; // minutes
  int get urgentTimeThreshold => 60; // minutes
  int get warningTimeThreshold => 120; // minutes (2 heures)

  /// Seuils de quantité pour stock faible
  int get lowStockThreshold => 3;
  int get criticalStockThreshold => 1;

  /// Durée de la snackbar de succès
  Duration get successSnackBarDuration => const Duration(seconds: 3);

  /// Couleurs pour les snackbars
  Color get successSnackBarColor => Colors.green;
  Color get errorSnackBarColor => Colors.red;
  Color get snackBarTextColor => Colors.white;

  /// Modal background color
  Color get modalBackgroundColor => Colors.transparent;

  /// Rayon de bordure pour les bottom sheets
  double get bottomSheetBorderRadius => DesignConstants.xl;

  /// Padding pour les bottom sheets
  double get bottomSheetPadding => DesignConstants.xl;

  /// Espacement vertical dans les bottom sheets
  double get bottomSheetVerticalSpacing => DesignConstants.xl;

  /// Couleurs pour les indicateurs de tri/filtrage
  Color get sortUrgentColor => Colors.red;
  Color get sortLocationColor => Colors.blue;
  Color get sortPriceColor => Colors.green;
  Color get sortStockColor => Colors.orange;
  Color get sortSelectedBackgroundColor => Colors.red.shade50;

  /// Durée des snackbars d'information
  Duration get infoSnackBarDuration => const Duration(seconds: 1);
}

/// Constantes pour l'écran d'accueil
class HomeScreen {
  const HomeScreen._();

  /// Espacement supérieur de l'écran d'accueil
  double topSpacing(BuildContext context) => context.applyPattern([
    EcoPlatesDesignTokens.spacing.xs,
    EcoPlatesDesignTokens.spacing.sm,
    EcoPlatesDesignTokens.spacing.md,
    EcoPlatesDesignTokens.spacing.md,
  ]);

  /// Espacement inférieur de l'écran d'accueil
  double bottomSpacing(BuildContext context) => context.applyPattern([
    EcoPlatesDesignTokens.spacing.md,
    EcoPlatesDesignTokens.spacing.lg,
    EcoPlatesDesignTokens.spacing.xl,
    EcoPlatesDesignTokens.spacing.xl,
  ]);

  /// Ordre des sections de l'écran d'accueil
  List<String> get sectionOrder => const [
    'brand', // Grandes enseignes (toujours en premier)
    'categories', // Catégories
    'nearby', // Près de chez vous
    'urgent', // Offres urgentes
    'recommended', // Recommandé pour vous
    'meals', // Repas complets
    'merchants', // Marchands partenaires
    'videos', // Vidéos et astuces
    'favorites', // Commerçants favoris
  ];

  /// Sections visibles sur mobile
  List<String> get mobileSections => sectionOrder;

  /// Sections visibles sur tablette
  List<String> get tabletSections => sectionOrder;

  /// Sections visibles sur desktop
  List<String> get desktopSections => sectionOrder;
}

/// Constantes pour les vidéos
class Video {
  const Video._();

  /// Seuil pour considérer une vidéo comme populaire (nombre de vues)
  int get popularThreshold => 10000;

  /// Nombre de jours pour considérer une vidéo comme récente
  int get recentDaysThreshold => 3;

  /// Ratio d'aspect pour la grille de vidéos sur mobile
  double get mobileGridAspectRatio => DesignConstants.mobileGridAspectRatio;

  /// Ratio d'aspect pour la grille de vidéos sur tablette
  double get tabletGridAspectRatio => DesignConstants.tabletGridAspectRatio;

  /// Ratio d'aspect pour la grille de vidéos sur desktop
  double get desktopGridAspectRatio => DesignConstants.desktopGridAspectRatio;

  /// Ratio d'aspect pour la grille de vidéos sur desktop large
  double get desktopLargeGridAspectRatio =>
      DesignConstants.desktopLargeGridAspectRatio;

  /// Ratio d'aspect standard pour les miniatures vidéo (16:9)
  double get thumbnailAspectRatio => DesignConstants.thumbnailAspectRatio;

  /// Nombre maximum de lignes pour les titres de vidéos
  int get titleMaxLines => 2;

  /// Nombre maximum de lignes pour les descriptions de vidéos
  int get descriptionMaxLines => 3;
}

/// Constantes pour les charts analytics
class AnalyticsCharts {
  const AnalyticsCharts._();

  // === HELPERS CONSOLIDÉS ===
  double _pattern(BuildContext c, List<double> p) => c._applyPattern(p);
  double _linear(BuildContext c, double m, double s) => c.responsiveValue(
    mobile: m,
    tablet: m + s,
    desktop: m + 2 * s,
    desktopLarge: m + 3 * s,
  );
  double _value(BuildContext c, double m, double t, double d, double dl) =>
      c.responsiveValue(mobile: m, tablet: t, desktop: d, desktopLarge: dl);

  // === DIMENSIONS RESPONSIVES ===
  double chartContainerHeight(BuildContext c) =>
      _pattern(c, ResponsivePatterns.chartContainerHeight);
  double barWidth(BuildContext c) => _pattern(c, ResponsivePatterns.barWidth);
  double labelWidth(BuildContext c) => barWidth(c);
  double barSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.barSpacing);
  double maxBarHeight(BuildContext c) =>
      _pattern(c, ResponsivePatterns.maxBarHeight);
  double get minBarHeight => DesignConstants.xs;

  // === PADDING ET MARGES ===
  double chartPadding(BuildContext c) =>
      _pattern(c, ResponsivePatterns.chartPadding);
  double headerElementPadding(BuildContext c) =>
      _pattern(c, ResponsivePatterns.headerElementSpacing);
  EdgeInsets get chartHeaderPadding =>
      const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
  double get chartHeaderIconSpacing => DesignConstants.six;
  double get chartHeaderContentSpacing => DesignConstants.lg;
  double chartContentHeight(BuildContext c) => _value(c, 140, 160, 180, 200);
  double chartContentPadding(BuildContext c) =>
      c.applyPattern(ResponsivePatterns.smToXl);
  double chartVerticalPadding(BuildContext c) =>
      c.applyPattern(ResponsivePatterns.smToXl);
  double chartElementSpacing(BuildContext c) =>
      c.applyPattern(ResponsivePatterns.smToXl);
  double pieChartSize(BuildContext c) => _value(c, 80, 100, 120, 140);
  double legendMaxHeight(BuildContext c) => _value(c, 100, 120, 140, 160);
  List<int> mobileFlexRatio(BuildContext c) =>
      c.isMobileDevice ? [1, 2] : [2, 3];

  // === PIE CHART CONSTANTS ===
  double get pieChartBorderWidth => DesignConstants.two;
  double get pieChartShadowBlurRadius => DesignConstants.sm;
  Offset get pieChartShadowOffset => const Offset(0, 3);
  double get pieChartInnerMargin => DesignConstants.xs;
  double get pieChartSectorStrokeWidth => DesignConstants.two;
  double get donutCenterRatio => DesignConstants.opacitySemiTransparent;
  double get donutCenterStrokeWidth => DesignConstants.one;

  // === REUSABLE CHART ===
  double iconSize(BuildContext c) => _pattern(c, ResponsivePatterns.iconSize);
  double iconTextSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.iconTextSpacing);
  double valueTextReservedHeight(BuildContext c) =>
      _pattern(c, ResponsivePatterns.valueTextHeight);
  EdgeInsets get valueContainerPadding =>
      const EdgeInsets.symmetric(horizontal: 3, vertical: 1);
  double get valueContainerBorderRadius => DesignConstants.xs;
  double get valueTextLetterSpacing => DesignConstants.zeroPointFive / 2;
  Offset get valueTextShadowOffset => const Offset(0, 1);
  double get valueTextShadowBlurRadius => DesignConstants.two;
  double get connectionLineStrokeWidth => DesignConstants.twoPointFive;
  double connectionPointRadius(BuildContext c) =>
      _pattern(c, ResponsivePatterns.connectionPointRadius);
  double connectionPointBackgroundRadius(BuildContext c) =>
      _pattern(c, ResponsivePatterns.connectionPointBackgroundRadius);
  double get connectionPointShadowBlurRadius => DesignConstants.three;
  double get minSpaceForValueText => DesignConstants.fifteen;
  double get headerVerticalPaddingAdjustment => DesignConstants.two;
  double get iconPaddingAdjustment => DesignConstants.xs;
  double get iconBorderRadiusAdjustment => DesignConstants.xs;
  double get counterHorizontalPaddingAdjustment => DesignConstants.two;
  double get counterVerticalPaddingAdjustment => DesignConstants.five;
  String get noDataText => 'Aucune donnée disponible';
  double get labelConstraintExtraWidth => DesignConstants.xl;
  double get gridToLabelsSpacing => DesignConstants.sm;
  double get valueToBarSpacing => DesignConstants.xs;

  // === BORDER RADII ===
  double get defaultBorderRadius => DesignConstants.sm;
  double get chartBorderRadius => DesignConstants.lg;
  double get barBorderRadius => DesignConstants.six;
  double get chartHeaderBorderRadius => DesignConstants.sm;
  double get chartContentBorderRadius => DesignConstants.md;

  // === LEGEND PROPERTIES ===
  EdgeInsets get legendItemMargin => const EdgeInsets.only(bottom: 6);
  EdgeInsets get legendItemPadding =>
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  double get legendItemBorderRadius => DesignConstants.six;
  double get legendColorIndicatorSize => DesignConstants.ten;
  double get legendColorIndicatorBorderRadius => DesignConstants.two;
  double get legendColorIndicatorSpacing => DesignConstants.six;
  EdgeInsets get legendBadgePadding =>
      const EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  double get legendBadgeBorderRadius => DesignConstants.sm;

  // === FONT SIZES ===
  double titleFontSize(BuildContext c) => _linear(c, 12, 2);
  double counterFontSize(BuildContext c) => _linear(c, 9, 1);
  double labelFontSize(BuildContext c) => _value(c, 8, 10, 11, 12);
  double valueFontSize(BuildContext c) => _linear(c, 8, 1);
  double chartTitleFontSize(BuildContext c) => _linear(c, 12, 2);
  double chartLegendFontSize(BuildContext c) => _value(c, 8, 10, 11, 12);
  double chartBadgeFontSize(BuildContext c) => _linear(c, 8, 1);

  // === BORDER WIDTHS ===
  double get defaultBorderWidth => DesignConstants.one;
  double get chartBorderWidth => DesignConstants.onePointFive;
  double get majorGridStrokeWidth => DesignConstants.onePointFive;
  double get minorGridStrokeWidth => DesignConstants.zeroPointFive;

  // === ALPHA VALUES ===
  double get surfaceAlpha => 0.15;
  double get surfaceHighAlpha => DesignConstants.opacityVeryTransparent;
  double get outlineAlpha => DesignConstants.opacitySubtle;
  double get shadowAlpha => DesignConstants.opacityVeryTransparent;
  double get secondaryBorderAlpha => DesignConstants.opacityPressed;
  double get tertiaryAlpha => DesignConstants.opacityVerySubtle;

  // === CHART ALPHAS ===
  double get surfaceAlphaAdjustmentSmall => DesignConstants.opacityVerySubtle;
  double get barGradientAlpha1 => DesignConstants.opacityAlmostOpaque;
  double get barGradientAlpha2 => 0.55;
  double get barGradientAlpha3 => DesignConstants.opacitySubtle;
  double get barShadowAlpha => DesignConstants.opacitySubtle;
  double get barBorderAlpha => DesignConstants.opacityVeryTransparent;
  double get valueContainerBackgroundAlpha =>
      DesignConstants.opacityAlmostOpaque;
  double get valueTextShadowAlpha => DesignConstants.opacityAlmostOpaque;
  double get connectionLineAlpha1 => DesignConstants.opacitySemiTransparent;
  double get connectionLineAlpha2 => DesignConstants.opacityDisabled;
  double get connectionLineAlpha3 => DesignConstants.opacityVeryTransparent;
  double get connectionPointShadowAlpha => DesignConstants.opacitySubtle;
  double get connectionPointBorderAlpha => DesignConstants.opacityAlmostOpaque;
  double get connectionLineShadowAlpha => DesignConstants.opacityVerySubtle;
  double get backgroundGradientAdjustment1 => DesignConstants.opacityVerySubtle;
  double get backgroundGradientAdjustment2 =>
      DesignConstants.opacityVeryTransparent;

  // === CATEGORIES CHART CONSTANTS ===
  double get categoriesHeaderBackgroundAlpha =>
      DesignConstants.opacityVerySubtle;
  double get categoriesHeaderBorderAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get categoriesIconContainerAlpha =>
      DesignConstants.opacityVeryTransparent;
  EdgeInsets get categoriesIconContainerPadding => const EdgeInsets.all(4.0);
  double get categoriesChartSurfaceHighAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get categoriesChartSurfaceMediumAlpha =>
      DesignConstants.opacityVerySubtle;
  double get categoriesChartSurfaceLowAlpha =>
      DesignConstants.opacityVerySubtle;
  List<double> get categoriesChartGradientStops => const [0.0, 0.6, 1.0];
  double get categoriesChartBorderAlpha => DesignConstants.opacityPressed;
  double get categoriesPieChartGradientHighAlpha =>
      DesignConstants.opacityPressed;
  double get categoriesPieChartGradientLowAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get categoriesPieChartBorderAlpha => DesignConstants.opacitySubtle;
  double get categoriesPieChartShadowAlpha => DesignConstants.opacityPressed;
  double get categoriesLegendItemBackgroundAlpha =>
      DesignConstants.opacitySubtle;
  double get categoriesLegendItemBorderAlpha => DesignConstants.opacityPressed;
  double get categoriesLegendIndicatorShadowAlpha =>
      DesignConstants.opacitySubtle;
  double get categoriesPieSectorBorderAlpha =>
      DesignConstants.opacityAlmostOpaque;
  double get categoriesLegendBadgeBackgroundAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get categoriesDonutCenterBorderAlpha => DesignConstants.opacitySubtle;
  double get categoriesLegendIndicatorShadowBlurRadius => 3.0;
  Offset get categoriesLegendIndicatorShadowOffset => const Offset(0, 1);

  // === REUSABLE CHART CONSTANTS ===
  double get chartShadowSpreadRadius => 1.0;
  double get connectionLineShadowBlurRadius => 3.0;
  double get connectionLineShadowStrokeWidth => 4.0;
  double get connectionPointBorderStrokeWidth => 1.0;

  // Chart layout constants
  int get chartGridLinesDivisor => 5;
  double get connectionPointShadowOffsetY => 1.0;
  int get chartVerticalPaddingMultiplier => 2;

  // === CUSTOMER SATISFACTION CHART CONSTANTS ===
  // Colors
  Color get satisfactionGoldColor => const Color(0xFFFFD700);
  Color get satisfactionGoldLightColor => const Color(0xFFFFA000);
  Color get satisfactionGoldDarkColor => const Color(0xFFFF6F00);

  // Alpha values
  double get satisfactionGradientAlpha => 0.1;
  double get satisfactionBorderAlpha => 0.3;
  double get satisfactionHeaderBackgroundAlpha => 0.9;
  double get satisfactionShadowAlpha => 0.3;
  double get satisfactionUnfilledStarAlpha => 0.3;

  // Layout
  int get ratingStarsCount => 5;
  double get satisfactionHeaderShadowBlurRadius => 8.0;
  Offset get satisfactionHeaderShadowOffset => const Offset(0, 3);

  // === LOADING/ERROR SECTION CONSTANTS ===
  // Dimensions
  double get loadingErrorMaxWidth => 300.0;
  double get loadingErrorIconContainerSize => 60.0;
  double get loadingErrorIconSize => 30.0;
  double get loadingProgressStrokeWidth => 2.0;

  // Spacing
  double get loadingErrorPadding => 24.0;
  double get loadingErrorLargeSpacing => 20.0;
  double get loadingErrorSmallSpacing => 8.0;

  // Border radius
  double get loadingErrorBorderRadius => 16.0;

  // Alpha
  double get loadingErrorBackgroundAlpha => 0.1;

  // === TOP PRODUCTS CHART CONSTANTS ===
  // Currency formatting
  String get topProductsCurrencyLocale => 'fr_FR';
  String get topProductsCurrencySymbol => '€';
  int get topProductsCurrencyMaxDecimalDigits => 2;

  // Rank colors
  List<Color> get topProductsRankColors => const [
    Color(0xFFFFD700), // Or pour le #1
    Color(0xFFC0C0C0), // Argent pour le #2
    Color(0xFFCD7F32), // Bronze pour le #3
    Color(0xFF4CAF50), // Vert émeraude pour le #4
    Color(0xFF2196F3), // Bleu pour le #5
    Color(0xFF9C27B0), // Violet pour le #6
    Color(0xFFFF9800), // Orange pour le #7
    Color(0xFFE91E63), // Rose pour le #8
    Color(0xFF00BCD4), // Cyan pour le #9
    Color(0xFF8BC34A), // Vert clair pour le #10
    Color(0xFF3F51B5), // Indigo pour le #11+
  ];

  // Category colors
  Map<String, Color> get topProductsCategoryColors => const {
    'Pizza': Color(0xFFFF6B6B),
    'Burger': Color(0xFF4ECDC4),
    'Pasta': Color(0xFF45B7D1),
    'Salade': Color(0xFF96CEB4),
    'Dessert': Color(0xFFFECA57),
    'Boisson': Color(0xFF74B9FF),
    'Entrée': Color(0xFFA29BFE),
    'Plat': Color(0xFFFD79A8),
    'Végétarien': Color(0xFF00B894),
    'Viande': Color(0xFFE17055),
    'Poisson': Color(0xFF0984E3),
    'Asiatique': Color(0xFFE84393),
    'Italien': Color(0xFFD63031),
    'Français': Color(0xFF6C5CE7),
  };

  // Shadow spread radius for rank badge
  double get topProductsRankBadgeShadowSpreadRadius => 1.0;

  // === SHADOWS ===
  double get shadowBlurRadius => 12.0;
  Offset get shadowOffset => const Offset(0, 6);
  double get secondaryShadowBlurRadius => DesignConstants.six;
  Offset get secondaryShadowOffset => const Offset(0, 3);
  double get barShadowBlurRadius => DesignConstants.six;
  Offset get barShadowOffset => const Offset(0, 3);

  // === COLOR PALETTES ===
  List<int> get barColorsHex => const [
    0xFF4CAF50,
    0xFFFF9800,
    0xFF9C27B0,
    0xFF00BCD4,
    0xFF8BC34A,
    0xFF2196F3,
    0xFFFF5722,
  ];
  List<int> get connectionPointColorsHex => const [
    0xFF03DAC6,
    0xFFFF4081,
    0xFF4CAF50,
    0xFFFF9800,
    0xFF9C27B0,
    0xFF00BCD4,
    0xFF8BC34A,
  ];

  // === FIXED COLORS ===
  Color get valueContainerBackgroundColor => Colors.black;
  Color get valueTextColor => Colors.white;
  Color get valueTextShadowColor => Colors.black;
  Color get connectionLineColor1 => Colors.grey.shade600;
  Color get connectionLineColor2 => Colors.grey.shade500;
  Color get connectionLineColor3 => Colors.grey.shade400;
  Color get connectionPointBackgroundColor => Colors.white;
  Color get connectionPointShadowColor => Colors.black;
  Color get transparentColor => Colors.transparent;

  // === GRID ===
  int get majorGridLines => 4;
  double get gridDotRadius => 1.0;
  List<double> get gradientStops => const [0, 0.6, 1];
  List<double> get connectionLineGradientStops => const [0.0, 0.5, 1.0];

  // === UTILITY CALCULATIONS ===
  double calculateTotalWidthResponsive(int pointCount, BuildContext c) =>
      (pointCount * barWidth(c)) + (pointCount - 1) * barSpacing(c);
  double calculateTotalWidth(int pointCount) =>
      (pointCount * 24.0) + (pointCount - 1) * 8.0;

  // === ICON SIZES ===
  double get chartHeaderIconSize => 16.0;
  double get chartHeaderIconContainerSize => 4.0;

  // === TOP PRODUCTS CHART ===
  double topProductsChartHeight(BuildContext c) =>
      _value(c, 180, 200, 220, 240);
  double topProductsRankBadgeSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.rankBadgeSize);
  double topProductsRankBadgeHeight(BuildContext c) =>
      _pattern(c, ResponsivePatterns.rankBadgeHeight);
  double topProductsRankInnerSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.rankInnerSize);
  double topProductsRankInnerHeight(BuildContext c) =>
      _pattern(c, ResponsivePatterns.rankInnerSize);

  // === SPACING ===
  double get topProductsChartHorizontalPadding => 16.0;
  double get topProductsChartCardPadding => 16.0;
  double get topProductsHeaderHorizontalPadding => 6.0;
  double get topProductsHeaderVerticalPadding => 4.0;
  double get topProductsHeaderIconPadding => 3.0;
  double get topProductsHeaderIconSpacing => 4.0;
  double get topProductsHeaderVerticalSpacing => 16.0;
  double get topProductsChartContentPadding => 12.0;
  double get topProductsProductVerticalMargin => 8.0;
  double get topProductsProductPadding => 8.0;
  double get topProductsProductHorizontalSpacing => 8.0;
  double get topProductsProductVerticalSpacing => 1.0;
  double get topProductsCategoryHorizontalPadding => 5.0;
  double get topProductsCategoryVerticalPadding => 2.0;
  double get topProductsRevenueHorizontalPadding => 6.0;
  double get topProductsRevenueVerticalPadding => 3.0;
  double get topProductsStatsVerticalSpacing => 2.0;
  double get topProductsQuantityIconSpacing => 1.0;

  // === BORDER RADII ===
  double get topProductsHeaderBorderRadius => 6.0;
  double get topProductsChartBorderRadius => 10.0;
  double get topProductsProductBorderRadius => 10.0;
  double get topProductsRankBadgeBorderRadius => 8.0;
  double get topProductsRankInnerBorderRadius => 6.0;
  double get topProductsHeaderIconBorderRadius => 3.0;
  double get topProductsCategoryBorderRadius => 10.0;
  double get topProductsRevenueBorderRadius => 8.0;

  // === ICON SIZES ===
  double get topProductsHeaderIconSize => 14.0;
  double get topProductsQuantityIconSize => 10.0;

  // === FONT SIZES ===
  double get topProductsHeaderTitleFontSize => 13.0;
  double get topProductsProductNameFontSize => 13.0;
  double get topProductsCategoryFontSize => 9.0;
  double get topProductsRevenueFontSize => 10.0;
  double get topProductsQuantityFontSize => 9.0;
  double get topProductsRankFontSize => 11.0;

  // === ALPHAS ===
  double get topProductsHeaderBackgroundAlpha =>
      DesignConstants.opacityVerySubtle;
  double get topProductsHeaderBorderAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsHeaderIconBackgroundAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsChartSurfaceHighAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsChartSurfaceMediumAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsChartSurfaceLowAlpha =>
      DesignConstants.opacityVerySubtle;
  double get topProductsChartBorderAlpha => DesignConstants.opacityPressed;
  double get topProductsProductBackgroundHighAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsProductBackgroundMediumAlpha =>
      DesignConstants.opacityPressed;
  double get topProductsProductBackgroundLowAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsProductBorderAlpha => DesignConstants.opacitySubtle;
  double get topProductsProductShadowAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsRankGradientHighAlpha =>
      DesignConstants.opacityAlmostOpaque;
  double get topProductsRankGradientMediumAlpha =>
      DesignConstants.opacityAlmostOpaque;
  double get topProductsRankGradientLowAlpha => DesignConstants.opacityDisabled;
  double get topProductsRankBorderAlpha => DesignConstants.opacitySubtle;
  double get topProductsRankShadowPrimaryAlpha =>
      DesignConstants.opacityDisabled;
  double get topProductsRankShadowSecondaryAlpha =>
      DesignConstants.opacitySubtle;
  double get topProductsRankInnerBackgroundAlpha =>
      DesignConstants.opacityPressed;
  double get topProductsCategoryBackgroundHighAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsCategoryBackgroundLowAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsCategoryBorderAlpha => DesignConstants.opacitySubtle;
  double get topProductsRevenueBackgroundHighAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get topProductsRevenueBackgroundLowAlpha =>
      DesignConstants.opacityVerySubtle;
  double get topProductsRevenueBorderAlpha => DesignConstants.opacityPressed;
  double get topProductsQuantityIconAlpha =>
      DesignConstants.opacitySemiTransparent;
  double get topProductsRankTextShadowAlpha => 0.26;

  // === SHADOWS ===
  double get topProductsProductShadowBlurRadius => 4.0;
  Offset get topProductsProductShadowOffset => const Offset(0, 2);
  double get topProductsRankShadowPrimaryBlurRadius => 6.0;
  Offset get topProductsRankShadowPrimaryOffset => const Offset(0, 3);
  double get topProductsRankShadowSecondaryBlurRadius => 3.0;
  Offset get topProductsRankShadowSecondaryOffset => const Offset(0, 1);
  Offset get topProductsRankTextShadowOffset => const Offset(0, 1);
  double get topProductsRankTextShadowBlurRadius => 2.0;

  // === GRADIENT STOPS ===
  List<double> get topProductsChartGradientStops => const [0.0, 0.6, 1.0];
  List<double> get topProductsProductGradientStops => const [0.0, 0.5, 1.0];
  List<double> get topProductsRankGradientStops => const [0.0, 0.6, 1.0];

  // === BORDER WIDTHS ===
  double get topProductsProductBorderWidth => 1.5;
  double get topProductsRankBorderWidth => 1.5;

  // === TEXT & TYPOGRAPHY ===
  String get topProductsTitle => 'Top produits';
  double get topProductsRankLetterSpacing => 0.5;
  FontWeight get topProductsHeaderTitleWeight => FontWeight.w700;
  FontWeight get topProductsProductNameWeight => FontWeight.w600;
  FontWeight get topProductsCategoryWeight => FontWeight.w600;
  FontWeight get topProductsRevenueWeight => FontWeight.w700;
  FontWeight get topProductsQuantityWeight => FontWeight.w500;
  FontWeight get topProductsRankWeight => FontWeight.w900;

  // === FIXED COLORS ===
  Color get topProductsRankTextShadowColor => Colors.black26;
  Color get topProductsRankTextColor => Colors.white;
  Color get topProductsRankInnerBackgroundColor => Colors.white;

  // === KPI CARDS ===
  double kpiCardIconSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardIconSize);

  // === SHIMMER DIMENSIONS ===
  double get kpiCardShimmerIconSize => 34.0;
  double get kpiCardShimmerIconHeight => 34.0;
  double get kpiCardShimmerTitleWidth => 70.0;
  double get kpiCardShimmerTitleHeight => DesignConstants.md;
  double get kpiCardShimmerValueWidth => DesignConstants.hundred;
  double get kpiCardShimmerValueHeight => DesignConstants.xxl;
  double get kpiCardShimmerGrowthWidth => DesignConstants.fiftySix;
  double get kpiCardShimmerGrowthHeight => DesignConstants.lg;

  // === SPACING ===
  double kpiCardPadding(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardPadding);
  double get kpiCardShimmerHeaderHorizontalSpacing => 10.0;
  double get kpiCardShimmerVerticalSpacing => 12.0;
  double get kpiCardShimmerVerticalSpacingSmall => 6.0;
  double get kpiCardIconPadding => 8.0;
  double kpiCardHeaderHorizontalSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardHeaderHorizontalSpacing);
  double kpiCardHeaderVerticalSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardHeaderVerticalSpacing);
  double kpiCardValueVerticalSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardValueVerticalSpacing);
  double kpiCardGrowthHorizontalPadding(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardGrowthHorizontalPadding);
  double kpiCardGrowthVerticalPadding(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardGrowthVerticalPadding);
  double kpiCardGrowthInnerSpacing(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardGrowthInnerSpacing);

  // === BORDER RADII ===
  double kpiCardBorderRadius(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardBorderRadius);
  double get kpiCardShimmerBorderRadius => DesignConstants.xl;
  double get kpiCardShimmerIconBorderRadius => 50.0;
  double get kpiCardShimmerTitleBorderRadius => DesignConstants.six;
  double get kpiCardShimmerValueBorderRadius => DesignConstants.xs;
  double get kpiCardShimmerGrowthBorderRadius => DesignConstants.sm;
  double get kpiCardIconBorderRadius => 50.0;
  double get kpiCardGrowthBorderRadius => DesignConstants.md;

  // === ICON & FONT SIZES ===
  double kpiCardTrendIconSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardTrendIconSize);
  double kpiCardTitleFontSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardTitleFontSize);
  double kpiCardValueFontSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardValueFontSize);
  double kpiCardGrowthFontSize(BuildContext c) =>
      _pattern(c, ResponsivePatterns.kpiCardGrowthFontSize);

  // === ESSENTIAL ALPHAS & COLORS ===
  double get kpiCardShimmerIconBackgroundAlpha => 0.5;
  double get kpiCardShimmerBarBackgroundAlpha => 0.5;
  double get kpiCardShimmerBarBackgroundAlphaLow => 0.3;
  List<Color> get kpiCardShimmerColors => const [
    Color(0xFFE0E0E0),
    Color(0xFFF5F5F5),
    Color(0xFFE0E0E0),
  ];
  double get kpiCardShimmerShadowAlpha => 0.1;
  double get kpiCardShadowPrimaryAlpha => DesignConstants.opacitySubtle;
  double get kpiCardShadowSecondaryAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get kpiCardBorderAlpha => DesignConstants.opacityPressed;
  double get kpiCardIconBackgroundAlpha => DesignConstants.opacityAlmostOpaque;
  double get kpiCardIconShadowAlpha => DesignConstants.opacitySubtle;
  double get kpiCardTitleAlpha => DesignConstants.opacityAlmostOpaque;
  double get kpiCardValueAlpha => DesignConstants.opacityVeryOpaque;
  double get kpiCardGrowthBackgroundAlpha =>
      DesignConstants.opacityVeryTransparent;
  double get kpiCardGrowthBorderAlpha => DesignConstants.opacitySubtle;
  double get kpiCardGrowthAlpha => DesignConstants.opacityVeryOpaque;

  // === SHADOWS ===
  double get kpiCardShimmerShadowBlurRadius => DesignConstants.sm;
  Offset get kpiCardShimmerShadowOffset => const Offset(0, 4);
  double get kpiCardShadowPrimaryBlurRadius => DesignConstants.md;
  Offset get kpiCardShadowPrimaryOffset => const Offset(0, 6);
  double get kpiCardShadowSecondaryBlurRadius => DesignConstants.sm;
  Offset get kpiCardShadowSecondaryOffset => const Offset(0, 4);
  double get kpiCardIconShadowBlurRadius => DesignConstants.six;
  Offset get kpiCardIconShadowOffset => const Offset(0, 2);

  // === ANIMATIONS ===
  Duration get kpiCardShimmerDuration => const Duration(milliseconds: 1500);
  double get kpiCardShimmerAnimationBegin => -1.0;
  double get kpiCardShimmerAnimationEnd => 1.0;
  Duration get kpiCardAnimationDuration => const Duration(milliseconds: 300);
  double get kpiCardScaleAnimationBegin => 1.0;
  double get kpiCardScaleAnimationEnd => 1.02;
  double get kpiCardGlowAnimationBegin => 0.0;
  double get kpiCardGlowAnimationEnd => 8.0;

  // === BORDER & TYPOGRAPHY ===
  double get kpiCardBorderWidth => 1.5;
  double get kpiCardValueLetterSpacing => -0.5;
  FontWeight get kpiCardTitleWeight => FontWeight.w600;
  FontWeight get kpiCardValueWeight => FontWeight.w800;
  FontWeight get kpiCardGrowthWeight => FontWeight.w700;

  // === FIXED COLORS ===
  Color get kpiCardTitleColor => Colors.white;
  Color get kpiCardValueColor => Colors.white;
  Color get kpiCardGrowthBackgroundColor => Colors.white;
  Color get kpiCardGrowthTextColor => Colors.white;
  Color get kpiCardGrowthBorderColor => Colors.white;
  Color get kpiCardShimmerIconBackgroundColor => Colors.white;
  Color get kpiCardShimmerShadowColor => Colors.black;
  List<double> get kpiCardShimmerGradientStops => [0.0, 0.0, 1.0];
  double get kpiCardCompactTitleBreakpoint => 768.0;
}

/// Analytics App Bar Tokens
class AnalyticsAppBarTokens {
  const AnalyticsAppBarTokens._();
  static const String merchantLogoUrl =
      'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop&crop=center';

  // Responsive dimensions
  static double iconSize(BuildContext c) => c.applyPattern([20, 22, 24, 26]);
  static double avatarRadius(BuildContext c) =>
      c.applyPattern([16, 18, 20, 22]);
  static double borderRadius(BuildContext c) => c.applyPattern([8, 10, 12, 12]);
  static double popupBorderRadius(BuildContext c) =>
      c.applyPattern([12, 14, 16, 16]);
  static double menuIconSize(BuildContext c) =>
      c.applyPattern([18, 20, 22, 24]);
  static double spacingWidth(BuildContext c) => c.applyPattern([8, 10, 12, 14]);
  static double horizontalMargin(BuildContext c) =>
      c.applyPattern([4, 6, 8, 10]);
  static double paddingAll(BuildContext c) => c.applyPattern([8, 10, 12, 14]);
  static double titlePadding(BuildContext c) => c.applyPattern([6, 8, 10, 12]);
  static double borderWidth(BuildContext c) => c.applyPattern([1, 1, 1, 1]);
  static double elevation(BuildContext c) => c.applyPattern([6, 8, 10, 12]);
  static double contentHorizontalPadding(BuildContext c) =>
      c.applyPattern([8, 10, 12, 14]);

  // Font sizes
  static double fontSizeMedium(BuildContext c) =>
      c.applyPattern([13, 14, 15, 16]);
  static double fontSizeSmall(BuildContext c) =>
      c.applyPattern([11, 12, 13, 14]);
  static double fontSizeTiny(BuildContext c) =>
      c.applyPattern([10, 11, 12, 12]);

  // Spacing
  static double spacingLarge(BuildContext c) =>
      c.applyPattern([16, 18, 20, 22]);
  static double spacingMedium(BuildContext c) =>
      c.applyPattern([8, 10, 12, 12]);
  static double spacingSmall(BuildContext c) => c.applyPattern([5, 6, 8, 8]);

  // Menu colors & durations
  static const int pdfIconColor = 0xFFE53935;
  static const int excelIconColor = 0xFF4CAF50;
  static const int settingsIconColor = 0xFF2196F3;
  static const int helpIconColor = 0xFFFF9800;
  static const Duration exportSimulationDuration = Duration(seconds: 2);
  static const Duration snackBarDuration = Duration(seconds: 3);
}

/// Extension pour accéder facilement aux tokens depuis BuildContext
extension DesignTokensExtension on BuildContext {
  EcoPlatesDesignTokens get designTokens => const EcoPlatesDesignTokens._();
}

/// Raccourcis ultra-courts pour les tokens les plus utilisés
extension DesignTokensShortcuts on BuildContext {
  // Raccourci principal
  EcoPlatesDesignTokens get dt => designTokens;
}

/// Constantes dédiées au graphique du tunnel de conversion
class ConversionFunnelConstants {
  const ConversionFunnelConstants._();

  // Container & layout
  static const double containerMargin = DesignConstants.lg;
  static const double containerBorderRadius = 20.0; // _rXl equivalent
  static const double headerPadding = DesignConstants.xl;
  static const double contentSpacing = DesignConstants.xxl;
  static const double stepHeight = 45;
  static const double funnelHeight = stepHeight;
  static const double funnelSpacing = DesignConstants.sm;
  static const double minWidth = 60;
  static const double maxWidthDefault = 280;
  static const double maxWidthClamped = 200;
  static const double centerLineTop = 0;
  static const double centerLineBottom = 0;
  static const double centerLineWidth = 2;

  // Step styling
  static const double stepPadding = DesignConstants.md;
  static const double stepPaddingHorizontal = DesignConstants.lg;
  static const double stepBorderRadius = 8.0; // _rSm equivalent
  static const double stepBorderWidth = 1.5;
  static const double stepIconPadding = DesignConstants.xs * 1.5;
  static const double stepIconSize = DesignConstants.lg;
  static const double stepStatsSpacing = DesignConstants.md;
  static const double stepStatsPaddingHorizontal = DesignConstants.xs * 1.5;
  static const double stepStatsPaddingVertical = 2;
  static const double stepStatsBorderRadius = 8.0; // _rSm equivalent

  // Header styling
  static const double headerIconPadding = DesignConstants.sm;
  static const double headerIconSize = DesignConstants.xl;
  static const double headerIconTextSpacing = DesignConstants.md;
  static const double headerSpacing = DesignConstants.md;
  static const double headerExpandedSpacing = DesignConstants.xs;
  static const double headerPeriodPaddingHorizontal = DesignConstants.sm;
  static const double headerPeriodPaddingVertical = DesignConstants.xs;
  static const double headerPeriodBorderRadius = 12.0; // _rLg equivalent

  // Drop indicator
  static const double dropIndicatorPadding = DesignConstants.sm;
  static const double dropIndicatorSize = DesignConstants.xs;
  static const double dropIndicatorSpacing = DesignConstants.xs;
  static const double dropIndicatorOffsetX = -DesignConstants.sm;
  static const double dropIndicatorOffsetY = -DesignConstants.sm;
  static const double dropIndicatorIconSize = DesignConstants.md;

  // Stats & connections
  static const double statsSpacing = DesignConstants.md;
  static const double statsCardPadding = DesignConstants.sm;
  static const double statsCardBorderRadius = 8.0; // _rSm equivalent
  static const double statsPadding = DesignConstants.lg;
  static const double statsBorderRadius = 12.0; // _rLg equivalent
  static const double statItemIconSize = DesignConstants.xl;
  static const double statItemSpacing = DesignConstants.xs;
  static const double statDividerWidth = 1;
  static const double statDividerHeight = 40;
  static const double connectionLineWidth = 2;
  static const double connectionLineHeight = DesignConstants.sm;
  static const double connectionLineBottomPosition = -DesignConstants.sm;

  // Alpha values
  static const double primaryContainerAlpha = 0.8; // _aOpaque equivalent
  static const double secondaryContainerAlpha = 0.6; // _aSolid equivalent
  static const double tertiaryContainerAlpha = 0.4; // _aHeavy equivalent
  static const double surfaceContainerAlpha = 0.1; // _aLight equivalent
  static const double surfaceContainerBorderAlpha = 0.2; // _aMed equivalent
  static const double whiteOverlayAlpha1 = 0.1; // _aLight equivalent
  static const double whiteOverlayAlpha2 = 0.05; // _aLight * .5 equivalent
  static const double outlineAlpha = 0.3; // _aStrong equivalent
  static const double iconBackgroundAlpha = 0.2; // _aMed equivalent
  static const double statsBackgroundAlpha = 0.2; // _aMed equivalent
  static const double primaryShadowAlpha = 0.3; // _aStrong equivalent
  static const double stepShadowAlpha = 0.4; // _aHeavy equivalent
  static const double stepGradientAlpha = 0.8; // _aOpaque equivalent
  static const double stepColorAlpha = 0.4; // _aHeavy equivalent
  static const double headerPrimaryAlpha = 0.3; // _aStrong equivalent
  static const double dropIndicatorShadowAlpha = 0.3; // _aStrong equivalent
  static const double percentageBadgeAlpha = 0.2; // _aMed equivalent
  static const double connectionLineAlpha = 0.6; // _aSolid equivalent

  // Shadows
  static const double shadowBlurRadius = DesignConstants.sm;
  static const double shadowOffsetY = DesignConstants.xs * 0.75;
  static const Offset stepShadowOffset = Offset(0, shadowOffsetY);
  static const Offset headerIconShadowOffset = Offset(0, shadowOffsetY);
  static const double stepShadowBlurRadius = DesignConstants.xs * 1.5;
  static const double headerIconShadowBlurRadius = shadowBlurRadius;
  static const double headerShadowBlurRadius = shadowBlurRadius;
  static const double headerShadowOffsetY = shadowOffsetY;
  static const double dropIndicatorShadowBlurRadius = stepShadowBlurRadius;

  // Typography
  static const double titleLargeFontSize = 18.0; // _fontXl equivalent
  static const double stepCountFontSize = 14.0; // _fontMd equivalent
  static const double countFontSize = 16.0; // _fontLg equivalent
  static const double stepPercentageFontSize = 10.0; // _fontXs equivalent
  static const double percentageFontSize = 10.0; // _fontXs equivalent
  static const double headerPeriodFontSize = 10.0; // _fontXs equivalent
  static const double dropIndicatorFontSize = 10.0; // _fontXs equivalent
  static const double bodySmallFontSize = 11.0; // _fontSm equivalent
  static const FontWeight titleWeight = FontWeight.w800; // _wBlack equivalent
  static const FontWeight bodyWeight = FontWeight.w600; // _wSemi equivalent
  static const FontWeight labelWeight = FontWeight.w500; // _wMd equivalent
  static const FontWeight stepLabelWeight =
      FontWeight.w600; // _wSemi equivalent
  static const FontWeight stepCountWeight =
      FontWeight.w800; // _wBlack equivalent
  static const FontWeight stepPercentageWeight =
      FontWeight.w700; // _wBold equivalent
  static const FontWeight countFontWeight =
      FontWeight.w800; // _wBlack equivalent
  static const FontWeight percentageFontWeight =
      FontWeight.w700; // _wBold equivalent
  static const FontWeight valueWeight = FontWeight.w700; // _wBold equivalent
  static const FontWeight dropRateWeight = FontWeight.w700; // _wBold equivalent
  static const double countPercentageSpacing = DesignConstants.sm;
  static const double percentageBadgeHorizontalPadding =
      DesignConstants.xs * 1.5;
  static const double percentageBadgeVerticalPadding = 2;
  static const double percentageBadgeBorderRadius = 10.0; // _rMd equivalent

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 800);
  static const int animationDurationMs = 800;
  static const int stepAnimationDelayMs = 200;
  static const double stepAnimationDelay = 0.2;
  static const double fadeBegin = 0;
  static const double fadeEnd = 1;
  static const double fadeIntervalBegin = 0;
  static const double fadeIntervalEnd = 0.8; // _aOpaque equivalent
  static const double scaleBegin = 0.8; // _aOpaque equivalent
  static const double scaleEnd = 1;
  static const double scaleIntervalBegin = 0.2; // _aMed equivalent
  static const double scaleIntervalEnd = 1;
  static const double slideBegin = -50;
  static const double slideEnd = 0;
  static const Curve fadeCurve = Curves.easeOutCubic;
  static const Curve scaleCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeOutBack;

  // Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const List<int> funnelStepColors = [
    0xFF4CAF50,
    0xFF2196F3,
    0xFFFF9800,
    0xFF9C27B0,
    0xFFF44336,
  ];

  // Funnel chart layout constants
  static const double funnelChartHorizontalPadding = 40.0;

  // Step details dialog constants
  static const String stepDetailsNumberFormatLocale = 'fr_FR';
  static const int stepDetailsDecimalPrecision = 2;

  // Utility methods
  static Color getStepColor(int index) =>
      index < 0 || index >= funnelStepColors.length
      ? const Color(0xFF757575)
      : Color(funnelStepColors[index]);

  static IconData getStepIcon(String label) {
    switch (label.toLowerCase()) {
      case 'visiteurs':
      case 'visites':
        return Icons.visibility;
      case 'paniers':
      case 'ajout panier':
        return Icons.shopping_basket;
      case 'commandes':
      case 'checkout':
        return Icons.shopping_cart;
      case 'paiements':
      case 'paiement':
        return Icons.payment;
      case 'livraisons':
      case 'livraison':
        return Icons.local_shipping;
      default:
        return Icons.circle;
    }
  }
}
