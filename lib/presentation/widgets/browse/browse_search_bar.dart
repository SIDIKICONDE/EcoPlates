import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/context_responsive_extensions.dart';
import '../../../core/services/map_service.dart';
import '../../providers/browse_search_provider.dart';

/// Barre de recherche pour la page Parcourir
class BrowseSearchBar extends ConsumerStatefulWidget {
  const BrowseSearchBar({super.key, this.onFilterTap, this.onLocationTap});

  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;

  @override
  ConsumerState<BrowseSearchBar> createState() => _BrowseSearchBarState();
}

class _BrowseSearchBarState extends ConsumerState<BrowseSearchBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(browseFiltersProvider);
    final isLocationActive = ref.watch(isLocationActiveProvider);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
      child: Row(
        children: [
          // Champ de recherche
          Expanded(
            child: Container(
              height: EcoPlatesDesignTokens.size.buttonHeight(context),
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                border: Border.all(
                  color: Colors.grey[300]!.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.disabled,
                  ),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).update(value);
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: context.scaleIconStandard,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: context.scaleLG_XL_XXL_XXXL,
                    minHeight: context.scaleSM_MD_LG_XL,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.scaleXXS_XS_SM_MD,
                    vertical: context.scaleXXS_XS_SM_MD,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Bouton GPS
          Container(
            height: EcoPlatesDesignTokens.size.buttonHeight(context),
            width: EcoPlatesDesignTokens.size.buttonHeight(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.md,
              ),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();

                  // Activer automatiquement la localisation si elle n'est pas activée
                  final isLocationActive = ref.read(isLocationActiveProvider);
                  if (!isLocationActive) {
                    ref
                        .read(isLocationActiveProvider.notifier)
                        .set(value: true);
                  }

                  try {
                    // Centrer automatiquement sur la position utilisateur
                    await MapService().centerOnUserLocation();
                  } on Exception {
                    // Ne rien afficher en cas d'erreur de localisation
                  }

                  widget.onLocationTap?.call();
                },
                child: Icon(
                  isLocationActive ? Icons.near_me : Icons.near_me_outlined,
                  color: isLocationActive
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSurface.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                        ),
                  size: context.scaleIconStandard,
                ),
              ),
            ),
          ),

          SizedBox(width: context.scaleXXS_XS_SM_MD),

          // Bouton Filtres avec badge
          Container(
            height: EcoPlatesDesignTokens.size.buttonHeight(context),
            width: EcoPlatesDesignTokens.size.buttonHeight(context),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.md,
              ),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onFilterTap?.call();
                },
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        filters.hasActiveFilters
                            ? Icons.tune
                            : Icons.tune_outlined,
                        color: filters.hasActiveFilters
                            ? Theme.of(context).primaryColor
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(
                                alpha: EcoPlatesDesignTokens
                                    .opacity
                                    .gradientPrimary,
                              ),
                        size: context.scaleIconStandard,
                      ),
                    ),
                    if (filters.activeFiltersCount > 0)
                      Positioned(
                        top: context.scaleXXS_XS_SM_MD,
                        right: context.scaleXXS_XS_SM_MD,
                        child: Container(
                          width: context.scaleSM_MD_LG_XL,
                          height: context.scaleSM_MD_LG_XL,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${filters.activeFiltersCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: context.scaleXXS_XS_SM_MD,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
