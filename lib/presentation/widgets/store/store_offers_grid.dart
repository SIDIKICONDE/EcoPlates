import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../domain/entities/food_offer.dart';
import '../../providers/store_offers_provider.dart';
import 'store_offer_actions_dialog.dart';
import 'store_offer_cards.dart';
import 'store_offers_states.dart';

/// Widget pour afficher les offres dans une grille ou liste
class StoreOffersGrid extends ConsumerWidget {
  const StoreOffersGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(storeOffersProvider);
    final viewMode = ref.watch(storeViewModeProvider);

    return offersAsync.when(
      data: (offers) {
        if (offers.isEmpty) {
          return const StoreOffersEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(storeOffersProvider.notifier).refresh(),
          child: _buildOffersView(context, ref, viewMode, offers),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => StoreOffersErrorState(
        error: error.toString(),
        onRetry: () => ref.read(storeOffersProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildOffersView(
    BuildContext context,
    WidgetRef ref,
    StoreViewMode viewMode,
    List<FoodOffer> offers,
  ) {
    if (viewMode == StoreViewMode.grid) {
      return _OffersGridView(offers: offers, ref: ref);
    } else {
      return _OffersListView(offers: offers, ref: ref);
    }
  }
}

/// Vue en grille des offres avec les offres passées en paramètre
class _OffersGridView extends StatelessWidget {
  const _OffersGridView({required this.offers, required this.ref});

  final List<FoodOffer> offers;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveColumns(
      context,
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      desktopLargeColumns: 4,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: ResponsiveUtils.getOfferCardAspectRatio(context),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return StoreOfferGridCard(
          offer: offer,
          onTap: () => StoreOfferActionsDialog.show(context, offer),
        );
      },
    );
  }
}

/// Vue en liste des offres avec les offres passées en paramètre
class _OffersListView extends StatelessWidget {
  const _OffersListView({required this.offers, required this.ref});

  final List<FoodOffer> offers;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: StoreOfferListCard(
            offer: offer,
            onTap: () => StoreOfferActionsDialog.show(context, offer),
          ),
        );
      },
    );
  }
}
