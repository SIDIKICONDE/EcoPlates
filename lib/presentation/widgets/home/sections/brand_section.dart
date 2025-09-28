import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/design_tokens.dart';
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
            context.scaleMD_LG_XL_XXL,
            0,
            context.scaleMD_LG_XL_XXL,
            context.scaleXXS_XS_SM_MD,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grandes Enseignes',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
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
          height:
              EcoPlatesDesignTokens.layout.merchantCardHeight(context) * 0.5,
          child: brandsAsync.when(
            data: (brands) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleMD_LG_XL_XXL,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
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
                  color: EcoPlatesDesignTokens.colors.snackbarError,
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: context.scaleMD_LG_XL_XXL,
        ),
      ],
    );
  }
}
