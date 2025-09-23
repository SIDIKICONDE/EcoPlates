import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider pour la catégorie de restaurant sélectionnée
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

/// Provider pour obtenir la catégorie actuellement sélectionnée
final currentCategoryProvider = Provider<String>((ref) {
  return ref.watch(selectedCategoryProvider);
});

/// Provider pour vérifier si une catégorie spécifique est sélectionnée
final isCategorySelectedProvider = Provider.family<bool, String>((ref, categoryId) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  return selectedCategory == categoryId;
});