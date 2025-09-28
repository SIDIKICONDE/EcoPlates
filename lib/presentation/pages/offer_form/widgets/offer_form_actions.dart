import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des actions et informations avancées du formulaire d'offre
class OfferFormActions extends ConsumerWidget {
  const OfferFormActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Utilisation des tokens de design
    final sectionSpacing = EcoPlatesDesignTokens.spacing.sectionSpacing(
      context,
    );
    final statusIndicatorSize = EcoPlatesDesignTokens.size.indicator(context);
    final maxFieldWidth = EcoPlatesDesignTokens.layout.formFieldMaxWidth(
      context,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxFieldWidth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statut de l'offre
          InkWell(
            onTap: () => _showStatusModal(context, ref, formState.status),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Statut de l'offre",
                labelStyle: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.label(context),
                ),
                prefixIcon: Icon(
                  Icons.toggle_on,
                  size: EcoPlatesDesignTokens.size.icon(context),
                ),
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  size: EcoPlatesDesignTokens.size.icon(context),
                ),
                contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                  context,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: statusIndicatorSize,
                    height: statusIndicatorSize,
                    margin: EdgeInsets.only(
                      right: EcoPlatesDesignTokens.spacing.interfaceGap(
                        context,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(context, formState.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    _getStatusLabel(formState.status),
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.text(context),
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: sectionSpacing),

          // Temps de préparation
          TextFormField(
            initialValue: formState.preparationTime > 0
                ? formState.preparationTime.toString()
                : '',
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
            ),
            decoration: InputDecoration(
              labelText: 'Temps de préparation (minutes)',
              labelStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.label(context),
              ),
              hintText: 'Ex: 30',
              hintStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
              ),
              prefixIcon: Icon(
                Icons.timer,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              border: const OutlineInputBorder(),
              helperText: 'Temps nécessaire pour préparer la commande',
              helperStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                  context,
                ),
              ),
              contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                context,
              ),
            ),
            onChanged: (value) {
              final time = int.tryParse(value) ?? 30;
              ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .updatePreparationTime(time);
            },
          ),

          SizedBox(height: sectionSpacing),

          // Économie CO2
          TextFormField(
            initialValue: formState.co2Saved > 0
                ? formState.co2Saved.toString()
                : '',
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
            ),
            decoration: InputDecoration(
              labelText: 'Économie CO2 (grammes)',
              labelStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.label(context),
              ),
              hintText: 'Ex: 500',
              hintStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
              ),
              prefixIcon: Icon(
                Icons.eco,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              border: const OutlineInputBorder(),
              helperText: 'Quantité de CO2 économisée par commande',
              helperStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                  context,
                ),
              ),
              contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                context,
              ),
            ),
            onChanged: (value) {
              final co2 = int.tryParse(value) ?? 500;
              ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .updateCo2Saved(co2);
            },
          ),

          SizedBox(height: sectionSpacing),

          // Tags
          TextFormField(
            initialValue: formState.tags.join(', '),
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.text(context),
            ),
            decoration: InputDecoration(
              labelText: 'Tags (séparés par des virgules)',
              labelStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.label(context),
              ),
              hintText: 'Ex: frais, local, bio',
              hintStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.hint(context),
              ),
              prefixIcon: Icon(
                Icons.tag,
                size: EcoPlatesDesignTokens.size.icon(context),
              ),
              border: const OutlineInputBorder(),
              helperText:
                  'Mots-clés pour aider les clients à trouver votre offre',
              helperStyle: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                  context,
                ),
              ),
              contentPadding: EcoPlatesDesignTokens.spacing.contentPadding(
                context,
              ),
            ),
            onChanged: (value) {
              final tags = value
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              ref
                  .read<OfferFormNotifier>(offerFormProvider.notifier)
                  .updateTags(tags);
            },
          ),
        ],
      ),
    );
  }

  void _showStatusModal(
    BuildContext context,
    WidgetRef ref,
    OfferStatus currentStatus,
  ) {
    // Utilisation des tokens de design pour la modal
    final indicatorSize = EcoPlatesDesignTokens.size.indicator(context);
    final iconSize = EcoPlatesDesignTokens.size.modalIcon(context);
    final titleFontSize = EcoPlatesDesignTokens.typography.modalTitle(context);
    final subtitleFontSize = EcoPlatesDesignTokens.typography.modalSubtitle(
      context,
    );

    final contentPadding = EdgeInsets.symmetric(
      horizontal: EcoPlatesDesignTokens.spacing.interfaceGap(context),
      vertical: EcoPlatesDesignTokens.spacing.smallGap(context),
    );

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: EcoPlatesDesignTokens.layout.modalMaxWidth(context),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: OfferStatus.values.map((status) {
                final isSelected = status == currentStatus;
                return ListTile(
                  contentPadding: contentPadding,
                  leading: Container(
                    width: indicatorSize,
                    height: indicatorSize,
                    decoration: BoxDecoration(
                      color: _getStatusColor(context, status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    _getStatusLabel(status),
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: EcoPlatesDesignTokens.typography.medium,
                    ),
                  ),
                  subtitle: Text(
                    _getStatusDescription(status),
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      height: EcoPlatesDesignTokens.layout.textLineHeight,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          size: iconSize,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    ref
                        .read<OfferFormNotifier>(offerFormProvider.notifier)
                        .updateStatus(status);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(BuildContext context, OfferStatus status) {
    final theme = Theme.of(context);
    return switch (status) {
      OfferStatus.draft => theme.colorScheme.surfaceContainerHighest,
      OfferStatus.available => theme.colorScheme.primary,
      OfferStatus.reserved => theme.colorScheme.secondary,
      OfferStatus.collected => theme.colorScheme.tertiary,
      OfferStatus.expired => theme.colorScheme.error,
      OfferStatus.cancelled => theme.colorScheme.error,
    };
  }

  String _getStatusLabel(OfferStatus status) {
    return switch (status) {
      OfferStatus.draft => 'Brouillon',
      OfferStatus.available => 'Disponible',
      OfferStatus.reserved => 'Réservée',
      OfferStatus.collected => 'Collectée',
      OfferStatus.expired => 'Expirée',
      OfferStatus.cancelled => 'Annulée',
    };
  }

  String _getStatusDescription(OfferStatus status) {
    return switch (status) {
      OfferStatus.draft =>
        'Offre en cours de création, non visible par les clients',
      OfferStatus.available => 'Offre active et visible par tous les clients',
      OfferStatus.reserved =>
        'Offre réservée par un client, en attente de collecte',
      OfferStatus.collected => 'Offre récupérée par le client',
      OfferStatus.expired => 'Offre expirée sans avoir été collectée',
      OfferStatus.cancelled => 'Offre annulée par le commerçant',
    };
  }
}
