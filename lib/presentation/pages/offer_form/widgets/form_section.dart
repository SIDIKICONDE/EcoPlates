import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';

/// Widget amélioré pour les sections du formulaire avec icône et titre
class FormSection extends StatelessWidget {
  const FormSection({
    required this.icon,
    required this.title,
    required this.child,
    this.subtitle,
    this.isCompleted = false,
    this.isRequired = false,
    this.isCurrent = false,
    this.onSectionTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isCompleted;
  final bool isRequired;
  final bool isCurrent;
  final VoidCallback? onSectionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onSectionTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
        ),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.hover,
                )
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xl),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                  )
                : colorScheme.outline.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
            width: EcoPlatesDesignTokens.layout.buttonBorderWidth(context),
          ),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? colorScheme.primary.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.hover,
                    )
                  : colorScheme.shadow.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                    ),
              blurRadius: isCurrent
                  ? EcoPlatesDesignTokens.elevation.modal
                  : EcoPlatesDesignTokens.elevation.card,
              offset: EcoPlatesDesignTokens.elevation.standardOffset,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la section
            Container(
              padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
              decoration: BoxDecoration(
                color: isCurrent
                    ? colorScheme.primary.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.hover,
                      )
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: ui.Radius.circular(EcoPlatesDesignTokens.radius.xl),
                  topRight: ui.Radius.circular(EcoPlatesDesignTokens.radius.xl),
                ),
              ),
              child: Row(
                children: [
                  // Icône avec statut
                  Container(
                    padding: EdgeInsets.all(
                      EcoPlatesDesignTokens.spacing.smallGap(context),
                    ),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? colorScheme.primary.withValues(
                              alpha: EcoPlatesDesignTokens.opacity.hover,
                            )
                          : colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isCompleted
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                  ),
                  SizedBox(
                    width: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                  ),
                  // Titre et sous-titre
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight:
                                    EcoPlatesDesignTokens.typography.semiBold,
                                fontSize: EcoPlatesDesignTokens.typography
                                    .titleSize(context),
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (isRequired) ...[
                              SizedBox(
                                width: EcoPlatesDesignTokens.spacing.microGap(
                                  context,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: EcoPlatesDesignTokens.typography
                                      .text(context),
                                  fontWeight:
                                      EcoPlatesDesignTokens.typography.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: EcoPlatesDesignTokens.typography.hint(
                                context,
                              ),
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Indicateur de statut
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: EcoPlatesDesignTokens.size.icon(context),
                    ),
                ],
              ),
            ),
            // Contenu de la section
            Padding(
              padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
