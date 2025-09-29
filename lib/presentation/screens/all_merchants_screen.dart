import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/merchants_provider.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/merchant_card.dart';

/// Page affichant tous les marchands partenaires
class AllMerchantsScreen extends ConsumerWidget {
  const AllMerchantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous nos partenaires'),
        centerTitle: true,
        elevation: 0,
      ),
      body: merchantsAsync.when(
        data: (merchants) {
          if (merchants.isEmpty) {
            return const EmptyState(
              icon: Icons.store_outlined,
              title: 'Aucun marchand disponible',
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: SizedBox(
                  height: 120.0,
                  child: MerchantCard(
                    merchant: merchant,
                    onTap: () {
                      // TODO: Navigation vers le détail du marchand
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
              SizedBox(
                height: 12.0,
              ),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              ElevatedButton.icon(
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
    );
  }
}
