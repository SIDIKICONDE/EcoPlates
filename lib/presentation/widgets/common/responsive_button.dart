import 'package:flutter/material.dart';

import '../../../core/responsive/context_responsive_extensions.dart';
import '../../../core/responsive/design_tokens.dart';

/// Bouton réutilisable avec design responsif pour EcoPlates
class ResponsiveButton extends StatelessWidget {
  const ResponsiveButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isFullWidth = true,
    this.customWidth,
    this.maxWidth,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  /// Texte affiché sur le bouton
  final String text;

  /// Callback lors du tap
  final VoidCallback onPressed;

  /// Style du bouton
  final ButtonVariant variant;

  /// Icône optionnelle (affichée uniquement sur desktop)
  final IconData? icon;

  /// Si le bouton doit prendre toute la largeur disponible
  final bool isFullWidth;

  /// Largeur personnalisée (override isFullWidth)
  final double? customWidth;

  /// Largeur maximale (par défaut, une limite adaptative sera appliquée sur tablette/desktop)
  final double? maxWidth;

  /// Taille du bouton (influe sur la hauteur et la typo)
  final ButtonSize size;

  /// Affiche un indicateur de chargement et désactive le bouton
  final bool isLoading;

  /// Active/désactive le bouton
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen =
        screenHeight < DesignConstants.verySmallScreenThreshold;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    // Utilisation des tokens de design pour la hauteur
    final baseButtonHeight = EcoPlatesDesignTokens.size.buttonHeight(context);
    final buttonHeight = isLandscape
        ? baseButtonHeight - DesignConstants.four
        : baseButtonHeight;

    final borderRadius = EcoPlatesDesignTokens.radius.buttonRadius(context);

    // Définition de la largeur
    double? buttonWidth;
    if (customWidth != null) {
      buttonWidth = customWidth;
    } else if (isFullWidth) {
      buttonWidth =
          screenWidth * EcoPlatesDesignTokens.layout.buttonWidthFactor(context);
    }

    // Contrainte de largeur max automatique sur grand écran si non précisé
    final adaptiveMaxWidth =
        maxWidth ?? EcoPlatesDesignTokens.layout.buttonMaxWidth(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: adaptiveMaxWidth,
        minHeight: EcoPlatesDesignTokens.size.minTouchTarget,
      ),
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: (enabled && !isLoading) ? onPressed : null,
          style: _getButtonStyle(context, borderRadius),
          child: _buildButtonContent(context, isVerySmallScreen),
        ),
      ),
    );
  }

  /// Génère le style selon le variant
  ButtonStyle _getButtonStyle(BuildContext context, double borderRadius) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: EcoPlatesDesignTokens.elevation.button(context),
          shadowColor: Colors.black26,
          padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(context).primaryColor.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.hover,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return Theme.of(context).primaryColor.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.pressed,
                );
              }
              return null;
            },
          ),
        );

      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: EcoPlatesDesignTokens.colors.textPrimary,
          side: BorderSide(
            color: EcoPlatesDesignTokens.colors.textPrimary,
            width: EcoPlatesDesignTokens.layout.buttonBorderWidth(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: DesignConstants.zero,
          padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return EcoPlatesDesignTokens.colors.hoverEffect.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.hover,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return EcoPlatesDesignTokens.colors.pressedEffect.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.pressed,
                );
              }
              return null;
            },
          ),
        );

      case ButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).primaryColor,
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: EcoPlatesDesignTokens.layout.buttonBorderWidth(context),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: DesignConstants.zero,
          padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(context).primaryColor.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.hover,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return Theme.of(context).primaryColor.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.pressed,
                );
              }
              return null;
            },
          ),
        );
    }
  }

  /// Construit le contenu du bouton (texte + icône optionnelle)
  Widget _buildButtonContent(BuildContext context, bool isVerySmallScreen) {
    final textStyle = TextStyle(
      fontSize: EcoPlatesDesignTokens.typography.button(context),
      fontWeight: EcoPlatesDesignTokens.typography.buttonWeight,
      letterSpacing: EcoPlatesDesignTokens.layout.buttonLetterSpacing,
    );

    if (isLoading) {
      return SizedBox(
        width: EcoPlatesDesignTokens.layout.loadingIndicatorSize,
        height: EcoPlatesDesignTokens.layout.loadingIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: EcoPlatesDesignTokens.layout.loadingIndicatorStrokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(context),
          ),
        ),
      );
    }

    // Si pas d'icône ou pas sur desktop, juste le texte
    if (icon == null || !context.isDesktopDevice) {
      return Text(text, style: textStyle);
    }

    // Sinon, icône + texte sur desktop
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: EcoPlatesDesignTokens.size.icon(context),
          color: _getIconColor(context),
        ),
        SizedBox(width: EcoPlatesDesignTokens.layout.buttonIconTextSpacing),
        Text(text, style: textStyle),
      ],
    );
  }

  /// Retourne la couleur de l'icône selon le variant
  Color _getIconColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.outline:
        return Theme.of(context).primaryColor;
      case ButtonVariant.secondary:
        return EcoPlatesDesignTokens.colors.textPrimary;
    }
  }

  /// Couleur de l'indicateur de chargement selon le variant
  Color _getProgressColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.outline:
        return Theme.of(context).primaryColor;
      case ButtonVariant.secondary:
        return EcoPlatesDesignTokens.colors.textPrimary;
    }
  }
}

/// Types de styles de bouton disponibles
enum ButtonVariant {
  /// Bouton principal (fond blanc, texte coloré)
  primary,

  /// Bouton secondaire (transparent, bordure blanche, texte blanc)
  secondary,

  /// Bouton outline (transparent, bordure colorée, texte coloré)
  outline,
}

/// Tailles disponibles pour le bouton
enum ButtonSize { small, medium, large }
