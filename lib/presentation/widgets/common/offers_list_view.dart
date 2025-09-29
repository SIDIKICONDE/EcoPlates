import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/food_offer.dart';
import '../offer_card.dart';
import 'empty_state.dart';
import 'offer_detail_modal.dart';

/// Widget générique pour afficher une liste d'offres avec fonctionnalités communes
class OffersListView extends ConsumerWidget {
  const OffersListView({
    super.key,
    required this.offers,
    this.emptyStateTitle = 'Aucune offre disponible',
    this.emptyStateSubtitle,
    this.emptyStateIcon = Icons.local_offer_outlined,
    this.emptyStateActions,
    this.enableRefresh = false,
    this.onRefresh,
    this.padding,
    this.itemSpacing = 16.0,
    this.compactCards = false,
    this.onOfferTap,
    this.showDistance = true,
    this.distanceGenerator,
    this.sortOffers,
    this.customCardBuilder,
    this.showDetailModal = true,
    this.detailModalBuilder,
    this.physics,
  });

  /// Liste des offres à afficher
  final List<FoodOffer> offers;

  /// Titre de l'état vide
  final String emptyStateTitle;

  /// Sous-titre de l'état vide
  final String? emptyStateSubtitle;

  /// Icône de l'état vide
  final IconData emptyStateIcon;

  /// Actions de l'état vide (boutons)
  final List<Widget>? emptyStateActions;

  /// Active le RefreshIndicator
  final bool enableRefresh;

  /// Callback pour le refresh
  final Future<void> Function()? onRefresh;

  /// Padding de la liste
  final EdgeInsets? padding;

  /// Espacement entre les éléments
  final double itemSpacing;

  /// Utilise des cartes compactes
  final bool compactCards;

  /// Callback personnalisé pour le tap sur une offre
  final void Function(FoodOffer offer)? onOfferTap;

  /// Affiche la distance simulée
  final bool showDistance;

  /// Générateur de distance personnalisé
  final double Function(int index)? distanceGenerator;

  /// Fonction de tri des offres
  final List<FoodOffer> Function(List<FoodOffer> offers)? sortOffers;

  /// Builder personnalisé pour les cartes
  final Widget Function(BuildContext context, FoodOffer offer, int index)?
  customCardBuilder;

  /// Affiche automatiquement la modal de détail au tap
  final bool showDetailModal;

  /// Builder personnalisé pour la modal de détail
  final Widget Function(BuildContext context, FoodOffer offer)?
  detailModalBuilder;

  /// Physics du ScrollView
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (offers.isEmpty) {
      return EmptyState(
        title: emptyStateTitle,
        subtitle: emptyStateSubtitle,
        icon: emptyStateIcon,
        primaryActionLabel: emptyStateActions?.isNotEmpty == true ? null : null,
        // TODO: Gérer les actions personnalisées si nécessaire
      );
    }

    final sortedOffers = sortOffers?.call(offers) ?? offers;

    final listView = ListView.builder(
      physics: physics,
      padding: padding ?? const EdgeInsets.all(16.0),
      itemCount: sortedOffers.length,
      itemBuilder: (context, index) {
        final offer = sortedOffers[index];

        if (customCardBuilder != null) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < sortedOffers.length - 1 ? itemSpacing : 0,
            ),
            child: customCardBuilder!(context, offer, index),
          );
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < sortedOffers.length - 1 ? itemSpacing : 0,
          ),
          child: OfferCard(
            offer: offer,
            distance: showDistance
                ? (distanceGenerator?.call(index) ?? (0.5 + (index * 0.3)))
                : null,
            compact: compactCards,
            onTap: () {
              if (onOfferTap != null) {
                onOfferTap!(offer);
              } else if (showDetailModal) {
                _showOfferDetail(context, offer);
              }
            },
          ),
        );
      },
    );

    if (enableRefresh && onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }

  Future<void> _showOfferDetail(BuildContext context, FoodOffer offer) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        if (detailModalBuilder != null) {
          return detailModalBuilder!(context, offer);
        }

        return OfferDetailModal(
          offer: offer,
          onReserve: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Réservation pour "${offer.title}" confirmée !'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }
}

/// Widget spécialisé pour les offres urgentes
class UrgentOffersListView extends OffersListView {
  const UrgentOffersListView({
    super.key,
    required super.offers,
    super.enableRefresh = true,
    super.onRefresh,
    super.padding,
    super.itemSpacing,
    super.onOfferTap,
    super.showDistance = false,
    super.customCardBuilder,
  }) : super(
         emptyStateTitle: 'Tout a été sauvé ! 🎉',
         emptyStateSubtitle:
             'Aucune offre urgente en ce moment.\nRevenez plus tard pour sauver de la nourriture !',
         emptyStateIcon: Icons.check_circle,
         sortOffers: _sortByUrgency,
       );

  static List<FoodOffer> _sortByUrgency(List<FoodOffer> offers) {
    return List<FoodOffer>.from(offers)..sort((a, b) {
      final aTime = a.pickupEndTime.difference(DateTime.now());
      final bTime = b.pickupEndTime.difference(DateTime.now());
      return aTime.compareTo(bTime);
    });
  }
}
