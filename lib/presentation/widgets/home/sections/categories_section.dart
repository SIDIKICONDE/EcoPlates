import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/providers/provider.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/responsive/design_tokens.dart';
import '../../../../domain/entities/food_offer.dart';
import '../../../providers/offers_catalog_provider.dart';

/// Provider pour la catégorie sélectionnée (null = Tous)
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, FoodCategory?>(
      SelectedCategoryNotifier.new,
    );

class SelectedCategoryNotifier extends Notifier<FoodCategory?> {
  @override
  FoodCategory? build() => null;

  void select(FoodCategory? category) {
    state = category;
  }

  void clear() {
    state = null;
  }
}

/// Provider pour vérifier si une catégorie est sélectionnée
/// Peut être utilisé par d'autres sections pour filtrer les offres
final ProviderFamily<bool, FoodCategory?> isCategorySelectedProvider =
    Provider.family<bool, FoodCategory?>(
      (Ref ref, FoodCategory? category) {
        final selected = ref.watch(selectedCategoryProvider);
        return selected == category;
      },
    );

/// Provider: disponibilité des catégories (compte d'offres actives par catégorie)
final homeCategoryAvailabilityProvider = Provider<Map<FoodCategory, int>>((
  ref,
) {
  final offers = ref.watch(offersCatalogProvider);
  final counts = <FoodCategory, int>{};
  for (final o in offers) {
    if (!o.isAvailable) continue;
    final key = o.category;
    counts[key] = (counts[key] ?? 0) + 1;
  }
  return counts;
});

/// Provider pour filtrer une liste d'offres selon la catégorie sélectionnée
final ProviderFamily<List<FoodOffer>, List<FoodOffer>>
filterOffersByCategoryProvider =
    Provider.family<List<FoodOffer>, List<FoodOffer>>((ref, offers) {
      final selectedCategory = ref.watch(selectedCategoryProvider);
      if (selectedCategory == null) return offers; // Tous
      return offers.where((o) => o.category == selectedCategory).toList();
    });

/// Section des catégories avec slider horizontal
class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final availability = ref.watch(homeCategoryAvailabilityProvider);

    // Liste des catégories centralisée avec "Tous" en premier
    final categories = [null, ...Categories.ordered];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slider horizontal de catégories
        Padding(
          padding: EdgeInsets.only(
            top: context.scaleXXS_XS_SM_MD,
          ),
          child: SizedBox(
            height: EcoPlatesDesignTokens.size.minTouchTarget,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleMD_LG_XL_XXL,
              ),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isEnabled =
                    category == null || (availability[category] ?? 0) > 0;
                final isSelected = isEnabled && selectedCategory == category;
                final label = category == null
                    ? 'Tous'
                    : Categories.labelOf(category);

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.md,
                        ),
                        onTap: isEnabled
                            ? () {
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .select(category);
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleMD_LG_XL_XXL,
                            vertical: context.scaleXXS_XS_SM_MD,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : (isEnabled
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerHighest
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainerLow),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.xl,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : (isEnabled
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.outline.withValues(
                                            alpha: EcoPlatesDesignTokens
                                                .opacity
                                                .subtle,
                                          )
                                        : Theme.of(
                                            context,
                                          ).colorScheme.outline.withValues(
                                            alpha: EcoPlatesDesignTokens
                                                .opacity
                                                .disabled,
                                          )),
                              width:
                                  EcoPlatesDesignTokens.layout.cardBorderWidth,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(
                                            alpha: EcoPlatesDesignTokens
                                                .opacity
                                                .subtle,
                                          ),
                                      blurRadius: EcoPlatesDesignTokens
                                          .elevation
                                          .smallBlur,
                                      offset: EcoPlatesDesignTokens
                                          .elevation
                                          .standardOffset,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (category != null) ...[
                                  Icon(
                                    Categories.iconOf(category),
                                    size: EcoPlatesDesignTokens.size.indicator(
                                      context,
                                    ),
                                    color: isSelected
                                        ? EcoPlatesDesignTokens
                                              .colors
                                              .textPrimary
                                        : (isEnabled
                                              ? Categories.colorOf(category)
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(
                                                      alpha:
                                                          EcoPlatesDesignTokens
                                                              .opacity
                                                              .disabled,
                                                    )),
                                  ),
                                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                                ],
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? EcoPlatesDesignTokens
                                              .colors
                                              .textPrimary
                                        : (isEnabled
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onSurface
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(
                                                      alpha:
                                                          EcoPlatesDesignTokens
                                                              .opacity
                                                              .disabled,
                                                    )),
                                    fontWeight: isSelected
                                        ? EcoPlatesDesignTokens
                                              .typography
                                              .semiBold
                                        : EcoPlatesDesignTokens
                                              .typography
                                              .medium,
                                    fontSize: EcoPlatesDesignTokens.typography
                                        .hint(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: context.scaleXXS_XS_SM_MD),
      ],
    );
  }
}
