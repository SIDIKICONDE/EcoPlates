import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget d'état vide réutilisable pour harmoniser les écrans
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title, super.key,
    this.subtitle,
    this.icon,
    this.iconSize = 80.0,
    this.iconColor,
    this.useCircularIconBackground = false,
    this.circularBackgroundColor,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.padding,
  });

  /// Titre principal de l'état vide
  final String title;

  /// Sous-titre optionnel (peut contenir des sauts de ligne)
  final String? subtitle;

  /// Icône affichée au dessus du titre
  final IconData? icon;

  /// Taille de l'icône
  final double iconSize;

  /// Couleur de l'icône
  final Color? iconColor;

  /// Affiche un fond circulaire derrière l'icône
  final bool useCircularIconBackground;

  /// Couleur du fond circulaire
  final Color? circularBackgroundColor;

  /// Libellé du bouton principal
  final String? primaryActionLabel;

  /// Callback du bouton principal
  final VoidCallback? onPrimaryAction;

  /// Libellé du bouton secondaire
  final String? secondaryActionLabel;

  /// Callback du bouton secondaire
  final VoidCallback? onSecondaryAction;

  /// Padding global du contenu
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              useCircularIconBackground
                  ? Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color:
                            circularBackgroundColor ??
                            DeepColorTokens.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: iconSize * 0.5,
                        color: iconColor ?? DeepColorTokens.primary,
                      ),
                    )
                  : Icon(
                      icon,
                      size: iconSize,
                      color: iconColor ?? DeepColorTokens.neutral500,
                    ),
            if (icon != null) const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: DeepColorTokens.neutral900,
              ),
            ),
            if (subtitle != null) const SizedBox(height: 8.0),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DeepColorTokens.neutral500,
                ),
              ),
            if (primaryActionLabel != null || secondaryActionLabel != null)
              const SizedBox(height: 24.0),
            if (primaryActionLabel != null || secondaryActionLabel != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (secondaryActionLabel != null)
                    OutlinedButton(
                      onPressed: onSecondaryAction,
                      child: Text(secondaryActionLabel!),
                    ),
                  if (secondaryActionLabel != null &&
                      primaryActionLabel != null)
                    const SizedBox(width: 12.0),
                  if (primaryActionLabel != null)
                    ElevatedButton(
                      onPressed: onPrimaryAction,
                      child: Text(primaryActionLabel!),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
