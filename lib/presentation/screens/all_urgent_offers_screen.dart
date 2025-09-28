import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart' as design_tokens;
import '../../domain/entities/food_offer.dart';
import '../providers/offer_reservation_provider.dart';
import '../providers/offers_catalog_provider.dart';
import '../providers/urgent_offers_provider.dart';
import '../widgets/offer_card.dart';
import '../widgets/offer_detail/index.dart';

/// Page affichant toutes les offres urgentes à sauver
class AllUrgentOffersScreen extends ConsumerStatefulWidget {
  const AllUrgentOffersScreen({super.key});

  @override
  ConsumerState<AllUrgentOffersScreen> createState() =>
      _AllUrgentOffersScreenState();
}

class _AllUrgentOffersScreenState extends ConsumerState<AllUrgentOffersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: design_tokens
          .EcoPlatesDesignTokens
          .urgentOffers
          .pulseAnimationDuration,
      vsync: this,
    )..repeat();

    _pulseAnimation =
        Tween<double>(
          begin: design_tokens.EcoPlatesDesignTokens.urgentOffers.pulseBegin,
          end: design_tokens.EcoPlatesDesignTokens.urgentOffers.pulseEnd,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = ref.watch(urgentOffersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: const Text('🔥'),
                );
              },
            ),
            SizedBox(
              width: design_tokens.EcoPlatesDesignTokens.spacing.microGap(
                context,
              ),
            ),
            const Text("À sauver d'urgence"),
          ],
        ),
        centerTitle: false,
        backgroundColor:
            Theme.of(
              context,
            ).colorScheme.errorContainer.withValues(
              alpha: design_tokens
                  .EcoPlatesDesignTokens
                  .urgentOffers
                  .backgroundOpacity,
            ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortBottomSheet(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (offers.isEmpty) {
            return _buildEmptyState(context);
          }

          // Trier les offres par urgence
          final sortedOffers = List<FoodOffer>.from(offers)
            ..sort((a, b) {
              final aTime = a.pickupEndTime.difference(DateTime.now());
              final bTime = b.pickupEndTime.difference(DateTime.now());
              return aTime.compareTo(bTime);
            });

          return RefreshIndicator(
            onRefresh: () async {
              // Rafraîchir intelligemment avec TTL
              await ref.read(offersRefreshProvider.notifier).refreshIfStale();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(
                design_tokens.EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              itemCount: sortedOffers.length,
              itemBuilder: (context, index) {
                final offer = sortedOffers[index];
                final remainingTime = offer.pickupEndTime.difference(
                  DateTime.now(),
                );

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: design_tokens.EcoPlatesDesignTokens.spacing
                        .interfaceGap(context),
                  ),
                  child: Stack(
                    children: [
                      OfferCard(
                        offer: offer,
                        distance:
                            design_tokens
                                .EcoPlatesDesignTokens
                                .urgentOffers
                                .baseDistance +
                            (index *
                                design_tokens
                                    .EcoPlatesDesignTokens
                                    .urgentOffers
                                    .distanceIncrement),
                        onTap: () {
                          _navigateToOfferDetail(context, offer);
                        },
                      ),

                      // Badge urgence en overlay
                      Positioned(
                        top: design_tokens.EcoPlatesDesignTokens.spacing
                            .interfaceGap(context),
                        right: design_tokens.EcoPlatesDesignTokens.spacing
                            .interfaceGap(context),
                        child: _buildUrgencyIndicator(remainingTime),
                      ),

                      // Indicateur de stock faible
                      if (offer.quantity <=
                          design_tokens
                              .EcoPlatesDesignTokens
                              .urgentOffers
                              .lowStockThreshold)
                        Positioned(
                          bottom:
                              design_tokens.EcoPlatesDesignTokens.spacing
                                  .sectionSpacing(context) *
                              2,
                          left: design_tokens.EcoPlatesDesignTokens.spacing
                              .dialogGap(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: design_tokens
                                  .EcoPlatesDesignTokens
                                  .spacing
                                  .microGap(context),
                              vertical: design_tokens
                                  .EcoPlatesDesignTokens
                                  .spacing
                                  .xxs,
                            ),
                            decoration: BoxDecoration(
                              color: offer.quantity == 1
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(
                                design_tokens.EcoPlatesDesignTokens.radius.sm,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.shadow.withValues(
                                        alpha: design_tokens
                                            .EcoPlatesDesignTokens
                                            .urgentOffers
                                            .shadowOpacity,
                                      ),
                                  blurRadius: design_tokens
                                      .EcoPlatesDesignTokens
                                      .elevation
                                      .mediumBlur,
                                  offset: design_tokens
                                      .EcoPlatesDesignTokens
                                      .elevation
                                      .elevatedOffset,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flash_on,
                                  color: Theme.of(context).colorScheme.onError,
                                  size: design_tokens
                                      .EcoPlatesDesignTokens
                                      .typography
                                      .label(context),
                                ),
                                SizedBox(
                                  width: design_tokens
                                      .EcoPlatesDesignTokens
                                      .spacing
                                      .xxs,
                                ),
                                Text(
                                  offer.quantity == 1
                                      ? 'Dernier disponible !'
                                      : 'Plus que ${offer.quantity} restants',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                        fontWeight: design_tokens
                                            .EcoPlatesDesignTokens
                                            .typography
                                            .bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUrgencyIndicator(Duration remainingTime) {
    if (remainingTime.isNegative) {
      return Container(); // Offre expirée
    }

    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes % 60;

    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    if (hours == 0 &&
        minutes <=
            design_tokens
                .EcoPlatesDesignTokens
                .urgentOffers
                .criticalTimeThreshold) {
      bgColor = Theme.of(context).colorScheme.error;
      textColor = Theme.of(context).colorScheme.onError;
      label = '⚡ $minutes min';
      icon = Icons.warning;
    } else if (hours == 0) {
      bgColor = Theme.of(context).colorScheme.tertiary;
      textColor = Theme.of(context).colorScheme.onTertiary;
      label = '⏰ $minutes min';
      icon = Icons.timer;
    } else if (hours <=
        (design_tokens
                .EcoPlatesDesignTokens
                .urgentOffers
                .warningTimeThreshold ~/
            60)) {
      bgColor = Theme.of(context).colorScheme.secondary;
      textColor = Theme.of(context).colorScheme.onSecondary;
      label = '${hours}h ${minutes}min';
      icon = Icons.access_time;
    } else {
      bgColor = Theme.of(context).colorScheme.primary;
      textColor = Theme.of(context).colorScheme.onPrimary;
      label = '${hours}h';
      icon = Icons.schedule;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: hours == 0 ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: design_tokens.EcoPlatesDesignTokens.spacing.microGap(
                context,
              ),
              vertical: design_tokens.EcoPlatesDesignTokens.spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                design_tokens.EcoPlatesDesignTokens.radius.sm,
              ),
              boxShadow: [
                BoxShadow(
                  color: bgColor.withValues(
                    alpha: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .overlayOpacity,
                  ),
                  blurRadius:
                      design_tokens.EcoPlatesDesignTokens.elevation.largeBlur,
                  offset: design_tokens
                      .EcoPlatesDesignTokens
                      .elevation
                      .elevatedOffset,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: design_tokens.EcoPlatesDesignTokens.typography.label(
                    context,
                  ),
                ),
                SizedBox(
                  width: design_tokens.EcoPlatesDesignTokens.spacing.xxs,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontWeight:
                        design_tokens.EcoPlatesDesignTokens.typography.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width:
                design_tokens.EcoPlatesDesignTokens.layout.emptyStateIconSize *
                design_tokens
                    .EcoPlatesDesignTokens
                    .urgentOffers
                    .emptyStateIconMultiplier,
            height:
                design_tokens.EcoPlatesDesignTokens.layout.emptyStateIconSize *
                design_tokens
                    .EcoPlatesDesignTokens
                    .urgentOffers
                    .emptyStateIconMultiplier,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size:
                  design_tokens.EcoPlatesDesignTokens.layout.emptyStateIconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(
            height: design_tokens.EcoPlatesDesignTokens.spacing.sectionSpacing(
              context,
            ),
          ),
          Text(
            'Tout a été sauvé ! 🎉',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: design_tokens.EcoPlatesDesignTokens.typography.bold,
            ),
          ),
          SizedBox(
            height: design_tokens.EcoPlatesDesignTokens.spacing.interfaceGap(
              context,
            ),
          ),
          Text(
            'Aucune offre urgente en ce moment.\nRevenez plus tard pour sauver de la nourriture !',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: design_tokens.EcoPlatesDesignTokens.spacing.sectionSpacing(
              context,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: design_tokens.EcoPlatesDesignTokens.spacing
                    .sectionSpacing(context),
                vertical: design_tokens.EcoPlatesDesignTokens.spacing
                    .interfaceGap(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _buildErrorState n'est plus utilisé après simplification en Provider synchrone

  void _navigateToOfferDetail(BuildContext context, FoodOffer offer) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: design_tokens
            .EcoPlatesDesignTokens
            .urgentOffers
            .modalBackgroundColor,
        builder: (context) => _buildOfferDetailModal(context, offer),
      ),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent =
        remainingTime.inMinutes <=
        design_tokens.EcoPlatesDesignTokens.urgentOffers.urgentTimeThreshold;

    return Container(
      height:
          MediaQuery.of(context).size.height *
          design_tokens.EcoPlatesDesignTokens.urgentOffers.modalHeightRatio,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(design_tokens.EcoPlatesDesignTokens.radius.lg),
        ),
      ),
      child: Column(
        children: [
          // Header avec indication d'urgence
          Container(
            padding: EdgeInsets.all(
              design_tokens.EcoPlatesDesignTokens.spacing.dialogGap(context),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isVeryUrgent
                    ? [
                        Theme.of(context).colorScheme.errorContainer,
                        Theme.of(context).colorScheme.tertiaryContainer,
                      ]
                    : [
                        Theme.of(context).colorScheme.secondaryContainer,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  design_tokens.EcoPlatesDesignTokens.radius.lg,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Theme.of(context).colorScheme.error,
                            size: design_tokens.EcoPlatesDesignTokens.typography
                                .titleSize(context),
                          ),
                          SizedBox(
                            width:
                                design_tokens.EcoPlatesDesignTokens.spacing.xxs,
                          ),
                          Text(
                            'Offre très urgente !',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: design_tokens
                                      .EcoPlatesDesignTokens
                                      .typography
                                      .bold,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: design_tokens.EcoPlatesDesignTokens.spacing.xxs,
                      ),
                      Text(
                        'À récupérer avant ${_formatTime(offer.pickupEndTime)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                design_tokens.EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge quantité limitée si applicable
                  if (offer.quantity <=
                      design_tokens
                          .EcoPlatesDesignTokens
                          .urgentOffers
                          .lowStockThreshold)
                    Container(
                      margin: EdgeInsets.only(
                        bottom: design_tokens.EcoPlatesDesignTokens.spacing
                            .interfaceGap(context),
                      ),
                      padding: EdgeInsets.all(
                        design_tokens.EcoPlatesDesignTokens.spacing
                            .interfaceGap(context),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(
                          design_tokens.EcoPlatesDesignTokens.radius.md,
                        ),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          SizedBox(
                            width: design_tokens.EcoPlatesDesignTokens.spacing
                                .interfaceGap(context),
                          ),
                          Text(
                            offer.quantity ==
                                    design_tokens
                                        .EcoPlatesDesignTokens
                                        .urgentOffers
                                        .criticalStockThreshold
                                ? 'Dernier article disponible !'
                                : 'Plus que ${offer.quantity} articles disponibles',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                                  fontWeight: design_tokens
                                      .EcoPlatesDesignTokens
                                      .typography
                                      .bold,
                                ),
                          ),
                        ],
                      ),
                    ),

                  // Informations principales
                  OfferInfoSection(offer: offer),
                  SizedBox(
                    height: design_tokens.EcoPlatesDesignTokens.spacing
                        .sectionSpacing(context),
                  ),

                  // Détails pratiques
                  OfferDetailsSection(offer: offer),
                  SizedBox(
                    height: design_tokens.EcoPlatesDesignTokens.spacing
                        .sectionSpacing(context),
                  ),

                  // Adresse
                  OfferAddressSection(offer: offer),
                  SizedBox(
                    height: design_tokens.EcoPlatesDesignTokens.spacing
                        .sectionSpacing(context),
                  ),

                  // Badges allergènes
                  OfferBadgesSection(offer: offer),
                  SizedBox(
                    height: design_tokens.EcoPlatesDesignTokens.spacing
                        .sectionSpacing(context),
                  ),

                  // Métadonnées
                  OfferMetadataSection(offer: offer),
                  SizedBox(
                    height: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .reservationBarSpacing,
                  ),
                ],
              ),
            ),
          ),

          // Barre de réservation urgente
          Container(
            padding: EdgeInsets.all(
              design_tokens.EcoPlatesDesignTokens.spacing.dialogGap(context),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.errorContainer,
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Prix
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (offer.originalPrice > 0)
                        Text(
                          '${offer.originalPrice.toStringAsFixed(2)}€',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      Text(
                        offer.discountedPrice == 0
                            ? 'Gratuit !'
                            : '${offer.discountedPrice.toStringAsFixed(2)}€',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: design_tokens
                                  .EcoPlatesDesignTokens
                                  .typography
                                  .bold,
                              color: offer.discountedPrice == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: design_tokens.EcoPlatesDesignTokens.spacing
                        .interfaceGap(context),
                  ),
                  // Bouton de réservation
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(offerReservationProvider.notifier)
                                  .reserve(offer: offer);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: design_tokens
                                        .EcoPlatesDesignTokens
                                        .urgentOffers
                                        .successSnackBarColor,
                                    content: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: design_tokens
                                              .EcoPlatesDesignTokens
                                              .urgentOffers
                                              .snackBarTextColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Bravo ! Vous avez sauvé "${offer.title}"',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: design_tokens
                                        .EcoPlatesDesignTokens
                                        .urgentOffers
                                        .successSnackBarDuration,
                                  ),
                                );
                              }
                            } on Exception catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: design_tokens
                                        .EcoPlatesDesignTokens
                                        .urgentOffers
                                        .errorSnackBarColor,
                                    content: Text('Réservation impossible: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                            padding: EdgeInsets.symmetric(
                              vertical: design_tokens
                                  .EcoPlatesDesignTokens
                                  .spacing
                                  .interfaceGap(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                design_tokens.EcoPlatesDesignTokens.radius.md,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                size: design_tokens
                                    .EcoPlatesDesignTokens
                                    .typography
                                    .titleSize(context),
                              ),
                              SizedBox(
                                width: design_tokens
                                    .EcoPlatesDesignTokens
                                    .spacing
                                    .microGap(context),
                              ),
                              Text(
                                'Sauver maintenant',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: design_tokens
                                          .EcoPlatesDesignTokens
                                          .typography
                                          .bold,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _showSortBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              design_tokens
                  .EcoPlatesDesignTokens
                  .urgentOffers
                  .bottomSheetBorderRadius,
            ),
          ),
        ),
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(
              design_tokens
                  .EcoPlatesDesignTokens
                  .urgentOffers
                  .bottomSheetPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trier par',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: design_tokens
                      .EcoPlatesDesignTokens
                      .urgentOffers
                      .bottomSheetVerticalSpacing,
                ),
                ListTile(
                  leading: Icon(
                    Icons.timer,
                    color: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .sortUrgentColor,
                  ),
                  title: const Text("Plus urgent d'abord"),
                  subtitle: const Text('Offres qui expirent bientôt'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  selected: true,
                  selectedTileColor: design_tokens
                      .EcoPlatesDesignTokens
                      .urgentOffers
                      .sortSelectedBackgroundColor,
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .sortLocationColor,
                  ),
                  title: const Text('Plus proche'),
                  subtitle: const Text('Distance la plus courte'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.euro,
                    color: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .sortPriceColor,
                  ),
                  title: const Text('Prix le plus bas'),
                  subtitle: const Text('Meilleures affaires'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.inventory,
                    color: design_tokens
                        .EcoPlatesDesignTokens
                        .urgentOffers
                        .sortStockColor,
                  ),
                  title: const Text('Stock faible'),
                  subtitle: const Text('Derniers articles disponibles'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(
              design_tokens
                  .EcoPlatesDesignTokens
                  .urgentOffers
                  .bottomSheetBorderRadius,
            ),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(
              design_tokens
                  .EcoPlatesDesignTokens
                  .urgentOffers
                  .bottomSheetPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrer les offres urgentes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: design_tokens
                      .EcoPlatesDesignTokens
                      .urgentOffers
                      .bottomSheetVerticalSpacing,
                ),

                // Filtre par temps restant
                Text(
                  'Temps restant',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('< 30 min'),
                      avatar: const Icon(Icons.warning, size: 18),
                      backgroundColor: Colors.red[50],
                      selectedColor: Colors.red[200],
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 1h'),
                      avatar: const Icon(Icons.timer, size: 18),
                      backgroundColor: Colors.orange[50],
                      selectedColor: Colors.orange[200],
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 2h'),
                      backgroundColor: Colors.amber[50],
                      selectedColor: Colors.amber[200],
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Filtre par quantité
                Text(
                  'Quantité disponible',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('Dernier article'),
                      avatar: const Icon(Icons.looks_one, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 3 restants'),
                      avatar: const Icon(Icons.inventory_2, size: 18),
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: const Text('< 5 restants'),
                      onSelected: (selected) {},
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Réinitialiser'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Filtres appliqués'),
                              duration: design_tokens
                                  .EcoPlatesDesignTokens
                                  .urgentOffers
                                  .infoSnackBarDuration,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Appliquer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
