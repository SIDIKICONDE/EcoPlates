import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/sort_options.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../providers/sort_provider.dart';

/// Bottom sheet de tri pour les offres urgentes
class UrgentOffersSortBottomSheet extends ConsumerWidget {
  const UrgentOffersSortBottomSheet({super.key});

  static void show(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.borderRadius * 1.5),
          ),
        ),
        builder: (context) => const UrgentOffersSortBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      padding: context.responsivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trier par',
            style: TextStyle(
              color: DeepColorTokens.neutral800,
              fontWeight: FontWeight.bold,
              fontSize: FontSizes.bodyLarge.getSize(context),
            ),
          ),
          SizedBox(height: context.verticalSpacing),

          // Options de tri spécifiques aux offres urgentes
          _buildSortOption(
            context: context,
            ref: ref,
            option: SortOption.urgency,
            currentSort: currentSort,
            subtitle: 'Offres qui expirent bientôt',
            color: DeepColorTokens.error,
          ),
          _buildSortOption(
            context: context,
            ref: ref,
            option: SortOption.distance,
            currentSort: currentSort,
            subtitle: 'Distance la plus courte',
            color: DeepColorTokens.primary,
          ),
          _buildSortOption(
            context: context,
            ref: ref,
            option: SortOption.priceLow,
            currentSort: currentSort,
            subtitle: 'Meilleures affaires',
            color: DeepColorTokens.success,
          ),
          _buildSortOption(
            context: context,
            ref: ref,
            option: SortOption.relevance,
            currentSort: currentSort,
            subtitle: 'Derniers articles disponibles',
            color: DeepColorTokens.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required WidgetRef ref,
    required SortOption option,
    required SortOption currentSort,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = currentSort == option;

    return ListTile(
      leading: Icon(
        option.icon,
        color: color,
        size: ResponsiveUtils.getIconSize(context),
      ),
      title: Text(
        option.label,
        style: TextStyle(
          fontSize: FontSizes.bodyLarge.getSize(context),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: FontSizes.bodySmall.getSize(context),
        ),
      ),
      onTap: () {
        ref.read(sortOptionProvider.notifier).setSortOption(option);
        Navigator.pop(context);
      },
      selected: isSelected,
      selectedTileColor: color.withValues(alpha: 0.1),
    );
  }
}

/// Bottom sheet de filtrage pour les offres urgentes
class UrgentOffersFilterBottomSheet extends StatefulWidget {
  const UrgentOffersFilterBottomSheet({super.key});

  static void show(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.borderRadius * 1.5),
          ),
        ),
        isScrollControlled: true,
        builder: (context) => const UrgentOffersFilterBottomSheet(),
      ),
    );
  }

  @override
  State<UrgentOffersFilterBottomSheet> createState() =>
      _UrgentOffersFilterBottomSheetState();
}

class _UrgentOffersFilterBottomSheetState
    extends State<UrgentOffersFilterBottomSheet> {
  // État des filtres - à connecter avec un provider plus tard
  final Set<String> _selectedTimeFilters = {};
  final Set<String> _selectedQuantityFilters = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Filtrer les offres urgentes',
                  style: TextStyle(
                    color: DeepColorTokens.neutral800,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSizes.bodyLarge.getSize(context),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: ResponsiveUtils.getIconSize(context),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: context.verticalSpacing),

          // Filtre par temps restant
          Text(
            'Temps restant',
            style: TextStyle(
              color: DeepColorTokens.neutral700,
              fontSize: FontSizes.bodyMedium.getSize(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.verticalSpacing / 2),
          Wrap(
            spacing: context.horizontalSpacing / 2,
            runSpacing: context.verticalSpacing / 2,
            children: [
              _buildTimeFilterChip('< 30 min', 'urgent', DeepColorTokens.error),
              _buildTimeFilterChip('< 1h', 'hour', DeepColorTokens.warning),
              _buildTimeFilterChip('< 2h', 'two_hours', DeepColorTokens.accent),
            ],
          ),

          SizedBox(height: context.verticalSpacing),

          // Filtre par quantité
          Text(
            'Quantité disponible',
            style: TextStyle(
              color: DeepColorTokens.neutral700,
              fontSize: FontSizes.bodyMedium.getSize(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: context.verticalSpacing / 2),
          Wrap(
            spacing: context.horizontalSpacing / 2,
            runSpacing: context.verticalSpacing / 2,
            children: [
              _buildQuantityFilterChip('Dernier article', 'last_one'),
              _buildQuantityFilterChip('< 3 restants', 'low_stock'),
              _buildQuantityFilterChip('< 5 restants', 'medium_stock'),
            ],
          ),

          SizedBox(height: context.verticalSpacing * 2),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTimeFilters.clear();
                      _selectedQuantityFilters.clear();
                    });
                  },
                  child: Text(
                    'Réinitialiser',
                    style: TextStyle(
                      fontSize: FontSizes.buttonMedium.getSize(context),
                    ),
                  ),
                ),
              ),
              SizedBox(width: context.horizontalSpacing / 2),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Filtres appliqués',
                          style: TextStyle(
                            fontSize: FontSizes.bodyMedium.getSize(context),
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DeepColorTokens.error,
                  ),
                  child: Text(
                    'Appliquer',
                    style: TextStyle(
                      fontSize: FontSizes.buttonMedium.getSize(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.verticalSpacing / 2),
        ],
      ),
    );
  }

  Widget _buildTimeFilterChip(String label, String filterKey, Color color) {
    final isSelected = _selectedTimeFilters.contains(filterKey);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: FontSizes.bodySmall.getSize(context),
        ),
      ),
      avatar: Icon(
        Icons.warning,
        size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      selectedColor: color.withValues(alpha: 0.3),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTimeFilters.add(filterKey);
          } else {
            _selectedTimeFilters.remove(filterKey);
          }
        });
      },
    );
  }

  Widget _buildQuantityFilterChip(String label, String filterKey) {
    final isSelected = _selectedQuantityFilters.contains(filterKey);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: FontSizes.bodySmall.getSize(context),
        ),
      ),
      avatar: Icon(
        Icons.inventory_2,
        size: ResponsiveUtils.getIconSize(context, baseSize: 16.0),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedQuantityFilters.add(filterKey);
          } else {
            _selectedQuantityFilters.remove(filterKey);
          }
        });
      },
    );
  }
}
