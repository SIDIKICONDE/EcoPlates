import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';

/// Utilitaires pour la gestion des niveaux (tiers) des consommateurs
class ConsumerTierUtils {
  /// Retourne le prochain niveau disponible
  static ConsumerTier? getNextTier(ConsumerTier currentTier) {
    switch (currentTier) {
      case ConsumerTier.bronze:
        return ConsumerTier.silver;
      case ConsumerTier.silver:
        return ConsumerTier.gold;
      case ConsumerTier.gold:
        return ConsumerTier.platinum;
      case ConsumerTier.platinum:
        return null; // Niveau maximum
    }
  }

  /// Retourne le seuil de points pour atteindre un niveau donné
  static int getTierThreshold(ConsumerTier tier) {
    switch (tier) {
      case ConsumerTier.bronze:
        return 0;
      case ConsumerTier.silver:
        return 100;
      case ConsumerTier.gold:
        return 500;
      case ConsumerTier.platinum:
        return 1000;
    }
  }

  /// Retourne la couleur associée à un niveau
  static Color getTierColor(ConsumerTier tier, {Brightness? brightness}) {
    // Adapter les couleurs selon le thème (clair/sombre)
    final isDark = brightness == Brightness.dark;

    switch (tier) {
      case ConsumerTier.bronze:
        // Marron bronze - plus visible en thème sombre
        return isDark ? const Color(0xFFD4AF37) : const Color(0xFFCD7F32);
      case ConsumerTier.silver:
        // Gris argent - plus contrasté en thème sombre
        return isDark ? const Color(0xFFE0E0E0) : const Color(0xFFC0C0C0);
      case ConsumerTier.gold:
        // Jaune or - plus brillant en thème sombre
        return isDark ? const Color(0xFFFFD700) : const Color(0xFFFFD700);
      case ConsumerTier.platinum:
        // Blanc platine - plus contrasté en thème sombre
        return isDark ? const Color(0xFFF5F5F5) : const Color(0xFFE5E4E2);
    }
  }

  /// Retourne le label textuel d'un niveau
  static String getTierLabel(ConsumerTier tier) {
    switch (tier) {
      case ConsumerTier.bronze:
        return 'Bronze';
      case ConsumerTier.silver:
        return 'Argent';
      case ConsumerTier.gold:
        return 'Or';
      case ConsumerTier.platinum:
        return 'Platine';
    }
  }
}
