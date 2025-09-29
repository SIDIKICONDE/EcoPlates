import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48.0,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Aucune vente trouvée',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Modifiez vos filtres pour voir plus de résultats',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14.0,
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
              padding: const EdgeInsets.only(bottom: 10.0),
              child: SaleCard(sale: sale),
            );
          }, childCount: sales.length),
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
                  color: Colors.red,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Erreur de chargement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
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
