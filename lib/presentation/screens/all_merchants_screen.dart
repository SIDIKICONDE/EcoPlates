import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../providers/merchants_provider.dart';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_outlined,
                    size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(
                    height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                  ),
                  Text(
                    'Aucun marchand disponible',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: EcoPlatesDesignTokens.spacing.dialogGap(context),
              vertical: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                child: SizedBox(
                  height: EcoPlatesDesignTokens.layout.merchantCardHeight(
                    context,
                  ),
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
                size: EcoPlatesDesignTokens.layout.errorStateIconSize,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
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
