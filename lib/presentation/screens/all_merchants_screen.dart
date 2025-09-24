import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun marchand disponible',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 280, // Hauteur fixe pour les cartes
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
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
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