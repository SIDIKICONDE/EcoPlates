import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/brand.dart';

/// Provider pour récupérer toutes les marques/enseignes
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  // TODO: Implémenter le service des marques
  // Pour l'instant, retourner des données de test
  return [
    Brand(
      id: '1',
      name: 'Carrefour',
      logoUrl: 'https://example.com/carrefour.png',
      category: 'Supermarché',
      totalStores: 1200,
      activeOffers: 45,
      averageDiscount: 25.0,
      description: 'Grande enseigne de distribution',
      primaryColor: '#0066CC',
    ),
    Brand(
      id: '2',
      name: 'Monoprix',
      logoUrl: 'https://example.com/monoprix.png',
      category: 'Supermarché',
      totalStores: 800,
      activeOffers: 32,
      averageDiscount: 20.0,
      description: 'Supermarché urbain',
      primaryColor: '#FF6B35',
    ),
    Brand(
      id: '3',
      name: 'Franprix',
      logoUrl: 'https://example.com/franprix.png',
      category: 'Supermarché',
      totalStores: 600,
      activeOffers: 28,
      averageDiscount: 18.0,
      description: 'Proximité et qualité',
      primaryColor: '#2E8B57',
    ),
  ];
});
