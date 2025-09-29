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
          padding: EdgeInsets.fromLTRB(
            16.0,
            12.0,
            16.0,
            16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vos favoris',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Aller à l’onglet Favoris via GoRouter (reste dans le shell)
                  context.go(RouteConstants.consumerFavorites);
                },
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: favorites.isEmpty ? 80.0 : 152.0,
          child: favorites.isEmpty
              ? Center(
                  child: Text(
                    'Aucun favori pour l’instant',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final merchant = favorites[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 140.0,
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

        SizedBox(height: 16.0),
      ],
    );
  }
}
