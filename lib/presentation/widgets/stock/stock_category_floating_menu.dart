import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/categories.dart';
import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/responsive.dart';
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
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
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
      color: Colors.blueGrey,
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
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    final theme = Theme.of(context);
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
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

        // Menu des catégories
        if (_isOpen)
          Positioned(
            bottom: context.applyPattern([
              EcoPlatesDesignTokens.size.minTouchTarget, // mobile
              EcoPlatesDesignTokens.size.minTouchTarget + 10, // tablet
              EcoPlatesDesignTokens.size.minTouchTarget + 20, // desktop
              EcoPlatesDesignTokens.size.minTouchTarget + 30, // desktop large
            ]),
            right: context.scaleMD_LG_XL_XXL,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.bottomRight,
              child: Container(
                width: context.applyPattern([
                  EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context) *
                      0.75, // mobile
                  EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context) *
                      0.7, // tablet
                  EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context) *
                      0.6, // desktop
                  EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context) *
                      0.5, // desktop large
                ]),
                constraints: BoxConstraints(
                  maxHeight: context.applyPattern([
                    MediaQuery.of(context).size.height * 0.6, // mobile
                    MediaQuery.of(context).size.height * 0.5, // tablet
                    MediaQuery.of(context).size.height * 0.4, // desktop
                    MediaQuery.of(context).size.height * 0.35, // desktop large
                  ]),
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.lg,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.pressed,
                      ),
                      blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
                      offset: EcoPlatesDesignTokens.elevation.standardOffset,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.lg,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: context.scaleSM_MD_LG_XL,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre du menu
                        Padding(
                          padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
                          child: Text(
                            'Catégories',
                            style: TextStyle(
                              fontSize: EcoPlatesDesignTokens.typography
                                  .modalTitle(context),
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
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
                                  horizontal: context.scaleMD_LG_XL_XXL,
                                  vertical: context.scaleXS_SM_MD_LG,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? color.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  border: isSelected
                                      ? Border(
                                          left: BorderSide(
                                            color: color,
                                            width: EcoPlatesDesignTokens
                                                .layout
                                                .cardBorderWidth,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width:
                                          EcoPlatesDesignTokens.size.icon(
                                            context,
                                          ) *
                                          EcoPlatesDesignTokens
                                              .size
                                              .largeIconMultiplier,
                                      height:
                                          EcoPlatesDesignTokens.size.icon(
                                            context,
                                          ) *
                                          EcoPlatesDesignTokens
                                              .size
                                              .largeIconMultiplier,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? color.withValues(
                                                alpha: EcoPlatesDesignTokens
                                                    .opacity
                                                    .pressed,
                                              )
                                            : color.withValues(
                                                alpha: EcoPlatesDesignTokens
                                                    .opacity
                                                    .veryTransparent,
                                              ),
                                        borderRadius: BorderRadius.circular(
                                          EcoPlatesDesignTokens.radius.xs,
                                        ),
                                      ),
                                      child: Icon(
                                        c.icon,
                                        size: EcoPlatesDesignTokens.size.icon(
                                          context,
                                        ),
                                        color: isSelected
                                            ? color
                                            : color.withValues(
                                                alpha: EcoPlatesDesignTokens
                                                    .opacity
                                                    .almostOpaque,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: context.scaleXS_SM_MD_LG),
                                    Expanded(
                                      child: Text(
                                        c.label,
                                        style: TextStyle(
                                          fontSize: EcoPlatesDesignTokens
                                              .typography
                                              .modalContent(context),
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isSelected
                                              ? color
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        size: EcoPlatesDesignTokens.size.icon(
                                          context,
                                        ),
                                        color: color,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: context.scaleSM_MD_LG_XL),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Bouton flottant principal
        FloatingActionButton.small(
          onPressed: _toggleMenu,
          backgroundColor: theme.colorScheme.primary,
          elevation: EcoPlatesDesignTokens.elevation.card,
          highlightElevation: EcoPlatesDesignTokens.elevation.modal,
          tooltip: _isOpen ? 'Fermer' : 'Filtrer par catégorie',
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              _isOpen ? Icons.close : Icons.category,
              color: theme.colorScheme.onPrimary,
              size: context.scaleIconStandard,
            ),
          ),
        ),
      ],
    );
  }
}
