import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/stock_items_provider.dart';

/// Menu flottant pour filtrer par catégorie
///
/// Affiche un bouton d'action flottant qui, lorsqu'il est pressé,
/// ouvre un menu élégant avec toutes les catégories disponibles
class StockCategoryFloatingMenu extends ConsumerStatefulWidget {
  const StockCategoryFloatingMenu({super.key});

  @override
  ConsumerState<StockCategoryFloatingMenu> createState() =>
      _StockCategoryFloatingMenuState();
}

class _StockCategoryFloatingMenuState
    extends ConsumerState<StockCategoryFloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isOpen = false;

  // Catégories centralisées avec icônes et couleurs
  late final List<
    ({String label, String slug, FoodCategory id, IconData icon, Color color})
  >
  _categories = [
    (
      label: 'Tous',
      slug: '',
      id: FoodCategory.autre,
      icon: Icons.grid_view_rounded,
      color: DeepColorTokens.neutral700,
    ),
    ...Categories.ordered.map(
      (c) => (
        label: Categories.labelOf(c),
        slug: Categories.slugOf(c),
        id: c,
        icon: Categories.iconOf(c),
        color: Categories.colorOf(c),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        unawaited(_animationController.forward());
      } else {
        unawaited(_animationController.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFilters = ref.watch(stockFiltersProvider);
    final selectedCategory = currentFilters.searchQuery.isEmpty
        ? 'Tous'
        : currentFilters.searchQuery;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Overlay pour fermer le menu en cliquant ailleurs
        if (_isOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(color: DeepColorTokens.overlayMedium),
          ),

        // Menu des catégories
        if (_isOpen)
          Positioned(
            bottom: context.buttonHeight + context.verticalSpacing,
            right: context.horizontalSpacing,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: context.responsive(
                  mobile: 250.0,
                  tablet: 300.0,
                  desktop: 320.0,
                ),
                maxHeight: context.responsive(
                  mobile: 400.0,
                  tablet: 500.0,
                  desktop: 600.0,
                ),
                minWidth: context.responsive(
                  mobile: 200.0,
                  tablet: 250.0,
                  desktop: 280.0,
                ),
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral0,
                borderRadius: BorderRadius.circular(context.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: DeepColorTokens.shadowLight.withValues(alpha: 0.3),
                    blurRadius: context.responsive(
                      mobile: 8.0,
                      tablet: 12.0,
                      desktop: 16.0,
                    ),
                    offset: Offset(
                      0,
                      context.responsive(
                        mobile: 2.0,
                        tablet: 3.0,
                        desktop: 4.0,
                      ),
                    ),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: context.verticalSpacing,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: context.responsive(
                      mobile: 200.0,
                      tablet: 250.0,
                      desktop: 280.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre du menu
                      Padding(
                        padding: context.responsivePadding,
                        child: ResponsiveText(
                          'Catégories',
                          fontSize: FontSizes.subtitleSmall,
                          style: TextStyle(
                            color: DeepColorTokens.neutral900,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      // Liste des catégories
                      ..._categories.map((c) {
                        final isSelected =
                            selectedCategory == c.label ||
                            selectedCategory == c.slug;
                        final color = c.color;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Mettre à jour le filtre en stockant le slug (ou vide pour 'Tous')
                              ref
                                  .read(stockFiltersProvider.notifier)
                                  .updateSearchQuery(c.slug);
                              _toggleMenu();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.horizontalSpacing,
                                vertical: context.verticalSpacing * 0.5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.1)
                                    : Colors.transparent,
                                border: isSelected
                                    ? Border(
                                        left: BorderSide(
                                          color: color,
                                          width: context.responsive(
                                            mobile: 2.0,
                                            tablet: 3.0,
                                            desktop: 4.0,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: context.responsive(
                                      mobile: 24.0,
                                      tablet: 28.0,
                                      desktop: 32.0,
                                    ),
                                    height: context.responsive(
                                      mobile: 24.0,
                                      tablet: 28.0,
                                      desktop: 32.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color.withValues(alpha: 0.2)
                                          : color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(
                                        context.borderRadius,
                                      ),
                                    ),
                                    child: ResponsiveIcon(
                                      c.icon,
                                      size: context.responsive(
                                        mobile: 16.0,
                                        tablet: 18.0,
                                        desktop: 20.0,
                                      ),
                                      color: isSelected
                                          ? color
                                          : color.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  HorizontalGap(),
                                  Expanded(
                                    child: ResponsiveText(
                                      c.label,
                                      fontSize: FontSizes.bodySmall,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? color
                                            : DeepColorTokens.neutral900,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    ResponsiveIcon(
                                      Icons.check_circle,
                                      size: context.responsive(
                                        mobile: 16.0,
                                        tablet: 18.0,
                                        desktop: 20.0,
                                      ),
                                      color: color,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      VerticalGap(),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        FloatingActionButton.small(
          onPressed: _toggleMenu,
          backgroundColor: DeepColorTokens.primary,
          elevation: context.responsive(
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
          child: ResponsiveIcon(
            _isOpen ? Icons.close : Icons.filter_list,
            color: DeepColorTokens.neutral0,
          ),
        ),
      ],
    );
  }
}
