import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/router/routes/route_constants.dart';
import '../../providers/browse_view_provider.dart';
import '../../providers/location_state_provider.dart';
import '../../providers/user_location_text_provider.dart';

/// Widget d'en-tête affichant la localisation actuelle de l'utilisateur
class LocationHeader extends ConsumerStatefulWidget {
  const LocationHeader({
    super.key,
    this.onTap,
    this.showIcon = true,
    this.style,
  });

  final VoidCallback? onTap;
  final bool showIcon;
  final TextStyle? style;

  @override
  ConsumerState<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends ConsumerState<LocationHeader> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);
    final locationText = ref.watch(userLocationTextProvider);
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap ?? () => _handleTap(context),
      onLongPress: () => _showOptionsMenu(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isPressed
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            EcoPlatesDesignTokens.radius.md,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleMD_LG_XL_XXL,
            vertical: context.scaleXS_SM_MD_LG,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showIcon) ...[
                Icon(
                  locationState.isActive
                      ? Icons.location_on
                      : Icons.location_off,
                  size: context.scaleIconStandard,
                  color: locationState.isActive
                      ? theme.primaryColor
                      : Colors.grey,
                ),
                SizedBox(width: context.scaleSM_MD_LG_XL),
              ],

              Flexible(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: locationText.isLoading
                      ? _buildLoadingState()
                      : Text(
                          locationText.address,
                          key: ValueKey(locationText.address),
                          style:
                              widget.style ??
                              theme.textTheme.titleMedium?.copyWith(
                                fontWeight:
                                    EcoPlatesDesignTokens.typography.semiBold,
                                color: locationState.isActive
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withValues(
                                        alpha: EcoPlatesDesignTokens
                                            .opacity
                                            .almostOpaque,
                                      ),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),

              SizedBox(width: context.scaleSM_MD_LG_XL),
              Text(
                'emplacement choisi',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
                  fontWeight: EcoPlatesDesignTokens.typography.regular,
                ),
              ),

              SizedBox(width: context.scaleXXS_XS_SM_MD),
              Icon(
                Icons.arrow_drop_down,
                size: context.scaleIconStandard,
                color: Theme.of(context).colorScheme.onSurface.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.scaleSM_MD_LG_XL,
          height: context.scaleSM_MD_LG_XL,
          child: CircularProgressIndicator(
            strokeWidth: DesignConstants.two,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
              ),
            ),
          ),
        ),
        SizedBox(width: context.scaleSM_MD_LG_XL),
        Text(
          'Recherche...',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            fontWeight: EcoPlatesDesignTokens.typography.medium,
          ),
        ),
      ],
    );
  }

  void _handleTap(BuildContext context) {
    final locationState = ref.read(locationStateProvider);

    if (!locationState.isActive) {
      // Activer la localisation
      unawaited(ref.read(locationStateProvider.notifier).toggleLocation());
    } else {
      // Ouvrir la page Browse avec la vue carte
      ref.read(browseViewModeProvider.notifier).setMode(BrowseViewMode.map);

      // Naviguer vers la page Parcourir via GoRouter (met à jour l'onglet)
      context.go(RouteConstants.consumerBrowse);
    }
  }

  void _showOptionsMenu(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const LocationOptionsSheet(),
      ),
    );
  }
}

/// Bottom sheet avec les options de localisation
class LocationOptionsSheet extends ConsumerWidget {
  const LocationOptionsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationText = ref.watch(userLocationTextProvider);
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.radius.xxl,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              margin: EdgeInsets.only(top: context.scaleMD_LG_XL_XXL),
              width: context.scaleLG_XL_XXL_XXXL,
              height: DesignConstants.four,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  DesignConstants.two,
                ),
              ),
            ),

            SizedBox(height: context.scaleLG_XL_XXL_XXXL),

            // Titre
            Text(
              'Localisation',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: context.scaleXS_SM_MD_LG),

            // Adresse actuelle
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleLG_XL_XXL_XXXL,
              ),
              child: Text(
                locationText.address,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: context.scaleLG_XL_XXL_XXXL * 1.5),

            // Options
            _buildOption(
              context: context,
              icon: Icons.map,
              title: 'Voir sur la carte',
              onTap: () {
                // Fermer le bottom sheet
                Navigator.pop(context);

                // Ouvrir la page Browse avec la vue carte
                ref
                    .read(browseViewModeProvider.notifier)
                    .setMode(BrowseViewMode.map);

                // Naviguer vers la page Parcourir via GoRouter
                context.go(RouteConstants.consumerBrowse);
              },
            ),

            _buildOption(
              context: context,
              icon: Icons.refresh,
              title: 'Actualiser la position',
              onTap: () {
                unawaited(
                  ref.read(userLocationTextProvider.notifier).refreshAddress(),
                );
                Navigator.pop(context);
              },
            ),

            _buildOption(
              context: context,
              icon: Icons.map_outlined,
              title: 'Changer de lieu',
              subtitle: 'Bientôt disponible',
              enabled: false,
              onTap: () {
                // TODO: Implémenter la sélection manuelle de lieu
              },
            ),

            _buildOption(
              context: context,
              icon: Icons.location_off,
              title: 'Désactiver la localisation',
              onTap: () {
                unawaited(
                  ref.read(locationStateProvider.notifier).toggleLocation(),
                );
                Navigator.pop(context);
              },
            ),

            SizedBox(height: context.scaleXS_SM_MD_LG),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaleLG_XL_XXL_XXXL,
            vertical: context.scaleMD_LG_XL_XXL,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                      )
                    : Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                      ),
                size: context.scaleLG_XL_XXL_XXXL,
              ),
              SizedBox(width: context.scaleMD_LG_XL_XXL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalContent(
                          context,
                        ),
                        fontWeight: EcoPlatesDesignTokens.typography.medium,
                        color: enabled
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(
                                alpha: EcoPlatesDesignTokens
                                    .opacity
                                    .veryTransparent,
                              ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: context.scaleXXS_XS_SM_MD),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: EcoPlatesDesignTokens.typography.hint(
                            context,
                          ),
                          color: Theme.of(context).colorScheme.onSurface
                              .withValues(
                                alpha:
                                    EcoPlatesDesignTokens.opacity.almostOpaque,
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
