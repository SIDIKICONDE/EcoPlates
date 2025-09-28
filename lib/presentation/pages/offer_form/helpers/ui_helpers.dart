import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/food_offer.dart';

/// Helpers pour les composants UI du formulaire d'offre
class OfferFormUiHelpers {
  /// Construit le widget d'informations système pour le mode édition
  static Widget buildSystemInfo(
    BuildContext context,
    ThemeData theme,
    FoodOffer offer,
  ) {
    return Container(
      padding: EcoPlatesDesignTokens.spacing.contentPadding(context),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.md),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: EcoPlatesDesignTokens.size.icon(context),
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(
                width: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              Text(
                'Informations système',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: EcoPlatesDesignTokens.typography.medium,
                  fontSize: EcoPlatesDesignTokens.typography.label(context),
                ),
              ),
            ],
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),
          Wrap(
            spacing: EcoPlatesDesignTokens.spacing.dialogGap(context),
            runSpacing: EcoPlatesDesignTokens.spacing.microGap(context),
            children: [
              Text(
                'ID: ${offer.id}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: EcoPlatesDesignTokens.typography.regular,
                ),
              ),
              Text(
                'Créée: ${formatDateTime(offer.createdAt)}',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: EcoPlatesDesignTokens.typography.regular,
                ),
              ),
              Text(
                'Modifiée: ${formatDateTime(offer.updatedAt)}',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: EcoPlatesDesignTokens.typography.regular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Formate une date et heure
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
