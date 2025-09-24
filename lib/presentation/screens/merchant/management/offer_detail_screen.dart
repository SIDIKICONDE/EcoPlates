import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/merchant/offers_provider.dart';
import '../../../providers/merchant/reservations_provider.dart';
import '../../../widgets/offer_detail/index.dart';

/// Écran de détail d'une offre anti-gaspillage
class OfferDetailScreen extends ConsumerStatefulWidget {
  final String offerId;

  const OfferDetailScreen({super.key, required this.offerId});

  @override
  ConsumerState<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends ConsumerState<OfferDetailScreen> {
  bool isReserving = false;

  void _handleBackPressed() {
    debugPrint('🔙 Bouton retour pressé - tentative de navigation');
    debugPrint('🔙 Context mounted: ${context.mounted}');
    debugPrint('🔙 Can pop: ${context.canPop()}');
    
    try {
      if (context.mounted) {
        if (context.canPop()) {
          debugPrint('🔙 Utilisation de context.pop()');
          context.pop();
        } else {
          debugPrint('🔙 Impossible de pop - navigation vers home');
          context.go('/');
        }
      } else {
        debugPrint('🔙 Context non monté - abandon');
      }
    } catch (e) {
      debugPrint('🔙 Erreur navigation retour: $e');
      if (context.mounted) {
        context.go('/');
      }
    }
  }

  Widget _buildContent(FoodOffer offer, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        // Image avec AppBar transparent
        OfferImageHeader(
          offer: offer,
          onBackPressed: _handleBackPressed,
        ),

        // Contenu
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informations générales (titre, description, prix)
                OfferInfoSection(offer: offer),

                const SizedBox(height: 24),

                // Détails pratiques (horaire)
                OfferDetailsSection(offer: offer),

                const SizedBox(height: 16),

                // Section adresse dédiée
                OfferAddressSection(offer: offer),

                // Allergènes seulement si présents
                if (offer.allergens.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  OfferBadgesSection(offer: offer),
                ],

                // Espacement pour le bouton flottant
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget flottant en bas pour la réservation
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offerAsync = ref.watch(offerByIdProvider(widget.offerId));

    return PopScope(
      canPop: false, // On gère manuellement le pop
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('🔙 PopScope invoked - didPop: $didPop, result: $result');
        if (!didPop) {
          // Gérer manuellement la navigation retour
          _handleBackPressed();
        }
      },
      child: Scaffold(
        body: offerAsync.when(
        data: (offer) => Stack(
          children: [
            _buildContent(offer, theme),
            // Barre de réservation en bas
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OfferReservationBar(
                offer: offer,
                isReserving: isReserving,
                onReserve: () => _reserveOffer(offer),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erreur: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(offerByIdProvider(widget.offerId)),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
      ),  // Fermeture du PopScope
    );
  }


  Future<void> _reserveOffer(FoodOffer offer) async {
    setState(() => isReserving = true);

    try {
      // Créer la réservation
      await ref.read(
        createReservationProvider((
          offerId: widget.offerId,
          quantity: 1,
        )).future,
      );

      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              offer.isFree
                  ? 'Réservation gratuite confirmée !'
                  : 'Réservation confirmée pour ${offer.discountedPrice.toStringAsFixed(2)}€',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Naviguer vers l'écran de réservations
        context.go('/reservations');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isReserving = false);
      }
    }
  }
}
