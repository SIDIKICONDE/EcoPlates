import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          color: _isPressed ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showIcon) ...[
                Icon(
                  locationState.isActive
                      ? Icons.location_on
                      : Icons.location_off,
                  size: 20,
                  color: locationState.isActive
                      ? theme.primaryColor
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
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
                                    ? Colors.black87
                                    : Colors.grey[600],
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),

              const SizedBox(width: 8),
              Text(
                'emplacement choisi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey[600]),
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
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Recherche...',
          style: TextStyle(
            color: Colors.grey[600],
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
      ref.read(locationStateProvider.notifier).toggleLocation();
    } else {
      // Ouvrir la page Browse avec la vue carte
      ref.read(browseViewModeProvider.notifier).state = BrowseViewMode.map;

      // Naviguer vers la page Parcourir via GoRouter (met à jour l'onglet)
      context.go(RouteConstants.consumerBrowse);
    }
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const LocationOptionsSheet(),
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
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Titre
            Text(
              'Localisation',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Adresse actuelle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                locationText.address,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Options
            _buildOption(
              context: context,
              icon: Icons.map,
              title: 'Voir sur la carte',
              onTap: () {
                // Fermer le bottom sheet
                Navigator.pop(context);

                // Ouvrir la page Browse avec la vue carte
                ref.read(browseViewModeProvider.notifier).state =
                    BrowseViewMode.map;

                // Naviguer vers la page Parcourir via GoRouter
                context.go(RouteConstants.consumerBrowse);
              },
            ),

            _buildOption(
              context: context,
              icon: Icons.refresh,
              title: 'Actualiser la position',
              onTap: () {
                ref.read(userLocationTextProvider.notifier).refreshAddress();
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
                ref.read(locationStateProvider.notifier).toggleLocation();
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 8),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: enabled ? Colors.grey[700] : Colors.grey[400],
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: enabled ? Colors.black87 : Colors.grey[400],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
