import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
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
    final theme = Theme.of(context);
    final currentFilters = ref.watch(stockFiltersProvider);
    final stockItemsAsync = ref.watch(stockItemsProvider);

    // Calcul des compteurs pour chaque filtre
    final counts = stockItemsAsync.maybeWhen(
      data: _calculateCounts,
      orElse: () => <StockFilterOption, int>{},
    );

    return Wrap(
      spacing: context.scaleSM_MD_LG_XL,
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
                size: context.scaleIconStandard,
                color: isSelected
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Text(
                option.label,
                style: TextStyle(
                  height: 1.2,
                  fontSize: EcoPlatesDesignTokens.typography.modalContent(
                    context,
                  ),
                ),
              ),
              if (showCounts && count > 0) ...[
                SizedBox(width: context.scaleXXS_XS_SM_MD),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                    vertical: context.scaleXXS_XS_SM_MD,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.onSecondaryContainer.withValues(
                            alpha: EcoPlatesDesignTokens.opacity.pressed,
                          )
                        : theme.colorScheme.onSurfaceVariant.withValues(
                            alpha:
                                EcoPlatesDesignTokens.opacity.veryTransparent,
                          ),
                    borderRadius: BorderRadius.circular(
                      EcoPlatesDesignTokens.radius.sm,
                    ),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.hint(context),
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.onSecondaryContainer
                          : theme.colorScheme.onSurfaceVariant,
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
          backgroundColor: theme.colorScheme.surface,
          selectedColor: theme.colorScheme.secondaryContainer,
          checkmarkColor: theme.colorScheme.onSecondaryContainer,
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
