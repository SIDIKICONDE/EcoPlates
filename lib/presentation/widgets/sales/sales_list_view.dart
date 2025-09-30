import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../providers/sales_provider.dart';
import '../home/sections/responsive_card_config.dart';
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48.0,
                      color: DeepColorTokens.neutral600,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Aucune vente trouvée',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: DeepColorTokens.neutral600,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Modifiez vos filtres pour voir plus de résultats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DeepColorTokens.neutral600,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              final columns = ResponsiveCardConfig.getOptimalGridColumns(
                context,
              );
              final cardWidth = ResponsiveCardConfig.getGridCardWidth(
                context,
                columnsCount: columns,
              );
              final spacing = ResponsiveCardConfig.getCardSpacing(context);

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: sales
                    .map(
                      (sale) => SizedBox(
                        width: cardWidth,
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 200.0),
                          child: SaleCard(sale: sale),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 36.0,
                  color: DeepColorTokens.error,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: DeepColorTokens.error,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextButton.icon(
                  onPressed: () =>
                      unawaited(ref.read(salesProvider.notifier).refresh()),
                  icon: Icon(
                    Icons.refresh,
                    size: 20.0,
                  ),
                  label: Text(
                    'Réessayer',
                    style: TextStyle(
                      fontSize: 14.0,
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
