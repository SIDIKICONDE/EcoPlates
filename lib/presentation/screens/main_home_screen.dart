import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/home/sections/brand_section.dart';
import '../widgets/home/sections/categories_section.dart';
import '../widgets/home/sections/meals_section.dart';
import '../widgets/home/sections/merchant_section.dart';
import '../widgets/home/sections/nearby_section.dart';
import '../widgets/home/sections/recommended_section.dart';
import '../widgets/home/sections/urgent_section.dart';
import '../widgets/home/sections/videos_section.dart';
import '../widgets/home/sections/favorites_merchants_section.dart';
import '../widgets/minimal_header.dart';

/// Page d'accueil principale type Too Good To Go
/// Affiche tous les restaurants et leurs offres anti-gaspi
class MainHomeScreen extends ConsumerStatefulWidget {
  const MainHomeScreen({super.key});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MinimalHeader(showLocationInstead: true),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),

            // Section des grandes enseignes (toujours en premier)
            BrandSection(),

            // Section des catégories
            CategoriesSection(),

            // Section Près de chez vous (nouvelle)
            NearbySection(),

            // Section des offres urgentes
            UrgentSection(),

            // Section recommandé pour vous
            RecommendedSection(),

            // Section des repas complets
            MealsSection(),

            // Section des marchands partenaires
            MerchantSection(),

            // Section des vidéos et astuces
            VideosSection(),

            // Section des commerçants favoris (slider)
            FavoritesMerchantsSection(),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
