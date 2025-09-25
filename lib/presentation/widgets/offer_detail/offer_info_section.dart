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
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // Description
        const Text(
          'Que contient cette offre ?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          offer.description,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ],
    );
  }
}
