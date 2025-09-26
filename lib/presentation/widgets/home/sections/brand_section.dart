import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes/route_constants.dart';
import '../../../providers/brand_provider.dart';
import '../../brand_card.dart';

/// Section des grandes marques/enseignes
class BrandSection extends ConsumerWidget {
  const BrandSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupérer les marques depuis le provider
    final brandsAsync = ref.watch(brandsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grandes Enseignes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigation vers toutes les marques
                  unawaited(context.pushNamed(RouteConstants.allBrandsName));
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Slider horizontal de cartes
        SizedBox(
          height: 100, // Hauteur ajustée pour les BrandCard
          child: brandsAsync.when(
            data: (brands) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SizedBox(
                    width: 320, // Largeur fixe pour les cartes horizontales
                    child: BrandCard(
                      brand: brand,
                      onTap: () {
                        // Navigation vers la page de la marque
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Marque sélectionnée: ${brand.name}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Erreur: $error',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
