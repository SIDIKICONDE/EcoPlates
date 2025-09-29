import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            20.0,
            8.0,
            20.0,
            20.0,
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.9),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      unawaited(
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const AllMerchantsScreen(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      size: 16.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
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
          height: 280.0,
          child: merchantsAsync.when(
            data: (merchants) {
              if (merchants.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_outlined,
                        size: 48.0,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Aucun marchand disponible',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: merchants.length,
                itemBuilder: (context, index) {
                  final merchant = merchants[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
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
                    size: 48.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
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

        SizedBox(height: 20.0),
      ],
    );
  }
}
