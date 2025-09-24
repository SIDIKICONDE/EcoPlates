import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/minimal_header.dart';
import '../widgets/home/sections/brand_section.dart';
import '../widgets/home/sections/categories_section.dart';
import '../widgets/home/sections/recommended_section.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const MinimalHeader(
        title: 'EcoPlates',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            
            // Section des marques/enseignes (toujours en haut)
            const BrandSection(),
            
            // Section des catégories (en dessous des enseignes)
            const CategoriesSection(),
            
            // Section recommandé pour vous
            const RecommendedSection(),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
