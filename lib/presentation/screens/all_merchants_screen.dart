import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
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
        title: Text(
          'Tous nos partenaires',
          style: TextStyle(
            fontSize: FontSizes.subtitleLarge.getSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: context.appBarHeight,
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
              horizontal: context.horizontalSpacing,
              vertical: context.verticalSpacing,
            ),
            itemCount: merchants.length,
            itemBuilder: (context, index) {
              final merchant = merchants[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: context.verticalSpacing,
                ),
                child: SizedBox(
                  height: ResponsiveUtils.getMerchantCardHeight(context),
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
                size: ResponsiveUtils.getIconSize(context),
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(
                height: context.verticalSpacing,
              ),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: FontSizes.subtitleMedium.getSize(context),
                ),
              ),
              SizedBox(
                height: context.verticalSpacing,
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
