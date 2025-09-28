import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
import '../../providers/sales_provider.dart';
import 'components/index.dart';

/// Liste des ventes avec gestion des états de chargement
class SalesListView extends ConsumerWidget {
  const SalesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(salesProvider);

    return salesAsync.when(
      data: (sales) {
        if (sales.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: context.applyPattern([
                        48.0, // mobile
                        56.0, // tablet
                        64.0, // desktop
                        72.0, // desktop large
                      ]),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: context.scaleMD_LG_XL_XXL),
                    Text(
                      'Aucune vente trouvée',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                          context,
                        ),
                      ),
                    ),
                    SizedBox(height: context.scaleSM_MD_LG_XL),
                    Text(
                      'Modifiez vos filtres pour voir plus de résultats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: EcoPlatesDesignTokens.typography.modalContent(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final sale = sales[index];
            return Padding(
              padding: EdgeInsets.only(bottom: context.scaleXS_SM_MD_LG),
              child: SaleCard(sale: sale),
            );
          }, childCount: sales.length),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
            child: CircularProgressIndicator(
              strokeWidth: DesignConstants.two,
            ),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: context.applyPattern([
                    36.0, // mobile
                    42.0, // tablet
                    48.0, // desktop
                    54.0, // desktop large
                  ]),
                  color: Colors.red,
                ),
                SizedBox(height: context.scaleMD_LG_XL_XXL),
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                      context,
                    ),
                  ),
                ),
                SizedBox(height: context.scaleSM_MD_LG_XL),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: EcoPlatesDesignTokens.typography.modalContent(
                      context,
                    ),
                  ),
                ),
                SizedBox(height: context.scaleMD_LG_XL_XXL),
                TextButton.icon(
                  onPressed: () =>
                      unawaited(ref.read(salesProvider.notifier).refresh()),
                  icon: Icon(
                    Icons.refresh,
                    size: context.scaleIconStandard,
                  ),
                  label: Text(
                    'Réessayer',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.modalContent(
                        context,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
