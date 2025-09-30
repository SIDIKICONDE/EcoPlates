import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../providers/merchants_provider.dart';
import '../../merchant_card.dart';

/// Écran affichant tous les commerçants partenaires
class AllMerchantsScreen extends ConsumerWidget {
  const AllMerchantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantsAsync = ref.watch(merchantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos partenaires'),
        centerTitle: true,
      ),
      body: merchantsAsync.when(
        data: (merchants) {
          if (merchants.isEmpty) {
            return const Center(
              child: Text('Aucun marchand disponible'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MerchantCard(
                  merchant: merchant,
                  onTap: () {
                    // TODO(navigation): Add merchant detail navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Détails de ${merchant.name}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
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
              const Icon(
                Icons.error_outline,
                size: 48.0,
                color: DeepColorTokens.error,
              ),
              const SizedBox(height: 16.0),
              const Text('Erreur de chargement'),
              const SizedBox(height: 16.0),
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
    );
  }
}
