import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
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
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.spacing.dialogGap(context),
          ),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              child: BrandCard(
                brand: brand,
                onTap: () {
                  // Navigation vers la page détail de la marque
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${brand.name} - ${brand.formattedOffersCount}',
                      ),
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
                size: EcoPlatesDesignTokens.layout.errorStateIconSize,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),
              Text(
                'Erreur lors du chargement',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text(
                error.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
              ),
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
