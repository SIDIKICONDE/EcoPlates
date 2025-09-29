import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.0,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.0),
              Text(
                'Informations système',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 16.0,
            runSpacing: 8.0,
            children: [
              Text(
                'ID: ${offer.id}',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Créé: ${_formatDateTime(offer.createdAt)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Modifié: ${_formatDateTime(offer.updatedAt)}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Formate une date pour l'affichage
  static String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}
