import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/brand.dart';

/// Provider pour récupérer les grandes enseignes partenaires
final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  // Simuler un appel API
  await Future.delayed(const Duration(milliseconds: 800));

  // Données de démonstration des grandes enseignes
  return [
    Brand(
      id: '1',
      name: 'Carrefour',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/fr/thumb/3/3b/Logo_Carrefour.svg/1200px-Logo_Carrefour.svg.png',
      category: 'Supermarché',
      totalStores: 1250,
      activeOffers: 87,
      averageDiscount: 45,
      description: 'Leader de la grande distribution en France',
      isPremium: true,
      tagline: 'Tout sous le même toit',
      primaryColor: '#004E9B',
      backgroundColor: '#E8F4FF',
      tags: ['Alimentaire', 'Non-alimentaire', 'Bio'],
      partnerSince: DateTime(2023, 1, 15),
    ),
    Brand(
      id: '2',
      name: 'Paul',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/PAUL-bakery-logo.svg/1200px-PAUL-bakery-logo.svg.png',
      category: 'Boulangerie',
      totalStores: 450,
      activeOffers: 34,
      averageDiscount: 50,
      description: 'Boulangerie française depuis 1889',
      isPremium: true,
      tagline: 'L\'amour du bon pain',
      primaryColor: '#8B4513',
      backgroundColor: '#FFF8E7',
      tags: ['Boulangerie', 'Pâtisserie', 'Tradition'],
    ),
    Brand(
      id: '3',
      name: 'Starbucks',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/en/thumb/d/d3/Starbucks_Corporation_Logo_2011.svg/1200px-Starbucks_Corporation_Logo_2011.svg.png',
      category: 'Café',
      totalStores: 320,
      activeOffers: 28,
      averageDiscount: 40,
      description: 'Chaîne de cafés internationale',
      isPremium: true,
      tagline: 'Inspiring and nurturing the human spirit',
      primaryColor: '#00704A',
      backgroundColor: '#E8F5E9',
      tags: ['Café', 'Boissons', 'Snacks'],
    ),
    Brand(
      id: '4',
      name: 'Monoprix',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Monoprix_Logo.svg/1200px-Monoprix_Logo.svg.png',
      category: 'Supermarché',
      totalStores: 800,
      activeOffers: 65,
      averageDiscount: 35,
      description: 'Enseigne de centre-ville premium',
      tagline: 'La ville est belle',
      primaryColor: '#E2001A',
      backgroundColor: '#FFE5E5',
      tags: ['Premium', 'Centre-ville', 'Mode'],
    ),
    Brand(
      id: '5',
      name: 'Brioche Dorée',
      logoUrl:
          'https://www.briochedoree.fr/wp-content/uploads/2021/03/logo-brioche-doree.png',
      category: 'Boulangerie',
      totalStores: 280,
      activeOffers: 22,
      averageDiscount: 55,
      description: 'Sandwicherie et viennoiseries',
      isNew: true,
      tagline: 'Le plaisir à partager',
      primaryColor: '#FFA500',
      backgroundColor: '#FFF5E6',
      tags: ['Sandwicherie', 'Viennoiseries', 'Rapide'],
    ),
    Brand(
      id: '6',
      name: 'Franprix',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Franprix_logo_2016.svg/1200px-Franprix_logo_2016.svg.png',
      category: 'Supermarché',
      totalStores: 950,
      activeOffers: 71,
      averageDiscount: 40,
      description: 'Supermarché de proximité',
      tagline: 'Vive la proximité',
      primaryColor: '#FF6B35',
      backgroundColor: '#FFF0E8',
      tags: ['Proximité', 'Urbain', 'Pratique'],
    ),
    Brand(
      id: '7',
      name: 'Sushi Shop',
      logoUrl: 'https://www.sushishop.fr/img/logo-sushishop.png',
      category: 'Restaurant',
      totalStores: 165,
      activeOffers: 18,
      averageDiscount: 45,
      description: 'Leader du sushi en France',
      isPremium: true,
      isNew: true,
      tagline: 'L\'art du sushi',
      primaryColor: '#000000',
      backgroundColor: '#F5F5F5',
      tags: ['Japonais', 'Sushi', 'Premium'],
    ),
    Brand(
      id: '8',
      name: 'Auchan',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Auchan_Logo.svg/1200px-Auchan_Logo.svg.png',
      category: 'Hypermarché',
      totalStores: 640,
      activeOffers: 93,
      averageDiscount: 50,
      description: 'Hypermarché et drive',
      tagline: 'La vie, la vraie',
      primaryColor: '#E73125',
      backgroundColor: '#FFE8E6',
      tags: ['Hypermarché', 'Drive', 'Famille'],
    ),
    Brand(
      id: '9',
      name: 'Picard',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Picard_logo.svg/1200px-Picard_logo.svg.png',
      category: 'Surgelés',
      totalStores: 1050,
      activeOffers: 45,
      averageDiscount: 30,
      description: 'Spécialiste des surgelés',
      tagline: 'Les surgelés, c\'est Picard',
      primaryColor: '#0072BB',
      backgroundColor: '#E6F3FF',
      tags: ['Surgelés', 'Qualité', 'Innovation'],
    ),
    Brand(
      id: '10',
      name: 'Casino',
      logoUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Groupe_Casino_logo.svg/1200px-Groupe_Casino_logo.svg.png',
      category: 'Supermarché',
      totalStores: 750,
      activeOffers: 58,
      averageDiscount: 42,
      description: 'Groupe de distribution français',
      tagline: 'Nourrir un monde de diversité',
      primaryColor: '#00A650',
      backgroundColor: '#E6F7ED',
      tags: ['Distribution', 'Proximité', 'Services'],
    ),
  ];
});

/// Provider pour les grandes enseignes premium uniquement
final premiumBrandsProvider = FutureProvider<List<Brand>>((ref) async {
  final allBrands = await ref.watch(brandsProvider.future);
  return allBrands.where((brand) => brand.isPremium).toList();
});

/// Provider pour les nouvelles grandes enseignes
final newBrandsProvider = FutureProvider<List<Brand>>((ref) async {
  final allBrands = await ref.watch(brandsProvider.future);
  return allBrands.where((brand) => brand.isNew).toList();
});

/// Provider pour obtenir une enseigne spécifique par ID
final brandByIdProvider = Provider.family<Brand?, String>((ref, id) {
  final brandsAsync = ref.watch(brandsProvider);
  return brandsAsync.when(
    data: (brands) => brands.firstWhere(
      (b) => b.id == id,
      orElse: () => throw Exception('Enseigne non trouvée'),
    ),
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider pour les statistiques des grandes enseignes
final brandsStatsProvider = Provider<BrandsStats>((ref) {
  final brandsAsync = ref.watch(brandsProvider);

  return brandsAsync.when(
    data: (brands) {
      final totalBrands = brands.length;
      final totalOffers = brands.fold<int>(0, (sum, b) => sum + b.activeOffers);
      final averageDiscount =
          brands.fold<double>(0, (sum, b) => sum + b.averageDiscount) /
          brands.length;
      final totalStores = brands.fold<int>(0, (sum, b) => sum + b.totalStores);

      return BrandsStats(
        totalBrands: totalBrands,
        totalOffers: totalOffers,
        averageDiscount: averageDiscount,
        totalStores: totalStores,
      );
    },
    loading: () => BrandsStats.empty(),
    error: (_, __) => BrandsStats.empty(),
  );
});

class BrandsStats {
  final int totalBrands;
  final int totalOffers;
  final double averageDiscount;
  final int totalStores;

  BrandsStats({
    required this.totalBrands,
    required this.totalOffers,
    required this.averageDiscount,
    required this.totalStores,
  });

  factory BrandsStats.empty() => BrandsStats(
    totalBrands: 0,
    totalOffers: 0,
    averageDiscount: 0,
    totalStores: 0,
  );
}
