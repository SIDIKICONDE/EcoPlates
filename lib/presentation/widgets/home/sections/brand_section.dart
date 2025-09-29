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
          padding: EdgeInsets.fromLTRB(
            16.0,
            0,
            16.0,
            8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grandes Enseignes',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigation vers toutes les marques
                  unawaited(context.pushNamed(RouteConstants.allBrandsName));
                },
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Slider horizontal de cartes
        SizedBox(
          height: 120.0,
          child: brandsAsync.when(
            data: (brands) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
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
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
