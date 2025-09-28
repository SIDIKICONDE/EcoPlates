import 'package:flutter/material.dart';

/// Tokens de couleurs pour le design system EcoPlates
/// Basé sur Material Design 3 avec des couleurs adaptées à l'écologie
class EcoColorTokens {
  EcoColorTokens._();

  // ===== COULEURS PRIMAIRES =====
  // Palette verte écologique
  static const Map<int, Color> _primarySwatch = {
    50: Color(0xFFE8F5E8),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF4CAF50), // Couleur principale
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  };

  static MaterialColor get primarySwatch =>
      const MaterialColor(0xFF4CAF50, _primarySwatch);

  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryContainer = Color(0xFFE8F5E8);

  // ===== COULEURS SECONDAIRES =====
  // Palette orange/amber pour contraste chaleureux
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color secondaryContainer = Color(0xFFFFF3E0);

  // ===== COULEURS TERTAIRES =====
  // Palette bleue pour les actions
  static const Color tertiary = Color(0xFF2196F3);
  static const Color tertiaryLight = Color(0xFF64B5F6);
  static const Color tertiaryDark = Color(0xFF1976D2);
  static const Color tertiaryContainer = Color(0xFFE3F2FD);

  // ===== COULEURS NEUTRES =====
  static const Color neutral0 = Color(0xFFFFFFFF); // Blanc pur
  static const Color neutral50 = Color(0xFFFAFAFA); // Blanc cassé
  static const Color neutral100 = Color(0xFFF5F5F5); // Gris très clair
  static const Color neutral200 = Color(0xFFEEEEEE); // Gris clair
  static const Color neutral300 = Color(0xFFE0E0E0); // Gris moyen clair
  static const Color neutral400 = Color(0xFFBDBDBD); // Gris moyen
  static const Color neutral500 = Color(0xFF9E9E9E); // Gris
  static const Color neutral600 = Color(0xFF757575); // Gris foncé
  static const Color neutral700 = Color(0xFF616161); // Gris très foncé
  static const Color neutral800 = Color(0xFF424242); // Presque noir
  static const Color neutral900 = Color(0xFF212121); // Noir foncé
  static const Color neutral1000 = Color(0xFF000000); // Noir pur

  // ===== COULEURS SÉMANTIQUES =====
  static const Color success = Color(0xFF4CAF50); // Vert pour succès
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);
  static const Color successContainer = Color(0xFFE8F5E8);

  static const Color warning = Color(0xFFFF9800); // Orange pour avertissement
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFE65100);
  static const Color warningContainer = Color(0xFFFFF3E0);

  static const Color error = Color(0xFFE53935); // Rouge pour erreur
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFEBEE);

  static const Color info = Color(0xFF2196F3); // Bleu pour info
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // ===== COULEURS SPÉCIALISÉES ECOPLATES =====
  static const Color eco = Color(0xFF4CAF50); // Couleur principale éco
  static const Color ecoLight = Color(0xFF81C784);
  static const Color ecoDark = Color(0xFF2E7D32);
  static const Color ecoAccent = Color(0xFF8BC34A); // Vert lime pour accents

  // Couleurs pour les badges et états
  static const Color discount = Color(0xFFE91E63); // Rose pour réductions
  static const Color urgent = Color(0xFFFF5722); // Rouge-orange pour urgence
  static const Color new_ = Color(0xFF00BCD4); // Cyan pour nouveauté
  static const Color premium = Color(0xFF9C27B0); // Violet pour premium

  // Couleurs pour les catégories alimentaires
  static const Color veggie = Color(0xFF4CAF50); // Vert pour végétarien
  static const Color vegan = Color(0xFF8BC34A); // Vert lime pour vegan
  static const Color organic = Color(0xFF795548); // Marron pour bio
  static const Color local = Color(0xFF607D8B); // Bleu-gris pour local

  // ===== GRADIENTS =====
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLight, secondary, secondaryDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient ecoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ecoLight, eco, ecoDark],
    stops: [0.0, 0.5, 1.0],
  );

  // Gradient pour les cartes héro
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00000000), // Transparent
      Color(0x80000000), // Semi-transparent
    ],
  );

  // ===== OPACITÉS STANDARDISÉES =====
  static const double opacity12 = 0.12;
  static const double opacity16 = 0.16;
  static const double opacity24 = 0.24;
  static const double opacity38 = 0.38;
  static const double opacity54 = 0.54;
  static const double opacity87 = 0.87;
}
