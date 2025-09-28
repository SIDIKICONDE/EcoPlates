import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/responsive/design_tokens.dart';
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
              size: EcoPlatesDesignTokens.size.icon(context),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Filtre Actives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Actives'),
                SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                    vertical: context.scaleXXS_XS_SM_MD / 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                    ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.sm,
                    ),
                  ),
                  child: Text(
                    ref.watch(activeOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
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
              size: EcoPlatesDesignTokens.size.icon(context),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Filtre Inactives
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Inactives'),
                SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                    vertical: context.scaleXXS_XS_SM_MD / 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                    ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.sm,
                    ),
                  ),
                  child: Text(
                    ref.watch(inactiveOffersCountProvider).toString(),
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
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
              size: EcoPlatesDesignTokens.size.icon(context),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
            selectedColor: theme.colorScheme.primaryContainer,
            checkmarkColor: theme.colorScheme.onPrimaryContainer,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Filtre promotions
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Promotions'),
                if (filters.showPromotionsOnly) ...[
                  SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXXS_XS_SM_MD,
                      vertical: context.scaleXXS_XS_SM_MD / 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(
                        EcoPlatesDesignTokens.radius.sm,
                      ),
                    ),
                    child: Text(
                      ref.watch(activePromotionsCountProvider).toString(),
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
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
            avatar: Icon(
              Icons.local_offer,
              size: EcoPlatesDesignTokens.size.icon(context),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
            selectedColor: theme.colorScheme.errorContainer,
            checkmarkColor: theme.colorScheme.onErrorContainer,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Divider
          Container(
            height: 30,
            width: 1,
            color: theme.colorScheme.outlineVariant,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Chips de catégories
          ...categories.map((category) {
            final isSelected = filters.selectedCategories.contains(category);
            return Padding(
              padding: EdgeInsets.only(right: context.scaleXXS_XS_SM_MD),
              child: FilterChip(
                label: Text(Categories.labelOf(category)),
                avatar: Icon(
                  Categories.iconOf(category),
                  size: EcoPlatesDesignTokens.size.indicator(context),
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
                    .withValues(alpha: EcoPlatesDesignTokens.opacity.pressed),
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
              iconSize: EcoPlatesDesignTokens.size.icon(context),
              color: theme.colorScheme.error,
            ),
          ],
        ],
      ),
    );
  }
}
