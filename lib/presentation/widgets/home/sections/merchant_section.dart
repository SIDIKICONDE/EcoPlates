import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive_utils.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../providers/merchants_provider.dart';
import '../../merchant_card.dart';
import '../screens/all_merchants_screen.dart';
import 'responsive_card_config.dart';

/// Section affichant la liste des marchands partenaires
class MerchantSection extends ConsumerWidget {
  const MerchantSection({super.key});

  double _calculateCardHeight(BuildContext context) {
    // Utilise la hauteur responsive standard des cartes marchands
    return ResponsiveUtils.getMerchantCardHeight(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: EdgeInsets.fromLTRB(
            ResponsiveCardConfig.getSliderPadding(context).left,
            ResponsiveUtils.getVerticalSpacing(context) * 0.4,
            ResponsiveCardConfig.getSliderPadding(context).right,
            ResponsiveUtils.getVerticalSpacing(context),
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
                      fontSize: ResponsiveCardConfig.getSectionTitleFontSize(
                        context,
                      ),
                      fontWeight: FontWeight.w600,
                      color: DeepColorTokens.neutral900.withValues(alpha: 0.9),
                    ),
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
                    child: Text(
                      'Voir tout',
                      style: TextStyle(
                        color: DeepColorTokens.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Liste horizontale de cartes de marchands
        SizedBox(
          height: _calculateCardHeight(context),
          child: merchantsAsync.when(
            data: (merchants) {
              if (merchants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 48.0,
                        ),
                        color: DeepColorTokens.neutral600.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      SizedBox(
                        height:
                            ResponsiveUtils.getVerticalSpacing(context) * 0.4,
                      ),
                      Text(
                        'Aucun marchand disponible',
                        style: TextStyle(
                          color: DeepColorTokens.neutral600.withValues(
                            alpha: 0.8,
                          ),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final cardWidth = ResponsiveCardConfig.getSliderCardWidth(
                context,
              );
              final cardSpacing = ResponsiveCardConfig.getCardSpacing(context);

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: ResponsiveCardConfig.getSliderPadding(context),
                physics: const BouncingScrollPhysics(),
                itemCount: merchants.length,
                itemBuilder: (context, index) {
                  final merchant = merchants[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: cardSpacing / 2,
                    ),
                    child: SizedBox(
                      width: cardWidth,
                      child: MerchantCard(
                        merchant: merchant,
                        onTap: () {
                          // TODO(navigation): Add merchant detail navigation
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
            loading: () => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  DeepColorTokens.primary,
                ),
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveUtils.getIconSize(context, baseSize: 48.0),
                    color: DeepColorTokens.error,
                  ),
                  SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: DeepColorTokens.neutral600.withValues(alpha: 0.8),
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        14.0,
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
                  TextButton.icon(
                    onPressed: () {
                      ref.invalidate(merchantsProvider);
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: ResponsiveUtils.getIconSize(context),
                    ),
                    label: Text(
                      'Réessayer',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: ResponsiveUtils.getVerticalSpacing(context)),
      ],
    );
  }
}
