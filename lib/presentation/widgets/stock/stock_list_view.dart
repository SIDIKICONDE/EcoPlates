import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../domain/entities/stock_item.dart';
import '../../providers/stock_items_provider.dart';
import 'stock_list_item.dart';
import 'stock_list_item_compact.dart';

/// Widget principal affichant la liste des articles de stock
///
/// Gère les différents états (loading, error, empty, data) et affiche
/// la liste d'articles avec pull-to-refresh, scrolling infini et animations.
/// Optimisé pour Material 3 et Cupertino avec LayoutBuilder pour la responsivité.
class StockListView extends ConsumerWidget {
  const StockListView({
    super.key,
    this.onItemTap,
    this.physics,
    this.shrinkWrap = false,
    this.showAnimations = true,
    this.compactMode = false,
    this.enablePullToRefresh = true,
    this.enableInfiniteScroll = false,
    this.dense,
  });

  /// Callback lors du tap sur un article
  final void Function(StockItem item)? onItemTap;

  /// Physique de scroll personnalisée
  final ScrollPhysics? physics;

  /// Mode shrink wrap pour intégration dans d'autres scroll views
  final bool shrinkWrap;

  /// Active les animations et transitions
  final bool showAnimations;

  /// Mode compact pour affichage réduit
  final bool compactMode;

  /// Active le pull-to-refresh
  final bool enablePullToRefresh;

  /// Active le scroll infini (pour futures fonctionnalités)
  final bool enableInfiniteScroll;

  /// Force le mode dense si fourni; sinon auto (< 360px)
  final bool? dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockItemsAsync = ref.watch(stockItemsProvider);
    final isCompactView = ref.watch(stockViewModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return stockItemsAsync.when(
          data: (items) =>
              _buildItemsList(context, ref, items, constraints, isCompactView),
          loading: () => _buildLoadingState(context, constraints),
          error: (error, stackTrace) =>
              _buildErrorState(context, ref, error, constraints),
        );
      },
    );
  }

  Widget _buildItemsList(
    BuildContext context,
    WidgetRef ref,
    List<StockItem> items,
    BoxConstraints constraints,
    bool isCompactView,
  ) {
    final isDense = dense ?? (constraints.maxWidth < 360);
    if (items.isEmpty) {
      return _buildEmptyState(context, ref, constraints);
    }

    final listView = ListView.builder(
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      shrinkWrap: shrinkWrap,
      itemCount: items.length + (enableInfiniteScroll ? 1 : 0),
      itemBuilder: (context, index) {
        // Indicateur de chargement pour scroll infini
        if (enableInfiniteScroll && index == items.length) {
          return _buildInfiniteScrollIndicator(context);
        }

        final item = items[index];

        return AnimatedSlide(
          offset: showAnimations ? Offset.zero : const Offset(0, 0.1),
          duration: showAnimations
              ? Duration(milliseconds: 300 + (index * 50))
              : Duration.zero,
          curve: Curves.easeOutCubic,
          child: isCompactView
              ? StockListItemCompact(
                  item: item,
                  dense: isDense,
                  onTap: onItemTap != null ? () => onItemTap!(item) : null,
                )
              : StockListItem(
                  item: item,
                  showDivider: false,
                  showAnimations: showAnimations,
                  compactMode: compactMode,
                  dense: isDense,
                  onTap: onItemTap != null ? () => onItemTap!(item) : null,
                ),
        );
      },
    );

    if (enablePullToRefresh) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(stockItemsProvider.notifier).refresh();
        },
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildLoadingState(BuildContext context, BoxConstraints constraints) {
    final theme = Theme.of(context);
    final isCompact = constraints.maxWidth < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isCompact
              ? context.scaleMD_LG_XL_XXL
              : context.scaleMD_LG_XL_XXL * 1.25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedRotation(
              turns: showAnimations ? 1.0 : 0.0,
              duration: showAnimations
                  ? const Duration(seconds: 2)
                  : Duration.zero,
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 3,
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleSM_MD_LG_XL
                  : context.scaleMD_LG_XL_XXL,
            ),
            AnimatedOpacity(
              opacity: showAnimations ? 0.8 : 1.0,
              duration: showAnimations
                  ? const Duration(milliseconds: 500)
                  : Duration.zero,
              child: Text(
                'Chargement des articles...',
                style: TextStyle(
                  fontSize: isCompact
                      ? EcoPlatesDesignTokens.typography.text(context)
                      : EcoPlatesDesignTokens.typography.titleSize(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (showAnimations) ...[
              SizedBox(
                height: isCompact
                    ? context.scaleXXS_XS_SM_MD
                    : context.scaleXS_SM_MD_LG,
              ),
              AnimatedOpacity(
                opacity: 0.6,
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  'Préparation de votre inventaire',
                  style: TextStyle(
                    fontSize: isCompact
                        ? EcoPlatesDesignTokens.typography.hint(context)
                        : EcoPlatesDesignTokens.typography.text(context),
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                    ),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
    BoxConstraints constraints,
  ) {
    final theme = Theme.of(context);
    final isCompact = constraints.maxWidth < 600;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isCompact
              ? context.scaleMD_LG_XL_XXL
              : context.scaleMD_LG_XL_XXL * 1.25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: showAnimations ? 1.0 : 0.9,
              duration: showAnimations
                  ? const Duration(milliseconds: 300)
                  : Duration.zero,
              child: Container(
                padding: EdgeInsets.all(
                  isCompact
                      ? context.scaleSM_MD_LG_XL
                      : context.scaleMD_LG_XL_XXL,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: isCompact
                      ? EcoPlatesDesignTokens.size.icon(context) * 2
                      : EcoPlatesDesignTokens.size.icon(context) * 2.66,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleSM_MD_LG_XL
                  : context.scaleMD_LG_XL_XXL,
            ),
            AnimatedOpacity(
              opacity: showAnimations ? 0.9 : 1.0,
              duration: showAnimations
                  ? const Duration(milliseconds: 500)
                  : Duration.zero,
              child: Text(
                'Une erreur est survenue',
                style: TextStyle(
                  fontSize: isCompact
                      ? EcoPlatesDesignTokens.typography.titleSize(context)
                      : EcoPlatesDesignTokens.typography.titleSize(context) *
                            1.2,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleXXS_XS_SM_MD
                  : context.scaleXS_SM_MD_LG,
            ),
            AnimatedOpacity(
              opacity: showAnimations ? 0.7 : 1.0,
              duration: showAnimations
                  ? const Duration(milliseconds: 700)
                  : Duration.zero,
              child: Text(
                StockErrorMessages.getErrorMessage(error),
                style: TextStyle(
                  fontSize: isCompact
                      ? EcoPlatesDesignTokens.typography.hint(context)
                      : EcoPlatesDesignTokens.typography.text(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleMD_LG_XL_XXL
                  : context.scaleMD_LG_XL_XXL * 1.25,
            ),
            AnimatedScale(
              scale: showAnimations ? 1.0 : 0.95,
              duration: showAnimations
                  ? const Duration(milliseconds: 400)
                  : Duration.zero,
              child: FilledButton.icon(
                onPressed: () {
                  unawaited(ref.read(stockItemsProvider.notifier).refresh());
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Réessayer'),
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact
                        ? context.scaleSM_MD_LG_XL
                        : context.scaleMD_LG_XL_XXL,
                    vertical: isCompact
                        ? context.scaleXS_SM_MD_LG
                        : context.scaleSM_MD_LG_XL,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    BoxConstraints constraints,
  ) {
    final theme = Theme.of(context);
    final filters = ref.watch(stockFiltersProvider);
    final isCompact = constraints.maxWidth < 600;

    // Messages différents selon si on a des filtres ou non
    final hasActiveFilters =
        filters.searchQuery.isNotEmpty || filters.statusFilter != null;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          isCompact
              ? context.scaleMD_LG_XL_XXL
              : context.scaleMD_LG_XL_XXL * 1.25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: showAnimations ? 1.0 : 0.9,
              duration: showAnimations
                  ? const Duration(milliseconds: 300)
                  : Duration.zero,
              child: Container(
                padding: EdgeInsets.all(
                  isCompact
                      ? context.scaleSM_MD_LG_XL
                      : context.scaleMD_LG_XL_XXL,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  hasActiveFilters
                      ? Icons.search_off_rounded
                      : Icons.inventory_2_outlined,
                  size: isCompact
                      ? EcoPlatesDesignTokens.size.icon(context) * 2
                      : EcoPlatesDesignTokens.size.icon(context) * 2.66,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleSM_MD_LG_XL
                  : context.scaleMD_LG_XL_XXL,
            ),
            AnimatedOpacity(
              opacity: showAnimations ? 0.9 : 1.0,
              duration: showAnimations
                  ? const Duration(milliseconds: 500)
                  : Duration.zero,
              child: Text(
                hasActiveFilters
                    ? 'Aucun article trouvé'
                    : 'Aucun article en stock',
                style: TextStyle(
                  fontSize: isCompact
                      ? EcoPlatesDesignTokens.typography.titleSize(context)
                      : EcoPlatesDesignTokens.typography.titleSize(context) *
                            1.2,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: isCompact
                  ? context.scaleXXS_XS_SM_MD
                  : context.scaleXS_SM_MD_LG,
            ),
            AnimatedOpacity(
              opacity: showAnimations ? 0.7 : 1.0,
              duration: showAnimations
                  ? const Duration(milliseconds: 700)
                  : Duration.zero,
              child: Text(
                hasActiveFilters
                    ? 'Essayez de modifier vos critères de recherche'
                    : 'Commencez par ajouter des articles à votre stock',
                style: TextStyle(
                  fontSize: isCompact
                      ? EcoPlatesDesignTokens.typography.hint(context)
                      : EcoPlatesDesignTokens.typography.text(context),
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Bouton pour effacer les filtres si on en a
            if (hasActiveFilters) ...[
              SizedBox(
                height: isCompact
                    ? context.scaleMD_LG_XL_XXL
                    : context.scaleMD_LG_XL_XXL * 1.25,
              ),
              AnimatedScale(
                scale: showAnimations ? 1.0 : 0.95,
                duration: showAnimations
                    ? const Duration(milliseconds: 400)
                    : Duration.zero,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(stockFiltersProvider.notifier)
                        .updateStatusFilter(null);
                    const StockFiltersState();
                  },
                  icon: const Icon(Icons.clear_rounded),
                  label: const Text('Effacer les filtres'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact
                          ? context.scaleSM_MD_LG_XL
                          : context.scaleMD_LG_XL_XXL,
                      vertical: isCompact
                          ? context.scaleXS_SM_MD_LG
                          : context.scaleSM_MD_LG_XL,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget pour l'indicateur de scroll infini
  Widget _buildInfiniteScrollIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(context.scaleSM_MD_LG_XL),
      child: Center(
        child: AnimatedOpacity(
          opacity: showAnimations ? 0.8 : 1.0,
          duration: showAnimations
              ? const Duration(milliseconds: 500)
              : Duration.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: EcoPlatesDesignTokens.size.icon(context),
                height: EcoPlatesDesignTokens.size.icon(context),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Text(
                'Chargement...',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
