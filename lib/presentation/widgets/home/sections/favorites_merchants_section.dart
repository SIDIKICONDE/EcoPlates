import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes/route_constants.dart';
import '../../../providers/merchants_provider.dart';
import '../../favorite_merchant_card.dart';

/// Section affichant un slider des commerçants favoris de l'utilisateur
class FavoritesMerchantsSection extends ConsumerWidget {
  const FavoritesMerchantsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteMerchantsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vos favoris',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (favorites.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // Aller à l’onglet Favoris via GoRouter (reste dans le shell)
                    context.go(RouteConstants.consumerFavorites);
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
        ),

        SizedBox(
          height: favorites.isEmpty ? 80 : 152,
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Aucun favori pour l’instant',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final merchant = favorites[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 320,
                        child: FavoriteMerchantCard(
                          merchant: merchant,
                          onTap: () {
                            // TODO: Navigation vers le détail du commerçant
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
