import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: const Text('Offres recommandées'),
        centerTitle: false,
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
        itemSpacing: 12.0,
        showDetailModal: true,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12.0),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(
              32.0,
            ),
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
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),

                // Filtres par catégorie
                Text(
                  'Catégorie',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: [
                    FilterChip(
                      label: const Text('Boulangerie'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Fruits & Légumes'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Plats préparés'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Snacks'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: 12.0,
                ),

                // Filtres par régime
                Text(
                  'Régime alimentaire',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: [
                    FilterChip(
                      label: const Text('Végétarien'),
                      avatar: Icon(
                        Icons.eco,
                        size: 12.0,
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Vegan'),
                      avatar: Icon(
                        Icons.spa,
                        size: 12.0,
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('Sans gluten'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: 12.0,
                ),

                // Filtres par prix
                Text('Prix', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: 8.0,
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: [
                    FilterChip(
                      label: const Text('Gratuit'),
                      avatar: Icon(
                        Icons.star,
                        size: 12.0,
                      ),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 5€'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('5€ - 10€'),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('> 10€'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                SizedBox(
                  height: 32.0,
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
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
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
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
