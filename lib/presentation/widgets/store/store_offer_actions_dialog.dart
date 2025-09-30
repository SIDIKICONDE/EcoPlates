import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes/route_constants.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/store_offers_provider.dart';
import 'offer_promotion_manager.dart';

/// Classe utilitaire pour afficher les dialogues d'actions des offres
class StoreOfferActionsDialog {
  /// Affiche le dialogue des actions pour une offre
  static void show(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => _OfferActionsSheet(offer: offer),
      ),
    );
  }
}

/// Bottom sheet pour les actions d'une offre
class _OfferActionsSheet extends ConsumerWidget {
  const _OfferActionsSheet({required this.offer});

  final FoodOffer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Stock: ${offer.quantity} • Prix: ${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: DeepColorTokens.neutral600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              offer.isAvailable ? Icons.visibility_off : Icons.visibility,
              color: offer.isAvailable
                  ? DeepColorTokens.error
                  : DeepColorTokens.primary,
            ),
            title: Text(offer.isAvailable ? 'Désactiver' : 'Activer'),
            onTap: () {
              // Capturer la référence avant la navigation
              final storeOffersNotifier = ref.read(
                storeOffersProvider.notifier,
              );
              final offerId = offer.id;

              Navigator.of(context).pop();
              unawaited(storeOffersNotifier.toggleOfferStatus(offerId));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modifier'),
            onTap: () {
              Navigator.of(context).pop();
              // Navigation vers le formulaire d'offres en mode édition
              context.go(RouteConstants.merchantOfferForm, extra: offer);
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_offer),
            title: const Text('Gérer la promotion'),
            onTap: () {
              Navigator.of(context).pop();
              _PromotionDialog.show(context, ref, offer);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: DeepColorTokens.error),
            title: Text(
              'Supprimer',
              style: TextStyle(color: DeepColorTokens.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              _DeleteConfirmationDialog.show(context, offer);
            },
          ),
        ],
      ),
    );
  }
}

/// Classe utilitaire pour le dialogue de promotion
class _PromotionDialog {
  static void show(BuildContext context, WidgetRef ref, FoodOffer offer) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: OfferPromotionManager(
            offer: offer,
            onPromotionUpdated: () => ref.invalidate(storeOffersProvider),
          ),
        ),
      ),
    );
  }
}

/// Classe utilitaire pour le dialogue de confirmation de suppression
class _DeleteConfirmationDialog {
  static void show(BuildContext context, FoodOffer offer) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => _DeleteConfirmationDialogWidget(offer: offer),
      ),
    );
  }
}

/// Widget Consumer pour le dialogue de confirmation de suppression
class _DeleteConfirmationDialogWidget extends ConsumerWidget {
  const _DeleteConfirmationDialogWidget({required this.offer});

  final FoodOffer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Confirmer la suppression'),
      content: Text('Voulez-vous vraiment supprimer "${offer.title}" ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Capturer les références nécessaires avant la navigation
            final navigator = Navigator.of(context);
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final storeOffersNotifier = ref.read(storeOffersProvider.notifier);
            final offerTitle = offer.title;
            final offerId = offer.id;

            // Fermer le dialogue immédiatement
            navigator.pop();

            try {
              // Supprimer l'offre de manière asynchrone
              await storeOffersNotifier.deleteOffer(offerId);

              // Afficher le snackbar de confirmation
              if (context.mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('"$offerTitle" supprimé'),
                    backgroundColor: DeepColorTokens.error,
                  ),
                );
              }
            } on Exception catch (error) {
              // En cas d'erreur, afficher un message d'erreur
              if (context.mounted) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Erreur lors de la suppression: $error'),
                    backgroundColor: DeepColorTokens.error,
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: DeepColorTokens.error,
          ),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
