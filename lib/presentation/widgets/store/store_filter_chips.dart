import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../providers/store_offers_provider.dart';

/// Chips de filtrage pour les offres de la boutique
class StoreFilterChips extends ConsumerWidget {
  const StoreFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filters = ref.watch(storeFiltersProvider);
    final categories = ref.watch(availableCategoriesProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filtre Toutes
          FilterChip(
            label: const Text('Toutes'),
            selected: filters.displayMode == OfferDisplayMode.all,
            onSelected: (_) {
              ref
                  .read(storeFiltersProvider.notifier)
                  .setDisplayMode(OfferDisplayMode.all);
            },
            avatar: Icon(
              filters.displayMode == OfferDisplayMode.all
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              size: 16.0,
            ),
            backgroundColor: DeepColorTokens.surfaceContainer.withValues(
              alpha: 0.1,
            ),
          ),

          // Filtre Actives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Actives'),
                const SizedBox(width: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: DeepColorTokens.neutral500.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    ref.watch(activeOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: DeepColorTokens.neutral800,
                    ),
                  ),
                ),
              ],
            ),
            selected: filters.displayMode == OfferDisplayMode.activeOnly,
            onSelected: (_) {
              ref
                  .read(storeFiltersProvider.notifier)
                  .setDisplayMode(OfferDisplayMode.activeOnly);
            },
            avatar: Icon(
              filters.displayMode == OfferDisplayMode.activeOnly
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              size: 16.0,
            ),
            backgroundColor: DeepColorTokens.surfaceContainer.withValues(
              alpha: 0.1,
            ),
          ),

          // Filtre Inactives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Inactives'),
                const SizedBox(width: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: DeepColorTokens.neutral500.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    ref.watch(inactiveOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: DeepColorTokens.neutral800,
                    ),
                  ),
                ),
              ],
            ),
            selected: filters.displayMode == OfferDisplayMode.inactiveOnly,
            onSelected: (_) {
              ref
                  .read(storeFiltersProvider.notifier)
                  .setDisplayMode(OfferDisplayMode.inactiveOnly);
            },
            avatar: Icon(
              filters.displayMode == OfferDisplayMode.inactiveOnly
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              size: 16.0,
            ),
            backgroundColor: DeepColorTokens.surfaceContainer.withValues(
              alpha: 0.1,
            ),
          ),

          // Filtre promotions
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Promotions'),
                if (filters.showPromotionsOnly) ...[
                  const SizedBox(width: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: DeepColorTokens.error,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'ON',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: DeepColorTokens.neutral0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            selected: filters.showPromotionsOnly,
            onSelected: (_) {
              ref.read(storeFiltersProvider.notifier).togglePromotionsOnly();
            },
            avatar: Icon(
              Icons.local_offer,
              size: 16.0,
            ),
            backgroundColor: DeepColorTokens.surfaceContainer.withValues(
              alpha: 0.1,
            ),
          ),

          // Divider
          Container(
            height: 30,
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(width: 12.0),

          // Chips de catégories
          ...categories.map((category) {
            final isSelected = filters.selectedCategories.contains(category);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(Categories.labelOf(category)),
                avatar: Icon(
                  Categories.iconOf(category),
                  size: 16.0,
                  color: isSelected
                      ? DeepColorTokens.neutral800
                      : Categories.colorOf(category),
                ),
                selected: isSelected,
                onSelected: (_) {
                  ref
                      .read(storeFiltersProvider.notifier)
                      .toggleCategory(category);
                },
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.1),
              ),
            );
          }),

          // Bouton de réinitialisation
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              ref.read(storeFiltersProvider.notifier).resetFilters();
            },
            tooltip: 'Réinitialiser les filtres',
            iconSize: 20.0,
            color: DeepColorTokens.error,
          ),
        ],
      ),
    );
  }
}
