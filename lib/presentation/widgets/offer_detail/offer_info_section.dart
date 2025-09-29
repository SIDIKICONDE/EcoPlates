import 'package:flutter/material.dart';

import '../../../domain/entities/food_offer.dart';

/// Section d'informations essentielles pour l'acheteur
class OfferInfoSection extends StatelessWidget {
  const OfferInfoSection({required this.offer, super.key});
  final FoodOffer offer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de l'offre
        Text(
          offer.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),

        // Description
        const Text(
          'Que contient cette offre ?',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          offer.description,
          style: const TextStyle(
            fontSize: 14.0,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
