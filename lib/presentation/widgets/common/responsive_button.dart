import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

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
    final isVerySmallScreen = screenHeight < 480.0;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    // Utilisation des tokens de design pour la hauteur RESPONSIVE
    final baseButtonHeight = 48.h;
    final buttonHeight = isLandscape
        ? baseButtonHeight - 4.h
        : baseButtonHeight;

    final borderRadius = 12.r;

    // Définition de la largeur
    double? buttonWidth;
    if (customWidth != null) {
      buttonWidth = customWidth;
    } else if (isFullWidth) {
      buttonWidth = screenWidth * 0.9;
    }

    // Contrainte de largeur max automatique sur grand écran si non précisé
    final adaptiveMaxWidth = maxWidth ?? 400.w;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: adaptiveMaxWidth,
        minHeight: 48.h,
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
          foregroundColor: DeepColorTokens.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 2.0,
          shadowColor: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return DeepColorTokens.primary.withValues(
                  alpha: 0.08,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return DeepColorTokens.primary.withValues(
                  alpha: 0.12,
                );
              }
              return null;
            },
          ),
        );

      case ButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          side: BorderSide(
            color: Colors.white,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withValues(
                  alpha: 0.08,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withValues(
                  alpha: 0.12,
                );
              }
              return null;
            },
          ),
        );

      case ButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: DeepColorTokens.primary,
          side: BorderSide(
            color: DeepColorTokens.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0.0,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return DeepColorTokens.primary.withValues(
                  alpha: 0.08,
                );
              }
              if (states.contains(WidgetState.pressed)) {
                return DeepColorTokens.primary.withValues(
                  alpha: 0.12,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final textStyle = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
    );

    if (isLoading) {
      return SizedBox(
        width: 20.w,
        height: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(context),
          ),
        ),
      );
    }

    // Si pas d'icône ou pas sur desktop, juste le texte
    if (icon == null || screenWidth < 1024.0) {
      return Text(text, style: textStyle);
    }

    // Sinon, icône + texte sur desktop
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: _getIconColor(context),
        ),
        SizedBox(width: 8.w),
        Text(text, style: textStyle),
      ],
    );
  }

  /// Retourne la couleur de l'icône selon le variant
  Color _getIconColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.outline:
        return DeepColorTokens.primary;
      case ButtonVariant.secondary:
        return DeepColorTokens.neutral0;
    }
  }

  /// Couleur de l'indicateur de chargement selon le variant
  Color _getProgressColor(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.outline:
        return DeepColorTokens.primary;
      case ButtonVariant.secondary:
        return DeepColorTokens.neutral0;
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
