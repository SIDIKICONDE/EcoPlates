import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../../domain/entities/food_offer.dart';
import '../providers/offers_catalog_provider.dart';
import '../providers/urgent_offers_provider.dart';
import '../widgets/logo/index.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_card/offer_card_configs.dart';
import '../widgets/urgent_offer_detail_modal.dart';
import '../widgets/urgent_offers_animation_manager.dart';
import '../widgets/urgent_offers_bottom_sheets.dart';
import '../widgets/urgent_offers_empty_state.dart';

/// Page affichant tous les repas complets disponibles
class AllMealsScreen extends ConsumerStatefulWidget {
  const AllMealsScreen({super.key});

  @override
  ConsumerState<AllMealsScreen> createState() => _AllMealsScreenState();
}

class _AllMealsScreenState extends ConsumerState<AllMealsScreen>
    with SingleTickerProviderStateMixin {
  UrgentOffersAnimationManager? _animationManager;

  @override
  void initState() {
    super.initState();
    _animationManager = UrgentOffersAnimationManager()
      ..initializeAnimations(this);
  }

  @override
  void dispose() {
    _animationManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(urgentOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            LogoMeal(
              animationManager: _animationManager,
            ),
            SizedBox(width: context.horizontalSpacing / 2),
            Text(
              'Tous les repas complets',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20.0),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        toolbarHeight: context.appBarHeight,
        backgroundColor: DeepColorTokens.primary.withValues(alpha: 0.1),
        actions: [
          IconButton(
            icon: Icon(
              Icons.sort,
              size: ResponsiveUtils.getIconSize(context),
            ),
            onPressed: () => UrgentOffersSortBottomSheet.show(context),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              size: ResponsiveUtils.getIconSize(context),
            ),
            onPressed: () => UrgentOffersFilterBottomSheet.show(context),
          ),
        ],
      ),
      body: meals.isEmpty
          ? const UrgentOffersEmptyState()
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(offersRefreshProvider.notifier).refreshIfStale();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.horizontalSpacing,
                  vertical: context.verticalSpacing,
                ),
                child: _buildGridView(context, meals),
              ),
            ),
    );
  }

  Widget _buildGridView(BuildContext context, List<FoodOffer> meals) {
    final screenSize = MediaQuery.of(context).size;

    // Détection spécifique pour la taille 768x1024px (tablette portrait)
    final is768x1024 =
        screenSize.width >= 768 &&
        screenSize.width < 769 &&
        screenSize.height >= 1024 &&
        screenSize.height < 1025;

    return ResponsiveGrid(
      tabletColumns: is768x1024 ? 2 : 3, // 2 colonnes pour 768x1024px, sinon 3
      desktopColumns: 4, // 4 colonnes sur desktop standard
      desktopLargeColumns: 5, // 5 colonnes sur desktop large
      spacing: 2.0, // Gap minimal horizontal fixe
      runSpacing: 2.0, // Gap minimal vertical fixe
      childAspectRatio: OfferCardConfigs.urgentPage(
        context,
      ).aspectRatio,
      children: meals.map((meal) {
        final index = meals.indexOf(meal);

        return OfferCard(
          offer: meal,
          distance: 0.5 + (index * 0.3),
          compact:
              true, // Aligne avec les sections d'accueil (cartes compactes)
          imageBorderRadius: OfferCardConfigs.urgentPage(
            context,
          ).imageBorderRadius,
          onTap: () => UrgentOfferDetailModal.show(
            context,
            meal,
            _animationManager!.animationController,
            _animationManager!.pulseAnimation,
          ),
        );
      }).toList(),
    );
  }
}
