import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_layout.dart';
import '../../core/responsive/responsive_utils.dart';
import '../providers/offers_catalog_provider.dart';
import '../providers/urgent_offers_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_card/offer_card_configs.dart';
import '../widgets/urgent_offer_detail_modal.dart';
import '../widgets/urgent_offers_animation_manager.dart';
import '../widgets/urgent_offers_bottom_sheets.dart';
import '../widgets/urgent_offers_empty_state.dart';

/// Page affichant toutes les offres urgentes à sauver
class AllUrgentOffersScreen extends ConsumerStatefulWidget {
  const AllUrgentOffersScreen({super.key});

  @override
  ConsumerState<AllUrgentOffersScreen> createState() =>
      _AllUrgentOffersScreenState();
}

class _AllUrgentOffersScreenState extends ConsumerState<AllUrgentOffersScreen>
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
    final offers = ref.watch(urgentOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (_animationManager != null)
              _animationManager!.buildPulsingWidget(
                animation: _animationManager!.pulseAnimation,
                child: const Text('🔥'),
              )
            else
              const Text('🔥'),
            SizedBox(width: context.horizontalSpacing / 2),
            Text(
              "À sauver d'urgence",
              style: TextStyle(
                fontSize: FontSizes.bodyLarge.getSize(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: false,
        toolbarHeight: context.appBarHeight,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.1),
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
      body: offers.isEmpty
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
                child: ResponsiveGrid(
                  mobileColumns: 1,
                  tabletColumns: 3, // 3 colonnes sur tablette standard
                  desktopColumns: 4, // 4 colonnes sur desktop standard
                  desktopLargeColumns: 5, // 5 colonnes sur desktop large
                  spacing: context.horizontalSpacing,
                  runSpacing: context.verticalSpacing,
                  childAspectRatio: OfferCardConfigs.urgentPage(
                    context,
                  ).aspectRatio,
                  children: offers.map((offer) {
                    final index = offers.indexOf(offer);

                    return OfferCard(
                      offer: offer,
                      distance: 0.5 + (index * 0.3),
                      compact:
                          true, // Aligne avec les sections d'accueil (cartes compactes)
                      imageBorderRadius: OfferCardConfigs.urgentPage(
                        context,
                      ).imageBorderRadius,
                      onTap: () => UrgentOfferDetailModal.show(
                        context,
                        offer,
                        _animationManager!.animationController,
                        _animationManager!.pulseAnimation,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
