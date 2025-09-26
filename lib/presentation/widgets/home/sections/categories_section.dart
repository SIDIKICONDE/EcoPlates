import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/categories.dart';
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
final isCategorySelectedProvider = Provider.family<bool, FoodCategory?>((
  ref,
  category,
) {
  final selected = ref.watch(selectedCategoryProvider);
  return selected == category;
});

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
final filterOffersByCategoryProvider =
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
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: isEnabled
                            ? () {
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .select(category);
                              }
                            : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : (isEnabled
                                      ? Colors.grey.shade100
                                      : Colors.grey.shade50),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : (isEnabled
                                        ? Colors.grey.shade300
                                        : Colors.grey.shade200),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
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
                                    size: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : (isEnabled
                                              ? Categories.colorOf(category)
                                              : Colors.grey.shade400),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : (isEnabled
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade400),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    fontSize: 14,
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

        const SizedBox(height: 5),
      ],
    );
  }
}
