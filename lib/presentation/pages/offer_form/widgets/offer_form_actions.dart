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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Statut de l'offre
        InkWell(
          onTap: () => _showStatusModal(context, ref, formState.status),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: "Statut de l'offre",
              prefixIcon: Icon(Icons.toggle_on),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(formState.status),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  _getStatusLabel(formState.status),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Temps de préparation
        TextFormField(
          initialValue: formState.preparationTime > 0
              ? formState.preparationTime.toString()
              : '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Temps de préparation (minutes)',
            hintText: 'Ex: 30',
            prefixIcon: Icon(Icons.timer),
            border: OutlineInputBorder(),
            helperText: 'Temps nécessaire pour préparer la commande',
          ),
          onChanged: (value) {
            final time = int.tryParse(value) ?? 30;
            ref
                .read<OfferFormNotifier>(offerFormProvider.notifier)
                .updatePreparationTime(time);
          },
        ),

        const SizedBox(height: 16),

        // Économie CO2
        TextFormField(
          initialValue: formState.co2Saved > 0
              ? formState.co2Saved.toString()
              : '',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Économie CO2 (grammes)',
            hintText: 'Ex: 500',
            prefixIcon: Icon(Icons.eco),
            border: OutlineInputBorder(),
            helperText: 'Quantité de CO2 économisée par commande',
          ),
          onChanged: (value) {
            final co2 = int.tryParse(value) ?? 500;
            ref
                .read<OfferFormNotifier>(offerFormProvider.notifier)
                .updateCo2Saved(co2);
          },
        ),

        const SizedBox(height: 16),

        // Tags
        TextFormField(
          initialValue: formState.tags.join(', '),
          decoration: const InputDecoration(
            labelText: 'Tags (séparés par des virgules)',
            hintText: 'Ex: frais, local, bio',
            prefixIcon: Icon(Icons.tag),
            border: OutlineInputBorder(),
            helperText:
                'Mots-clés pour aider les clients à trouver votre offre',
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
    );
  }

  void _showStatusModal(
    BuildContext context,
    WidgetRef ref,
    OfferStatus currentStatus,
  ) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: OfferStatus.values.map((status) {
              final isSelected = status == currentStatus;
              return ListTile(
                leading: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(_getStatusLabel(status)),
                subtitle: Text(_getStatusDescription(status)),
                trailing: isSelected ? const Icon(Icons.check) : null,
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
    ));
  }

  Color _getStatusColor(OfferStatus status) {
    return switch (status) {
      OfferStatus.draft => Colors.grey,
      OfferStatus.available => Colors.green,
      OfferStatus.reserved => Colors.orange,
      OfferStatus.collected => Colors.blue,
      OfferStatus.expired => Colors.red,
      OfferStatus.cancelled => Colors.red,
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
