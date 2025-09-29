import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../providers/recommended_offers_provider.dart';
import '../widgets/common/offers_list_view.dart';

/// Page affichant toutes les offres recommandées
class AllRecommendedOffersScreen extends ConsumerWidget {
  const AllRecommendedOffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(recommendedOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offres recommandées',
          style: TextStyle(
            fontSize: FontSizes.subtitleLarge.getSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        toolbarHeight: context.appBarHeight,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Afficher les options de filtrage
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: OffersListView(
        offers: offers,
        emptyStateSubtitle:
            'Revenez plus tard pour découvrir\nde nouvelles offres anti-gaspi',
        enableRefresh: true,
        onRefresh: () async {
          ref.invalidate(recommendedOffersProvider);
        },
        compactCards: true,
        itemSpacing: context.verticalSpacing,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.borderRadius),
          ),
        ),
        builder: (context) {
          return Container(
            padding: context.responsivePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrer les offres',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizes.titleMedium.getSize(context),
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
                SizedBox(
                  height: context.verticalSpacing,
                ),

                // Filtres par catégorie
                Text(
                  'Catégorie',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontSizes.subtitleMedium.getSize(context),
                  ),
                ),
                SizedBox(
                  height: context.verticalSpacing / 2,
                ),
                Wrap(
                  spacing: context.horizontalSpacing / 2,
                  runSpacing: context.verticalSpacing / 2,
                  children: [
                    FilterChip(
                      label: Text(
                        'Boulangerie',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        'Fruits & Légumes',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        'Plats préparés',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        'Snacks',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: context.verticalSpacing,
                ),

                // Filtres par régime
                Text(
                  'Régime alimentaire',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontSizes.subtitleMedium.getSize(context),
                  ),
                ),
                SizedBox(
                  height: context.verticalSpacing / 2,
                ),
                Wrap(
                  spacing: context.horizontalSpacing / 2,
                  runSpacing: context.verticalSpacing / 2,
                  children: [
                    FilterChip(
                      label: Text(
                        'Végétarien',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      avatar: Icon(
                        Icons.eco,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 16.0,
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        'Vegan',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      avatar: Icon(
                        Icons.spa,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 16.0,
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        'Sans gluten',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: context.verticalSpacing,
                ),

                // Filtres par prix
                Text(
                  'Prix',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: FontSizes.subtitleMedium.getSize(context),
                  ),
                ),
                SizedBox(
                  height: context.verticalSpacing / 2,
                ),
                Wrap(
                  spacing: context.horizontalSpacing / 2,
                  runSpacing: context.verticalSpacing / 2,
                  children: [
                    FilterChip(
                      label: Text(
                        'Gratuit',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      avatar: Icon(
                        Icons.star,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 16.0,
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        '< 5€',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        '5€ - 10€',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        '> 10€',
                        style: TextStyle(
                          fontSize: FontSizes.bodySmall.getSize(context),
                        ),
                      ),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: context.verticalSpacing * 2,
                ),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Réinitialiser les filtres
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Réinitialiser',
                          style: TextStyle(
                            fontSize: FontSizes.buttonMedium.getSize(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.horizontalSpacing / 2,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Appliquer les filtres
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filtres appliqués'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
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
                SizedBox(
                  height: context.verticalSpacing / 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
