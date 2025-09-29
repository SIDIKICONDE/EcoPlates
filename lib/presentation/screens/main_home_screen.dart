import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../widgets/navigation/integrated_tablet_menu.dart';
import '../widgets/home/sections/brand_section.dart';
import '../widgets/home/sections/categories_section.dart';
import '../widgets/home/sections/favorites_merchants_section.dart';
import '../widgets/home/sections/meals_section.dart';
import '../widgets/home/sections/merchant_section.dart';
import '../widgets/home/sections/nearby_section.dart';
import '../widgets/home/sections/recommended_section.dart';
import '../widgets/home/sections/urgent_section.dart';
import '../widgets/home/sections/videos_section.dart';
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
    // Détecter si c'est une tablette
    final isTablet = ResponsiveUtils.isTablet(context);
    
    // Si c'est une tablette, utiliser le menu tablette
    if (isTablet) {
      return const IntegratedTabletMenu();
    }
    
    // Sinon, afficher l'interface mobile normale
    return Scaffold(
      appBar: const MinimalHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 0),

            // Sections de l'écran d'accueil (ordre défini dans 16.0, // Grandes enseignes (toujours en premier)
            BrandSection(), // Grandes enseignes
            SizedBox(height: 0),
            CategoriesSection(), // Catégories
            SizedBox(height: 0),
            NearbySection(), // Près de chez vous
            SizedBox(height: 0),
            UrgentSection(), // Offres urgentes
            SizedBox(height: 0),
            RecommendedSection(), // Recommandé pour vous
            SizedBox(height: 0),
            MealsSection(), // Repas complets
            SizedBox(height: 0),
            MerchantSection(), // Marchands partenaires
            SizedBox(height: 0),
            VideosSection(), // Vidéos et astuces
            SizedBox(height: 0),
            FavoritesMerchantsSection(), // Commerçants favoris

            SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
