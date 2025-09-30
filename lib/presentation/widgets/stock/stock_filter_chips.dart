import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';

/// Options de filtre pour le statut des articles
enum StockFilterOption { all, active, inactive }

/// Extension pour l'affichage des options de filtre
extension StockFilterOptionExtension on StockFilterOption {
  /// Label localisé de l'option de filtre
  String get label {
    switch (this) {
      case StockFilterOption.all:
        return 'Tous';
      case StockFilterOption.active:
        return 'Actifs';
      case StockFilterOption.inactive:
        return 'Inactifs';
    }
  }

  /// Icône associée à l'option de filtre
  IconData get icon {
    switch (this) {
      case StockFilterOption.all:
        return Icons.list;
      case StockFilterOption.active:
        return Icons.visibility;
      case StockFilterOption.inactive:
        return Icons.visibility_off;
    }
  }

  /// Convertit l'option en filtre de statut
  StockItemStatus? get statusFilter {
    switch (this) {
      case StockFilterOption.all:
        return null;
      case StockFilterOption.active:
        return StockItemStatus.active;
      case StockFilterOption.inactive:
        return StockItemStatus.inactive;
    }
  }
}

/// Widget de chips pour filtrer les articles par statut
///
/// Affiche des chips Material 3 pour filtrer entre :
/// - Tous les articles
/// - Articles actifs uniquement
/// - Articles inactifs uniquement
class StockFilterChips extends ConsumerWidget {
  const StockFilterChips({super.key, this.showCounts = true});

  /// Affiche le nombre d'articles dans chaque catégorie
  final bool showCounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilters = ref.watch(stockFiltersProvider);
    final stockItemsAsync = ref.watch(stockItemsProvider);

    // Calcul des compteurs pour chaque filtre
    final counts = stockItemsAsync.maybeWhen(
      data: _calculateCounts,
      orElse: () => <StockFilterOption, int>{},
    );

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: StockFilterOption.values.map((option) {
        final isSelected = _isOptionSelected(
          option,
          currentFilters.statusFilter,
        );
        final count = counts[option] ?? 0;

        return FilterChip(
          selected: isSelected,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.icon,
                size: 18.0,
                color: isSelected
                    ? DeepColorTokens.primary
                    : DeepColorTokens.neutral600,
              ),
              const SizedBox(width: 6.0),
              Text(
                option.label,
                style: TextStyle(
                  height: 1.2,
                  fontSize: 14.0,
                ),
              ),
              if (showCounts && count > 0) ...[
                const SizedBox(width: 6.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? DeepColorTokens.primaryContainer.withValues(
                            alpha: 0.2,
                          )
                        : DeepColorTokens.neutral100.withValues(
                            alpha: 0.8,
                          ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? DeepColorTokens.primary
                          : DeepColorTokens.neutral700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onSelected: (selected) {
            _onFilterSelected(ref, option, selected);
          },
          backgroundColor: DeepColorTokens.surface,
          selectedColor: DeepColorTokens.primaryContainer,
          checkmarkColor: DeepColorTokens.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  /// Détermine si l'option est actuellement sélectionnée
  bool _isOptionSelected(
    StockFilterOption option,
    StockItemStatus? currentStatusFilter,
  ) {
    return option.statusFilter == currentStatusFilter;
  }

  /// Gère la sélection/désélection d'un filtre
  void _onFilterSelected(
    WidgetRef ref,
    StockFilterOption option,
    bool selected,
  ) {
    // Si on désélectionne, on revient au filtre "Tous"
    final newStatusFilter = selected ? option.statusFilter : null;

    ref.read(stockFiltersProvider.notifier).updateStatusFilter(newStatusFilter);
  }

  /// Calcule le nombre d'articles pour chaque filtre
  Map<StockFilterOption, int> _calculateCounts(List<StockItem> items) {
    final activeCount = items
        .where((item) => item.status == StockItemStatus.active)
        .length;
    final inactiveCount = items
        .where((item) => item.status == StockItemStatus.inactive)
        .length;

    return {
      StockFilterOption.all: items.length,
      StockFilterOption.active: activeCount,
      StockFilterOption.inactive: inactiveCount,
    };
  }
}
