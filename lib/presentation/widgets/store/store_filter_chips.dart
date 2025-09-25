import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
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
              size: 18,
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),

          // Filtre Actives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Actives'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ref.watch(activeOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
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
              size: 18,
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),

          // Filtre Inactives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Inactives'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    ref.watch(inactiveOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
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
              size: 18,
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),

          // Filtre promotions
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Promotions'),
                if (filters.showPromotionsOnly) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      ref.watch(activePromotionsCountProvider).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onError,
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
            avatar: const Icon(Icons.local_offer, size: 18),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            selectedColor: theme.colorScheme.errorContainer,
            checkmarkColor: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),

          // Divider
          Container(
            height: 30,
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(width: 8),

          // Chips de catégories
          ...categories.map((category) {
            final isSelected = filters.selectedCategories.contains(category);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(Categories.labelOf(category)),
                avatar: Icon(
                  Categories.iconOf(category),
                  size: 16,
                  color: isSelected
                      ? theme.colorScheme.onSecondaryContainer
                      : Categories.colorOf(category),
                ),
                selected: isSelected,
                onSelected: (_) {
                  ref
                      .read(storeFiltersProvider.notifier)
                      .toggleCategory(category);
                },
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                selectedColor: theme.colorScheme.secondaryContainer,
                checkmarkColor: theme.colorScheme.onSecondaryContainer,
              ),
            );
          }),

          // Bouton pour réinitialiser les filtres
          if (filters.selectedCategories.isNotEmpty ||
              filters.displayMode != OfferDisplayMode.all ||
              filters.showPromotionsOnly) ...[
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                ref.read(storeFiltersProvider.notifier).resetFilters();
              },
              tooltip: 'Réinitialiser les filtres',
              iconSize: 20,
              color: theme.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}
