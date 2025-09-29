import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offer_form_provider.dart';

/// Section des actions et informations avancées du formulaire d'offre
class OfferFormActions extends ConsumerWidget {
  const OfferFormActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    // Utilisation des valeurs en dur
    const sectionSpacing = 16.0;
    const statusIndicatorSize = 12.0;
    const maxFieldWidth = 600.0;

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
                labelStyle: TextStyle(fontSize: 16.0),
                prefixIcon: Icon(Icons.toggle_on, size: 24.0),
                border: const OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down, size: 24.0),
                contentPadding: EdgeInsets.all(16.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: statusIndicatorSize,
                    height: statusIndicatorSize,
                    margin: EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      color: _getStatusColor(context, formState.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    _getStatusLabel(formState.status),
                    style: TextStyle(
                      fontSize: 16.0,
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
            style: TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              labelText: 'Temps de préparation (minutes)',
              labelStyle: TextStyle(fontSize: 16.0),
              hintText: 'Ex: 30',
              hintStyle: TextStyle(fontSize: 14.0),
              prefixIcon: Icon(Icons.timer, size: 24.0),
              border: const OutlineInputBorder(),
              helperText: 'Temps nécessaire pour préparer la commande',
              helperStyle: TextStyle(fontSize: 12.0),
              contentPadding: EdgeInsets.all(16.0),
            ),
            onChanged: (value) {
              final time = int.tryParse(value) ?? 30;
              ref.read(offerFormProvider.notifier).updatePreparationTime(time);
            },
          ),

          SizedBox(height: sectionSpacing),

          // Économie CO2
          TextFormField(
            initialValue: formState.co2Saved > 0
                ? formState.co2Saved.toString()
                : '',
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              labelText: 'Économie CO2 (grammes)',
              labelStyle: TextStyle(fontSize: 16.0),
              hintText: 'Ex: 500',
              hintStyle: TextStyle(fontSize: 14.0),
              prefixIcon: Icon(Icons.eco, size: 24.0),
              border: const OutlineInputBorder(),
              helperText: 'Quantité de CO2 économisée par commande',
              helperStyle: TextStyle(fontSize: 12.0),
              contentPadding: EdgeInsets.all(16.0),
            ),
            onChanged: (value) {
              final co2 = int.tryParse(value) ?? 500;
              ref.read(offerFormProvider.notifier).updateCo2Saved(co2);
            },
          ),

          SizedBox(height: sectionSpacing),

          // Tags
          TextFormField(
            initialValue: formState.tags.join(', '),
            style: TextStyle(fontSize: 16.0),
            decoration: InputDecoration(
              labelText: 'Tags (séparés par des virgules)',
              labelStyle: TextStyle(fontSize: 16.0),
              hintText: 'Ex: frais, local, bio',
              hintStyle: TextStyle(fontSize: 14.0),
              prefixIcon: Icon(Icons.tag, size: 24.0),
              border: const OutlineInputBorder(),
              helperText:
                  'Mots-clés pour aider les clients à trouver votre offre',
              helperStyle: TextStyle(fontSize: 12.0),
              contentPadding: EdgeInsets.all(16.0),
            ),
            onChanged: (value) {
              final tags = value
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              ref.read(offerFormProvider.notifier).updateTags(tags);
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
    // Utilisation de valeurs en dur pour la modal
    const indicatorSize = 12.0;
    const titleFontSize = 16.0;
    const subtitleFontSize = 14.0;

    final contentPadding = EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    );

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxWidth: 600.0),
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _getStatusDescription(status),
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      height: 1.3,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    ref.read(offerFormProvider.notifier).updateStatus(status);
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
