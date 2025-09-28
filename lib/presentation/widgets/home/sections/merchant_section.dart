import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/design_tokens.dart';
import '../../../providers/merchants_provider.dart';
import '../../../screens/all_merchants_screen.dart';
import '../../merchant_card.dart';

/// Section affichant la liste des marchands partenaires
class MerchantSection extends ConsumerWidget {
  const MerchantSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.scaleMD_LG_XL_XXL,
            context.scaleXS_SM_MD_LG,
            context.scaleMD_LG_XL_XXL,
            context.scaleMD_LG_XL_XXL,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nos partenaires',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                    ),
                  ),
                  Text(
                    'Découvrez nos commerçants engagés',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AllMerchantsScreen(),
                      ),
                    ),
                  );
                },
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),

        // Liste horizontale de cartes de marchands
        SizedBox(
          height: EcoPlatesDesignTokens.layout.merchantCardHeight(context),
          child: merchantsAsync.when(
            data: (merchants) {
              if (merchants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: EcoPlatesDesignTokens.size.modalIcon(context),
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(
                              alpha: EcoPlatesDesignTokens.opacity.subtle,
                            ),
                      ),
                      SizedBox(height: context.scaleXS_SM_MD_LG),
                      Text(
                        'Aucun marchand disponible',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
                          fontSize: EcoPlatesDesignTokens.typography.text(
                            context,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaleMD_LG_XL_XXL,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: merchants.length,
                itemBuilder: (context, index) {
                  final merchant = merchants[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXS_SM_MD_LG,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: MerchantCard(
                        merchant: merchant,
                        onTap: () {
                          // TODO: Navigation vers le détail du marchand
                          // Navigator.of(context).push(
                          //   MaterialPageRoute<void>(
                          //     builder: (context) => MerchantDetailScreen(merchant: merchant),
                          //   ),
                          // );

                          // Pour l'instant, afficher un message temporaire
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Détails de ${merchant.name}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: EcoPlatesDesignTokens.size.modalIcon(context),
                    color: EcoPlatesDesignTokens.errorColorValidation(context),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: EcoPlatesDesignTokens.errorColorValidation(
                        context,
                      ),
                      fontSize: EcoPlatesDesignTokens.typography.text(context),
                    ),
                  ),
                  SizedBox(height: context.scaleXS_SM_MD_LG),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(merchantsProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: context.scaleMD_LG_XL_XXL),
      ],
    );
  }
}
