import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_offer.dart';
import '../providers/offer_reservation_provider.dart';
import 'common/offer_detail_modal.dart';

/// Modal de détail pour les offres urgentes
class UrgentOfferDetailModal extends ConsumerWidget {
  const UrgentOfferDetailModal({
    super.key,
    required this.offer,
    required this.animationController,
    required this.pulseAnimation,
  });

  final FoodOffer offer;
  final AnimationController animationController;
  final Animation<double> pulseAnimation;

  static void show(
    BuildContext context,
    FoodOffer offer,
    AnimationController animationController,
    Animation<double> pulseAnimation,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => UrgentOfferDetailModal(
          offer: offer,
          animationController: animationController,
          pulseAnimation: pulseAnimation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());

    return OfferDetailModal(
      offer: offer,
      height: 0.9,
      showUrgentHeader: true,
      urgentHeaderText: 'URGENT - ${remainingTime.inMinutes} minutes restantes',
      showQuantityBadge: true,
      headerGradient: LinearGradient(
        colors: remainingTime.inMinutes <= 30
            ? [
                Theme.of(context).colorScheme.errorContainer,
                Theme.of(context).colorScheme.tertiaryContainer,
              ]
            : [
                Theme.of(context).colorScheme.secondaryContainer,
                Theme.of(context).colorScheme.primaryContainer,
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      reservationButtonText: 'Sauver maintenant',
      reservationButtonColor: Theme.of(context).colorScheme.error,
      reservationButtonIcon: Icons.flash_on,
      onReserve: () async {
        try {
          await ref
              .read(offerReservationProvider.notifier)
              .reserve(offer: offer);
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade700,
                content: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bravo ! Vous avez sauvé "${offer.title}"',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } on Exception catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade700,
                content: Text('Réservation impossible: $e'),
              ),
            );
          }
        }
      },
    );
  }
}
