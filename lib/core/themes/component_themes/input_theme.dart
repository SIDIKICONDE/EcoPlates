import 'package:flutter/material.dart';

import '../tokens/deep_color_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/typography_tokens.dart';

/// Thème des champs de saisie pour EcoPlates
class EcoInputTheme {
  EcoInputTheme._();

  // ===== INPUT DECORATION THEME =====
  static InputDecorationTheme inputDecorationTheme({required bool isDark}) {
    final fillColor = isDark
        ? DeepColorTokens.neutral800
        : DeepColorTokens.neutral100;
    final borderColor = isDark
        ? DeepColorTokens.neutral600
        : DeepColorTokens.neutral300;
    const focusColor = DeepColorTokens.primary;
    const errorColor = DeepColorTokens.error;

    return InputDecorationTheme(
      // Remplissage
      filled: true,
      fillColor: fillColor,

      // Style de texte
      labelStyle: EcoTypography.bodyMediumLight.copyWith(
        color: isDark ? DeepColorTokens.neutral300 : DeepColorTokens.neutral600,
      ),
      hintStyle: EcoTypography.bodyMediumLight.copyWith(
        color: isDark ? DeepColorTokens.neutral500 : DeepColorTokens.neutral400,
      ),

      // Padding intérieur
      contentPadding: EcoSpacing.inputPadding,

      // Bordure par défaut
      border: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),

      // Bordure activée (non focalisée)
      enabledBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),

      // Bordure focalisée
      focusedBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: focusColor),
      ),

      // Bordure d'erreur
      errorBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: errorColor),
      ),

      // Bordure d'erreur focalisée
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: errorColor),
      ),

      // Bordure désactivée
      disabledBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(
          color: isDark
              ? DeepColorTokens.neutral700
              : DeepColorTokens.neutral200,
        ),
      ),

      // Style du texte d'erreur
      errorStyle: EcoTypography.bodySmallLight.copyWith(
        color: errorColor,
      ),

      // Style du texte d'aide
      helperStyle: EcoTypography.bodySmallLight.copyWith(
        color: isDark ? DeepColorTokens.neutral400 : DeepColorTokens.neutral500,
      ),

      // Style du compteur de caractères
      counterStyle: EcoTypography.bodySmallLight.copyWith(
        color: isDark ? DeepColorTokens.neutral400 : DeepColorTokens.neutral500,
      ),

      // Contraintes des icônes
      prefixIconConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      suffixIconConstraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),

      // Couleur des icônes
      prefixIconColor: isDark
          ? DeepColorTokens.neutral400
          : DeepColorTokens.neutral500,
      suffixIconColor: isDark
          ? DeepColorTokens.neutral400
          : DeepColorTokens.neutral500,
    );
  }

  // ===== STYLES D'INPUT PRÉDÉFINIS =====

  /// Input standard EcoPlates
  static InputDecoration standardDecoration({
    String? labelText,
    String? hintText,
    String? helperText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDark = false,
  }) {
    final fillColor = isDark
        ? DeepColorTokens.neutral800
        : DeepColorTokens.neutral100;
    final borderColor = isDark
        ? DeepColorTokens.neutral600
        : DeepColorTokens.neutral300;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: DeepColorTokens.primary),
      ),
      contentPadding: EcoSpacing.inputPadding,
    );
  }

  /// Input de recherche avec icône
  static InputDecoration searchDecoration({
    String hintText = 'Rechercher...',
    bool isDark = false,
  }) {
    final fillColor = isDark
        ? DeepColorTokens.neutral800
        : DeepColorTokens.neutral50;

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(
        Icons.search,
        color: isDark ? DeepColorTokens.neutral400 : DeepColorTokens.neutral500,
      ),
      filled: true,
      fillColor: fillColor,
      border: const OutlineInputBorder(
        borderRadius: EcoRadius.pillButtonRadius, // Complètement arrondi
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.pillButtonRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.pillButtonRadius,
        borderSide: BorderSide(color: DeepColorTokens.primary),
      ),
      contentPadding: EcoSpacing.asymmetric(
        horizontal: EcoSpacing.lg,
        vertical: EcoSpacing.md,
      ),
    );
  }

  /// Input minimal sans bordure
  static InputDecoration minimalDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDark = false,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: DeepColorTokens.neutral300),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: isDark
              ? DeepColorTokens.neutral600
              : DeepColorTokens.neutral300,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: DeepColorTokens.primary),
      ),
      contentPadding: EcoSpacing.asymmetric(vertical: EcoSpacing.md),
    );
  }

  /// Input avec bordure colorée (pour catégories/états)
  static InputDecoration coloredBorderDecoration({
    required Color borderColor,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDark = false,
  }) {
    final fillColor = isDark
        ? DeepColorTokens.neutral800
        : DeepColorTokens.neutral50;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: EcoSpacing.inputPadding,
    );
  }

  /// Input pour formulaire avec style premium
  static InputDecoration premiumDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDark = false,
  }) {
    final fillColor = isDark
        ? DeepColorTokens.neutral800.withValues(alpha: 0.5)
        : DeepColorTokens.neutral0;

    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(
          color: isDark
              ? DeepColorTokens.neutral600
              : DeepColorTokens.neutral200,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(
          color: isDark
              ? DeepColorTokens.neutral600
              : DeepColorTokens.neutral200,
          width: 1.5,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: EcoRadius.inputRadius,
        borderSide: BorderSide(color: DeepColorTokens.primary),
      ),
      contentPadding: EcoSpacing.asymmetric(
        horizontal: EcoSpacing.xl,
        vertical: EcoSpacing.lg,
      ),
    );
  }

  // ===== WIDGETS D'INPUT PERSONNALISÉS =====

  /// TextField avec label flottant amélioré
  static Widget enhancedTextField({
    required String label,
    String? hint,
    TextEditingController? controller,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    bool isDark = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: EcoTypography.labelMediumLight.copyWith(
            color: isDark
                ? DeepColorTokens.neutral300
                : DeepColorTokens.neutral700,
            fontWeight: EcoTypography.medium,
          ),
        ),
        const SizedBox(height: EcoSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          style: EcoTypography.bodyLargeLight.copyWith(
            color: isDark
                ? DeepColorTokens.neutral100
                : DeepColorTokens.neutral800,
          ),
          decoration: standardDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  /// Champ de recherche avec suggestions
  static Widget searchField({
    TextEditingController? controller,
    String hintText = 'Rechercher...',
    void Function(String)? onChanged,
    VoidCallback? onClear,
    bool isDark = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      style: EcoTypography.bodyLargeLight.copyWith(
        color: isDark ? DeepColorTokens.neutral100 : DeepColorTokens.neutral800,
      ),
      decoration:
          searchDecoration(
            hintText: hintText,
            isDark: isDark,
          ).copyWith(
            suffixIcon: controller?.text.isNotEmpty ?? false
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: onClear,
                  )
                : null,
          ),
    );
  }
}
