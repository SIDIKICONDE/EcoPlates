import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/food_offer.dart';

/// Section dédiée à l'adresse de récupération
class OfferAddressSection extends StatelessWidget {
  const OfferAddressSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adresse principale avec icône simple
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                size: 20.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.location.address,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${offer.location.postalCode} ${offer.location.city}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    GestureDetector(
                      onTap: () {
                        // Navigation vers le profil du marchand
                        final merchantId = offer.merchantId;
                        debugPrint(
                          '🔗 Navigation vers profil marchand: $merchantId',
                        );

                        try {
                          unawaited(
                            context.push('/merchant-profile/$merchantId'),
                          );
                        } on Exception catch (e) {
                          debugPrint('❌ Erreur navigation: $e');
                          // Fallback: afficher un message ou naviguer vers une page d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                "Impossible d'ouvrir le profil du marchand",
                              ),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Plus d'informations sur le marchand",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.primary,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
