import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/brand_provider.dart';
import '../widgets/brand_card.dart';

/// Page affichant toutes les marques partenaires
class AllBrandsScreen extends ConsumerWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes les enseignes'),
        centerTitle: false,
      ),
      body: brandsAsync.when(
        data: (brands) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BrandCard(
                brand: brand,
                onTap: () {
                  // Navigation vers la page détail de la marque
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${brand.name} - ${brand.formattedOffersCount}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            );
          },
        ),
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
                'Erreur lors du chargement',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Forcer le rechargement
                  ref.invalidate(brandsProvider);
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