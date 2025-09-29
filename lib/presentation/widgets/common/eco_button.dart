import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bouton unifié et responsive pour EcoPlates
/// 
/// Ce widget remplace TOUS les autres systèmes de boutons
/// et utilise flutter_screenutil pour une responsivité parfaite
class EcoButton extends StatelessWidget {
  const EcoButton({
    required this.text,
    required this.onPressed,
    this.variant = EcoButtonVariant.primary,
    this.size = EcoButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.isLoading = false,
    this.enabled = true,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.borderWidth,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    super.key,
  });

  /// Texte du bouton
  final String text;

  /// Action au tap
  final VoidCallback? onPressed;

  /// Variant du bouton
  final EcoButtonVariant variant;

  /// Taille du bouton
  final EcoButtonSize size;

  /// Icône optionnelle
  final IconData? icon;

  /// Position de l'icône
  final IconPosition iconPosition;

  /// Prend toute la largeur disponible
  final bool isFullWidth;

  /// Largeur custom (override isFullWidth)
  final double? width;

  /// Hauteur custom (override size)
  final double? height;

  /// Affiche un loader
  final bool isLoading;

  /// Active/désactive le bouton
  final bool enabled;

  /// Border radius custom
  final double? borderRadius;

  /// Padding custom
  final EdgeInsetsGeometry? padding;

  /// Elevation custom (pour elevated variants)
  final double? elevation;

  /// Border width custom (pour outlined variants)
  final double? borderWidth;

  /// Font size custom
  final double? fontSize;

  /// Font weight custom
  final FontWeight? fontWeight;

  /// Couleurs custom
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Récupérer les dimensions selon la taille
    final dimensions = _getButtonDimensions();
    final effectiveHeight = height ?? dimensions.height;
    final effectiveWidth = width ?? (isFullWidth ? double.infinity : null);

    // Récupérer les couleurs selon le variant
    final colors = _getButtonColors(theme, isDark);
    final effectiveBackgroundColor = backgroundColor ?? colors.backgroundColor;
    final effectiveForegroundColor = foregroundColor ?? colors.foregroundColor;
    final effectiveBorderColor = borderColor ?? colors.borderColor;

    // Style du texte responsive
    final textStyle = TextStyle(
      fontSize: fontSize ?? dimensions.fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.5,
    );

    // Border radius responsive
    final effectiveBorderRadius = borderRadius ?? dimensions.borderRadius;

    // Padding responsive
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: dimensions.horizontalPadding,
      vertical: dimensions.verticalPadding,
    );

    // Contenu du bouton
    Widget buttonContent = _buildButtonContent(
      effectiveForegroundColor,
      textStyle,
      dimensions.iconSize,
      dimensions.spacing,
    );

    // Widget final selon le variant
    Widget button;

    switch (variant) {
      case EcoButtonVariant.primary:
      case EcoButtonVariant.secondary:
      case EcoButtonVariant.urgent:
        button = ElevatedButton(
          onPressed: (enabled && !isLoading) ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveForegroundColor,
            disabledBackgroundColor: isDark 
                ? Colors.grey[800] 
                : Colors.grey[300],
            elevation: elevation ?? 2.0,
            shadowColor: Colors.black.withOpacity(0.2),
            padding: effectivePadding,
            minimumSize: Size(
              effectiveWidth ?? 0,
              effectiveHeight,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return effectiveForegroundColor.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return effectiveForegroundColor.withOpacity(0.05);
              }
              return null;
            }),
          ),
          child: buttonContent,
        );
        break;

      case EcoButtonVariant.outline:
      case EcoButtonVariant.ghost:
        button = OutlinedButton(
          onPressed: (enabled && !isLoading) ? onPressed : null,
          style: OutlinedButton.styleFrom(
            backgroundColor: variant == EcoButtonVariant.ghost
                ? Colors.transparent
                : effectiveBackgroundColor,
            foregroundColor: effectiveForegroundColor,
            side: BorderSide(
              color: effectiveBorderColor ?? effectiveForegroundColor,
              width: borderWidth ?? 1.5.w,
            ),
            padding: effectivePadding,
            minimumSize: Size(
              effectiveWidth ?? 0,
              effectiveHeight,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return effectiveForegroundColor.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return effectiveForegroundColor.withOpacity(0.05);
              }
              return null;
            }),
          ),
          child: buttonContent,
        );
        break;

      case EcoButtonVariant.text:
        button = TextButton(
          onPressed: (enabled && !isLoading) ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: effectiveForegroundColor,
            padding: effectivePadding,
            minimumSize: Size(
              effectiveWidth ?? 0,
              effectiveHeight,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return effectiveForegroundColor.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return effectiveForegroundColor.withOpacity(0.05);
              }
              return null;
            }),
          ),
          child: buttonContent,
        );
        break;

      case EcoButtonVariant.pill:
        button = ElevatedButton(
          onPressed: (enabled && !isLoading) ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveBackgroundColor,
            foregroundColor: effectiveForegroundColor,
            disabledBackgroundColor: isDark 
                ? Colors.grey[800] 
                : Colors.grey[300],
            elevation: elevation ?? 2.0,
            shadowColor: Colors.black.withOpacity(0.2),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding * 1.5,
              vertical: dimensions.verticalPadding * 0.8,
            ),
            minimumSize: Size(
              effectiveWidth ?? 0,
              effectiveHeight * 0.85,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          child: buttonContent,
        );
        break;
    }

    // Si width custom ou fullWidth, wrapper dans un SizedBox
    if (effectiveWidth != null) {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: button,
      );
    }

    return button;
  }

  /// Construit le contenu du bouton
  Widget _buildButtonContent(
    Color foregroundColor,
    TextStyle textStyle,
    double iconSize,
    double spacing,
  ) {
    if (isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    // Texte seul
    if (icon == null) {
      return Text(text, style: textStyle);
    }

    // Icône + texte
    final iconWidget = Icon(
      icon,
      size: iconSize,
      color: foregroundColor,
    );

    final spacer = SizedBox(width: spacing);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [iconWidget, spacer, Flexible(child: Text(text, style: textStyle))]
          : [Flexible(child: Text(text, style: textStyle)), spacer, iconWidget],
    );
  }

  /// Retourne les dimensions selon la taille
  _ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case EcoButtonSize.small:
        return _ButtonDimensions(
          height: 36.h,
          fontSize: 12.sp,
          horizontalPadding: 12.w,
          verticalPadding: 8.h,
          iconSize: 16.sp,
          spacing: 6.w,
          borderRadius: 8.r,
        );

      case EcoButtonSize.medium:
        return _ButtonDimensions(
          height: 44.h,
          fontSize: 14.sp,
          horizontalPadding: 16.w,
          verticalPadding: 10.h,
          iconSize: 20.sp,
          spacing: 8.w,
          borderRadius: 12.r,
        );

      case EcoButtonSize.large:
        return _ButtonDimensions(
          height: 52.h,
          fontSize: 16.sp,
          horizontalPadding: 20.w,
          verticalPadding: 12.h,
          iconSize: 24.sp,
          spacing: 10.w,
          borderRadius: 14.r,
        );
    }
  }

  /// Retourne les couleurs selon le variant
  _ButtonColors _getButtonColors(ThemeData theme, bool isDark) {
    switch (variant) {
      case EcoButtonVariant.primary:
        return _ButtonColors(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          borderColor: theme.primaryColor,
        );

      case EcoButtonVariant.secondary:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: Colors.white,
          borderColor: theme.colorScheme.secondary,
        );

      case EcoButtonVariant.outline:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark ? Colors.white : theme.primaryColor,
          borderColor: isDark ? Colors.white : theme.primaryColor,
        );

      case EcoButtonVariant.ghost:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: isDark ? Colors.white70 : Colors.black87,
          borderColor: isDark ? Colors.white24 : Colors.black12,
        );

      case EcoButtonVariant.text:
        return _ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          borderColor: Colors.transparent,
        );

      case EcoButtonVariant.urgent:
        return _ButtonColors(
          backgroundColor: theme.colorScheme.error,
          foregroundColor: Colors.white,
          borderColor: theme.colorScheme.error,
        );

      case EcoButtonVariant.pill:
        return _ButtonColors(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          borderColor: theme.primaryColor,
        );
    }
  }
}

/// Variants disponibles pour EcoButton
enum EcoButtonVariant {
  /// Bouton principal (fond coloré)
  primary,

  /// Bouton secondaire (fond secondaire)
  secondary,

  /// Bouton avec bordure uniquement
  outline,

  /// Bouton transparent avec bordure subtile
  ghost,

  /// Bouton texte seul
  text,

  /// Bouton d'urgence (rouge)
  urgent,

  /// Bouton arrondi (pill shape)
  pill,
}

/// Tailles disponibles pour EcoButton
enum EcoButtonSize {
  small,
  medium,
  large,
}

/// Position de l'icône
enum IconPosition {
  left,
  right,
}

/// Classe interne pour les dimensions
class _ButtonDimensions {
  final double height;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double spacing;
  final double borderRadius;

  const _ButtonDimensions({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
  });
}

/// Classe interne pour les couleurs
class _ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const _ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });
}

/// Extension pour faciliter l'usage
extension EcoButtonHelpers on EcoButton {
  /// Crée un bouton primary rapidement
  static EcoButton primary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    EcoButtonSize size = EcoButtonSize.medium,
  }) {
    return EcoButton(
      text: text,
      onPressed: onPressed,
      variant: EcoButtonVariant.primary,
      icon: icon,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      size: size,
    );
  }

  /// Crée un bouton secondary rapidement
  static EcoButton secondary({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    EcoButtonSize size = EcoButtonSize.medium,
  }) {
    return EcoButton(
      text: text,
      onPressed: onPressed,
      variant: EcoButtonVariant.secondary,
      icon: icon,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      size: size,
    );
  }

  /// Crée un bouton outline rapidement
  static EcoButton outline({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    EcoButtonSize size = EcoButtonSize.medium,
  }) {
    return EcoButton(
      text: text,
      onPressed: onPressed,
      variant: EcoButtonVariant.outline,
      icon: icon,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      size: size,
    );
  }

  /// Crée un bouton urgent rapidement
  static EcoButton urgent({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
    EcoButtonSize size = EcoButtonSize.medium,
  }) {
    return EcoButton(
      text: text,
      onPressed: onPressed,
      variant: EcoButtonVariant.urgent,
      icon: icon,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
      size: size,
    );
  }
}