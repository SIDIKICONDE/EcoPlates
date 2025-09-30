import 'package:flutter/material.dart';

/// Tokens de couleurs pour le thème profond et confiant de Nyth
/// Un thème sophistiqué avec des couleurs profondes qui inspirent confiance et professionnalisme
class DeepColorTokens {
  DeepColorTokens._();

  // ===== COULEURS PRIMAIRES PROFONDES =====
  // Palette bleu profond pour la confiance et la stabilité
  static const Map<int, Color> _primarySwatch = {
    50: Color(0xFFE3E7F0), // Bleu très pâle
    100: Color(0xFFB8C3DA), // Bleu pâle
    200: Color(0xFF899BC2), // Bleu clair
    300: Color(0xFF5A73AA), // Bleu moyen
    400: Color(0xFF365597), // Bleu profond moyen
    500: Color(0xFF133784), // Bleu profond principal
    600: Color(0xFF11317C), // Bleu plus profond
    700: Color(0xFF0E2A71), // Bleu très profond
    800: Color(0xFF0B2367), // Bleu nuit
    900: Color(0xFF061654), // Bleu minuit
    950: Color(0xFF030B2A), // Presque noir bleuté
  };

  static MaterialColor get primarySwatch =>
      const MaterialColor(0xFF133784, _primarySwatch);

  // Couleurs primaires principales
  static const Color primary = Color(0xFF133784); // Bleu profond confiant
  static const Color primaryLight = Color(0xFF365597); // Bleu profond clair
  static const Color primaryDark = Color(0xFF0B2367); // Bleu nuit
  static const Color primaryContainer = Color(0xFFE3E7F0);

  // ===== COULEURS SECONDAIRES PROFONDES =====
  // Palette indigo/violet pour la créativité et l'innovation
  static const Color secondary = Color(0xFF4C1E7A); // Violet profond
  static const Color secondaryLight = Color(0xFF6B3F99); // Violet moyen
  static const Color secondaryDark = Color(0xFF2D0E5C); // Violet très sombre
  static const Color secondaryContainer = Color(0xFFEDE5F4);
  static const Color onSecondaryContainer = Color(0xFF2D0E5C); // secondaryDark

  // ===== COULEURS TERTAIRES =====
  // Palette teal/cyan profond pour les accents modernes
  static const Color tertiary = Color(0xFF006874); // Teal profond
  static const Color tertiaryLight = Color(0xFF00838F); // Teal moyen
  static const Color tertiaryDark = Color(0xFF004D57); // Teal très sombre
  static const Color tertiaryContainer = Color(0xFFE0F2F4);

  // ===== COULEURS D'ACCENT PREMIUM =====
  static const Color accent = Color(0xFF8B6914); // Or antique
  static const Color accentLight = Color(0xFFB8860B); // Or sombre
  static const Color accentDark = Color(0xFF654808); // Or très sombre
  static const Color accentSubtle = Color(0xFFF4E9D9); // Or très pâle

  // ===== COULEURS NEUTRES PROFONDES =====
  static const Color neutral0 = Color(0xFFFFFFFF); // Blanc pur
  static const Color neutral50 = Color(0xFFF8F9FA); // Gris très clair
  static const Color neutral100 = Color(0xFFF1F3F5); // Gris pâle
  static const Color neutral200 = Color(0xFFE9ECEF); // Gris clair
  static const Color neutral300 = Color(0xFFDEE2E6); // Gris moyen clair
  static const Color neutral400 = Color(0xFFCED4DA); // Gris moyen
  static const Color neutral500 = Color(0xFFADB5BD); // Gris standard
  static const Color neutral600 = Color(0xFF6C757D); // Gris foncé
  static const Color neutral700 = Color(0xFF495057); // Gris très foncé
  static const Color neutral800 = Color(0xFF343A40); // Charbon
  static const Color neutral850 = Color(0xFF2B3035); // Charbon foncé
  static const Color neutral900 = Color(0xFF212529); // Presque noir
  static const Color neutral950 = Color(0xFF16191C); // Noir profond
  static const Color neutral1000 = Color(0xFF000000); // Noir pur

  // Surfaces sombres profondes
  static const Color surface = Color(0xFF1A1D21); // Surface principale sombre
  static const Color surfaceElevated = Color(0xFF22262B); // Surface élevée
  static const Color surfaceContainer = Color(0xFF2B3035); // Container sombre

  // ===== COULEURS SÉMANTIQUES PROFONDES =====
  static const Color success = Color(0xFF0F5132); // Vert forêt profond
  static const Color successLight = Color(0xFF198754); // Vert émeraude
  static const Color successDark = Color(0xFF0A3622); // Vert très sombre
  static const Color successContainer = Color(0xFFD1E7DD);

  static const Color warning = Color(0xFF8B4513); // Orange brûlé profond
  static const Color warningLight = Color(0xFFD2691E); // Orange cuivré
  static const Color warningDark = Color(0xFF5C2E0A); // Orange très sombre
  static const Color warningContainer = Color(0xFFFFF3CD);

  static const Color error = Color(0xFF8B0000); // Rouge sang profond
  static const Color errorLight = Color(0xFFDC143C); // Cramoisi
  static const Color errorDark = Color(0xFF5C0000); // Rouge très sombre
  static const Color errorContainer = Color(0xFFF8D7DA);

  static const Color info = Color(0xFF0C5460); // Bleu pétrole profond
  static const Color infoLight = Color(0xFF17A2B8); // Cyan info
  static const Color infoDark = Color(0xFF083840); // Bleu pétrole sombre
  static const Color infoContainer = Color(0xFFD1ECF1);

  // ===== COULEURS SPÉCIALISÉES NYTH =====
  static const Color premium = Color(0xFF4A148C); // Violet royal profond
  static const Color premiumLight = Color(0xFF7B1FA2); // Violet moyen
  static const Color premiumDark = Color(0xFF2E0B59); // Violet très sombre

  static const Color confidence = Color(0xFF1A237E); // Bleu confiance profond
  static const Color trust = Color(0xFF0D47A1); // Bleu fidélité
  static const Color stability = Color(0xFF263238); // Gris bleuté stable
  static const Color professional = Color(0xFF37474F); // Gris professionnel

  // Couleurs pour les badges et états
  static const Color urgent = Color(0xFFB71C1C); // Rouge profond urgent
  static const Color new_ = Color(0xFF006064); // Cyan profond nouveau
  static const Color special = Color(0xFF4A148C); // Violet spécial
  static const Color exclusive = Color(0xFF1A237E); // Bleu exclusif

  // ===== GRADIENTS PROFONDS =====
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF365597), // Bleu moyen
      Color(0xFF133784), // Bleu profond
      Color(0xFF0B2367), // Bleu nuit
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7B1FA2), // Violet clair
      Color(0xFF4A148C), // Violet profond
      Color(0xFF2E0B59), // Violet sombre
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient confidenceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A237E), // Bleu confiance
      Color(0xFF0D47A1), // Bleu fidélité
      Color(0xFF133784), // Bleu profond
    ],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient darkSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1D21), // Surface sombre
      Color(0xFF16191C), // Presque noir
    ],
  );

  // Gradient pour les cartes premium
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000), // Transparent
      Color(0xCC0B2367), // Bleu nuit semi-transparent
    ],
  );

  // ===== OVERLAYS ET TRANSPARENCES =====
  static Color overlayDark = const Color(0xFF000000).withValues(alpha: 0.7);
  static Color overlayMedium = const Color(0xFF000000).withValues(alpha: 0.5);
  static Color overlayLight = const Color(0xFF000000).withValues(alpha: 0.3);
  static Color overlaySubtle = const Color(0xFF000000).withValues(alpha: 0.1);

  // Ombres profondes
  static Color shadowDeep = const Color(0xFF000000).withValues(alpha: 0.6);
  static Color shadowMedium = const Color(0xFF000000).withValues(alpha: 0.4);
  static Color shadowLight = const Color(0xFF000000).withValues(alpha: 0.2);

  // ===== OPACITÉS STANDARDISÉES =====
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.10;
  static const double opacity20 = 0.20;
  static const double opacity30 = 0.30;
  static const double opacity50 = 0.50;
  static const double opacity70 = 0.70;
  static const double opacity90 = 0.90;
}
