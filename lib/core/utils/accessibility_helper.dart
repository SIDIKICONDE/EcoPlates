import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Helper pour l'accessibilité et les standards WCAG
class AccessibilityHelper {
  
  /// Calcule le ratio de contraste entre deux couleurs
  /// Selon les standards WCAG 2.1
  static double calculateContrastRatio(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();
    
    final double brightest = math.max(luminance1, luminance2);
    final double darkest = math.min(luminance1, luminance2);
    
    return (brightest + 0.05) / (darkest + 0.05);
  }
  
  /// Vérifie si le contraste respecte le niveau WCAG AA (4.5:1 pour texte normal)
  static bool meetsWCAGAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = calculateContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }
  
  /// Vérifie si le contraste respecte le niveau WCAG AAA (7:1 pour texte normal)
  static bool meetsWCAGAAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = calculateContrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }
  
  /// Ajuste automatiquement une couleur pour respecter le contraste minimum
  static Color ensureContrast(
    Color foreground,
    Color background, {
    double minRatio = 4.5,
    bool preferLighter = true,
  }) {
    if (calculateContrastRatio(foreground, background) >= minRatio) {
      return foreground;
    }
    
    // Ajuster la luminosité progressivement
    var adjustedColor = foreground;
    var iterations = 0;
    const maxIterations = 100;
    
    while (calculateContrastRatio(adjustedColor, background) < minRatio && 
           iterations < maxIterations) {
      if (preferLighter) {
        adjustedColor = _lighten(adjustedColor, 0.05);
      } else {
        adjustedColor = _darken(adjustedColor, 0.05);
      }
      iterations++;
    }
    
    // Si on ne peut pas atteindre le ratio, utiliser noir ou blanc
    if (iterations >= maxIterations) {
      final blackRatio = calculateContrastRatio(Colors.black, background);
      final whiteRatio = calculateContrastRatio(Colors.white, background);
      return whiteRatio > blackRatio ? Colors.white : Colors.black;
    }
    
    return adjustedColor;
  }
  
  /// Éclaircit une couleur
  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(
      math.min(1, hsl.lightness + amount)
    ).toColor();
  }
  
  /// Assombrit une couleur
  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(
      math.max(0, hsl.lightness - amount)
    ).toColor();
  }
  
  /// Retourne une couleur de texte optimale pour un fond donné
  static Color getOptimalTextColor(
    Color background, {
    Color lightOption = Colors.white,
    Color darkOption = Colors.black87,
  }) {
    final lightRatio = calculateContrastRatio(lightOption, background);
    final darkRatio = calculateContrastRatio(darkOption, background);
    
    // Préférer le meilleur contraste
    if (lightRatio > darkRatio && lightRatio >= 4.5) {
      return lightOption;
    } else if (darkRatio >= 4.5) {
      return darkOption;
    }
    
    // Si aucun ne respecte le minimum, forcer l'ajustement
    return lightRatio > darkRatio
        ? ensureContrast(lightOption, background)
        : ensureContrast(darkOption, background);
  }
  
}

/// Couleurs accessibles pour les badges et indicateurs
class AccessibleColors {
  AccessibleColors._();
  
  // Rouge accessible sur fond sombre
  static const Color dangerRed = Color(0xFFEE4444);
  // Vert accessible
  static const Color successGreen = Color(0xFF22BB33);
  // Orange accessible  
  static const Color warningOrange = Color(0xFFF0AD4E);
  // Bleu accessible
  static const Color infoBlue = Color(0xFF5BC0DE);
  // Ambre accessible pour les étoiles
  static const Color ratingAmber = Color(0xFFFFB700);
}

/// Tailles de police recommandées pour l'accessibilité
class AccessibleFontSizes {
  AccessibleFontSizes._();
  
  static const double small = 12;  // Minimum recommandé
  static const double normal = 14;
  static const double medium = 16;
  static const double large = 18;  // Considéré comme "large text" WCAG
  static const double xlarge = 24;
}
