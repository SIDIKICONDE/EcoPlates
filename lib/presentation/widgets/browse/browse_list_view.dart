import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/food_offer.dart';
import '../../providers/browse_search_provider.dart';
import '../list_offer_card.dart';

/// Vue liste des offres pour la page Parcourir
class BrowseListView extends ConsumerWidget {
  const BrowseListView({
    required this.offers,
    super.key,
  });

  final List<FoodOffer> offers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final filters = ref.watch(browseFiltersProvider);
    
    // Filtrer les offres selon la recherche et les filtres
    final filteredOffers = _filterOffers(offers, searchQuery, filters);
    
    if (filteredOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune offre trouvée',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Modifiez vos critères de recherche',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredOffers.length,
      itemBuilder: (context, index) {
        final offer = filteredOffers[index];
        
        return ListOfferCard(
          offer: offer,
          distance: offer.distanceKm ?? 0.5,
          onTap: () {
            // TODO(browse): Navigation vers le détail de l'offre
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Détails de: ${offer.title}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
  
  List<FoodOffer> _filterOffers(
    List<FoodOffer> offers, 
    String searchQuery, 
    BrowseFilters filters,
  ) {
    return offers.where((offer) {
      // Filtre par recherche
      if (searchQuery.isNotEmpty) {
        final matchesSearch = 
            offer.title.toLowerCase().contains(searchQuery) ||
            offer.merchantName.toLowerCase().contains(searchQuery) ||
            offer.description.toLowerCase().contains(searchQuery);
        
        if (!matchesSearch) return false;
      }
      
      // Filtre par prix
      if (filters.minPrice != null && offer.discountedPrice < filters.minPrice!) {
        return false;
      }
      if (filters.maxPrice != null && offer.discountedPrice > filters.maxPrice!) {
        return false;
      }
      
      // Filtre par catégories
      if (filters.categories.isNotEmpty) {
        if (!filters.categories.contains(offer.category.name)) {
          return false;
        }
      }
      
      // Filtre par préférences alimentaires
      if (filters.dietaryPreferences.isNotEmpty) {
        var matchesDiet = false;
        if (filters.dietaryPreferences.contains('vegetarian') && offer.isVegetarian) {
          matchesDiet = true;
        }
        if (filters.dietaryPreferences.contains('vegan') && offer.isVegan) {
          matchesDiet = true;
        }
        if (filters.dietaryPreferences.contains('halal') && offer.isHalal) {
          matchesDiet = true;
        }
        if (!matchesDiet) return false;
      }
      
      // Filtre disponible maintenant
      if (filters.availableNow) {
        if (!offer.canPickup) return false;
      }
      
      // Filtre gratuit uniquement
      if (filters.freeOnly) {
        if (!offer.isFree) return false;
      }
      
      // Filtre par distance
      if (filters.maxDistance != null && offer.distanceKm != null) {
        if (offer.distanceKm! > filters.maxDistance!) {
          return false;
        }
      }
      
      return true;
    }).toList();
  }
}
