import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes/route_constants.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
              ? DeepColorTokens.surfaceElevated
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showIcon) ...[
                Icon(
                  locationState.isActive
                      ? Icons.location_on
                      : Icons.location_off,
                  size: 20.0,
                  color: locationState.isActive
                      ? DeepColorTokens.primary
                      : DeepColorTokens.neutral900.withValues(alpha: 0.5),
                ),
                SizedBox(width: 12.0),
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
                                fontWeight: FontWeight.w600,
                                color: locationState.isActive
                                    ? DeepColorTokens.neutral900
                                    : DeepColorTokens.neutral900.withValues(
                                        alpha: 0.8,
                                      ),
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),

              SizedBox(width: 12.0),
              Text(
                'emplacement choisi',
                style: TextStyle(
                  fontSize: 14.0,
                  color: DeepColorTokens.neutral900.withValues(
                    alpha: 0.6,
                  ),
                  fontWeight: FontWeight.normal,
                ),
              ),

              SizedBox(width: 8.0),
              Icon(
                Icons.arrow_drop_down,
                size: 20.0,
                color: DeepColorTokens.neutral900.withValues(
                  alpha: 0.6,
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
          width: 12.0,
          height: 12.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              DeepColorTokens.neutral900.withValues(
                alpha: 0.6,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.0),
        Text(
          'Recherche...',
          style: TextStyle(
            color: DeepColorTokens.neutral900.withValues(
              alpha: 0.6,
            ),
            fontWeight: FontWeight.w500,
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
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral400.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),

            const SizedBox(height: 16.0),

            // Titre
            Text(
              'Localisation',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8.0),

            // Adresse actuelle
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Text(
                locationText.address,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 24.0 * 1.5),

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

            SizedBox(height: 8.0),
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
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: enabled
                    ? DeepColorTokens.neutral900.withValues(
                        alpha: 0.8,
                      )
                    : DeepColorTokens.neutral900.withValues(
                        alpha: 0.6,
                      ),
                size: 24.0,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: enabled
                            ? DeepColorTokens.neutral900
                            : DeepColorTokens.neutral900.withValues(
                                alpha: 0.6,
                              ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 8.0),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: DeepColorTokens.neutral900.withValues(
                            alpha: 0.6,
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
