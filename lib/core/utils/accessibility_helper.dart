import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

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
  static bool meetsWCAGAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Vérifie si le contraste respecte le niveau WCAG AAA (7:1 pour texte normal)
  static bool meetsWCAGAAA(
    Color foreground,
    Color background, {
    bool isLargeText = false,
  }) {
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
    return hsl.withLightness(math.min(1, hsl.lightness + amount)).toColor();
  }

  /// Assombrit une couleur
  static Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(math.max(0, hsl.lightness - amount)).toColor();
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

  /// Builds a comprehensive semantic label for a merchant card
  static String buildMerchantLabel({
    required String name,
    double? rating,
    double? distance,
    String? category,
    bool isOpen = true,
    bool hasDiscount = false,
    int? discountPercentage,
  }) {
    final parts = <String>[
      'Restaurant $name',
    ];

    if (category != null && category.isNotEmpty) {
      parts.add('Catégorie: $category');
    }

    if (rating != null) {
      parts.add('${rating.toStringAsFixed(1)} étoiles sur 5');
    }

    if (distance != null) {
      parts.add('${distance.toStringAsFixed(1)} kilomètres');
    }

    parts.add(isOpen ? 'Actuellement ouvert' : 'Actuellement fermé');

    if (hasDiscount && discountPercentage != null) {
      parts.add('$discountPercentage pourcent de réduction disponible');
    }

    return parts.join(', ');
  }

  /// Builds semantic label for rating display
  static String buildRatingLabel(double rating, {int? reviewCount}) {
    final ratingText = '${rating.toStringAsFixed(1)} étoiles sur 5';
    if (reviewCount != null && reviewCount > 0) {
      return '$ratingText basé sur $reviewCount avis';
    }
    return ratingText;
  }

  /// Builds semantic label for discount badge
  static String buildDiscountLabel(int percentage) {
    return '$percentage pourcent de réduction';
  }

  /// Builds semantic label for favorite button
  static String buildFavoriteButtonLabel(
    String merchantName, {
    required bool isFavorite,
  }) {
    return isFavorite
        ? 'Retirer $merchantName des favoris'
        : 'Ajouter $merchantName aux favoris';
  }

  /// Builds semantic label for price range
  static String buildPriceRangeLabel(int priceLevel) {
    final euroSigns = '€' * priceLevel;
    final priceDescriptions = [
      'Peu cher',
      'Modéré',
      'Cher',
      'Très cher',
    ];

    final description = priceLevel > 0 && priceLevel <= priceDescriptions.length
        ? priceDescriptions[priceLevel - 1]
        : 'Prix non disponible';

    return '$euroSigns, $description';
  }

  /// Builds semantic label for delivery time
  static String buildDeliveryTimeLabel(int minMinutes, int maxMinutes) {
    if (minMinutes == maxMinutes) {
      return 'Livraison en environ $minMinutes minutes';
    }
    return 'Livraison en $minMinutes à $maxMinutes minutes';
  }

  /// Builds semantic label for opening hours
  static String buildOpeningHoursLabel(
    TimeOfDay openTime,
    TimeOfDay closeTime,
  ) {
    final format = DateFormat.Hm('fr_FR');
    final openTimeStr = format.format(
      DateTime(2021, 1, 1, openTime.hour, openTime.minute),
    );
    final closeTimeStr = format.format(
      DateTime(2021, 1, 1, closeTime.hour, closeTime.minute),
    );
    return 'Ouvre à $openTimeStr, ferme à $closeTimeStr';
  }

  /// Helper to announce changes to screen readers
  static void announce(BuildContext context, String message) {
    // Use Flutter's built-in accessibility announcement
    unawaited(SemanticsService.announce(message, ui.TextDirection.ltr));
  }

  /// Creates a semantic container for grouped content
  static Widget semanticContainer({
    required Widget child,
    required String label,
    String? hint,
    bool? isButton,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      onTap: onTap,
      child: child,
    );
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

  static const double small = 12; // Minimum recommandé
  static const double normal = 14;
  static const double medium = 16;
  static const double large = 18; // Considéré comme "large text" WCAG
  static const double xlarge = 24;
}
