import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
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
    switch (tier) {
      case ConsumerTier.bronze:
        // Bronze - couleur d'accent profonde
        return DeepColorTokens.warning;
      case ConsumerTier.silver:
        // Argent - gris neutre profond
        return DeepColorTokens.neutral400;
      case ConsumerTier.gold:
        // Or - couleur d'accent premium
        return DeepColorTokens.accent;
      case ConsumerTier.platinum:
        // Platine - couleur premium royale
        return DeepColorTokens.premium;
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
