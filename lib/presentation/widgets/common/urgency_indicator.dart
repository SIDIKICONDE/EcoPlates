import 'package:flutter/material.dart';

/// Widget d'indicateur d'urgence pour les offres avec peu de temps restant
class UrgencyIndicator extends StatelessWidget {
  const UrgencyIndicator({
    required this.remainingTime, super.key,
    this.animate = false,
    this.animationController,
    this.pulseAnimation,
    this.size = UrgencyIndicatorSize.normal,
  });

  /// Temps restant avant expiration
  final Duration remainingTime;

  /// Active l'animation de pulsation pour les cas très urgents
  final bool animate;

  /// Contrôleur d'animation (requis si animate = true)
  final AnimationController? animationController;

  /// Animation de pulsation (requise si animate = true)
  final Animation<double>? pulseAnimation;

  /// Taille de l'indicateur
  final UrgencyIndicatorSize size;

  @override
  Widget build(BuildContext context) {
    if (remainingTime.isNegative) {
      return const SizedBox.shrink(); // Offre expirée
    }

    final theme = Theme.of(context);
    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;

    final urgencyLevel = _getUrgencyLevel(hours, minutes);
    final colors = _getColorsForLevel(theme, urgencyLevel);
    final label = _getLabelForTime(hours, minutes, urgencyLevel);
    final shouldPulse = animate && urgencyLevel == UrgencyLevel.critical;

    final indicator = Container(
      padding: _getPaddingForSize(),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(_getBorderRadiusForSize()),
        boxShadow: [
          BoxShadow(
            color: colors.background.withValues(alpha: 0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Text(
        label,
        style: _getTextStyleForSize(theme)?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (shouldPulse && pulseAnimation != null) {
      return AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: pulseAnimation!.value,
            child: indicator,
          );
        },
      );
    }

    return indicator;
  }

  UrgencyLevel _getUrgencyLevel(int hours, int minutes) {
    if (hours == 0 && minutes <= 30) {
      return UrgencyLevel.critical;
    } else if (hours == 0) {
      return UrgencyLevel.high;
    } else if (hours <= 2) {
      return UrgencyLevel.medium;
    } else {
      return UrgencyLevel.low;
    }
  }

  UrgencyColors _getColorsForLevel(ThemeData theme, UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.critical:
        return UrgencyColors(
          background: theme.colorScheme.error,
          foreground: theme.colorScheme.onError,
        );
      case UrgencyLevel.high:
        return UrgencyColors(
          background: theme.colorScheme.tertiary,
          foreground: theme.colorScheme.onTertiary,
        );
      case UrgencyLevel.medium:
        return UrgencyColors(
          background: theme.colorScheme.secondary,
          foreground: theme.colorScheme.onSecondary,
        );
      case UrgencyLevel.low:
        return UrgencyColors(
          background: theme.colorScheme.primary,
          foreground: theme.colorScheme.onPrimary,
        );
    }
  }

  String _getLabelForTime(int hours, int minutes, UrgencyLevel level) {
    switch (level) {
      case UrgencyLevel.critical:
        return '⚡ ${minutes}min';
      case UrgencyLevel.high:
        return '⏰ ${minutes}min';
      case UrgencyLevel.medium:
        return '${hours}h ${minutes}min';
      case UrgencyLevel.low:
        return '${hours}h';
    }
  }

  EdgeInsets _getPaddingForSize() {
    switch (size) {
      case UrgencyIndicatorSize.small:
        return const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0);
      case UrgencyIndicatorSize.normal:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
      case UrgencyIndicatorSize.large:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
    }
  }

  double _getBorderRadiusForSize() {
    switch (size) {
      case UrgencyIndicatorSize.small:
        return 12.0;
      case UrgencyIndicatorSize.normal:
        return 20.0;
      case UrgencyIndicatorSize.large:
        return 24.0;
    }
  }

  TextStyle? _getTextStyleForSize(ThemeData theme) {
    switch (size) {
      case UrgencyIndicatorSize.small:
        return theme.textTheme.labelSmall;
      case UrgencyIndicatorSize.normal:
        return theme.textTheme.bodySmall;
      case UrgencyIndicatorSize.large:
        return theme.textTheme.bodyMedium;
    }
  }
}

/// Niveaux d'urgence pour les offres
enum UrgencyLevel {
  critical, // < 30 min
  high, // < 1h
  medium, // < 2h
  low, // > 2h
}

/// Tailles disponibles pour l'indicateur d'urgence
enum UrgencyIndicatorSize {
  small,
  normal,
  large,
}

/// Couleurs utilisées pour l'indicateur d'urgence
class UrgencyColors {
  const UrgencyColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}
