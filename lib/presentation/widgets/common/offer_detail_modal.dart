import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/food_offer.dart';
import '../offer_detail/index.dart';

/// Modal générique pour afficher les détails d'une offre
class OfferDetailModal extends ConsumerWidget {
  const OfferDetailModal({
    super.key,
    required this.offer,
    this.title,
    this.subtitle,
    this.headerGradient,
    this.headerBackgroundColor,
    this.showUrgentHeader = false,
    this.urgentHeaderText,
    this.showQuantityBadge = false,
    this.showMealComposition = false,
    this.customSections,
    this.footerWidget,
    this.onReserve,
    this.reservationButtonText = 'Réserver maintenant',
    this.reservationButtonColor,
    this.reservationButtonIcon,
    this.showReservationBar = true,
    this.height = 0.8,
  });

  /// L'offre à afficher
  final FoodOffer offer;

  /// Titre personnalisé (par défaut: nom de l'offre)
  final String? title;

  /// Sous-titre personnalisé (par défaut: nom du marchand)
  final String? subtitle;

  /// Gradient personnalisé pour le header
  final Gradient? headerGradient;

  /// Couleur de fond du header
  final Color? headerBackgroundColor;

  /// Affiche un header d'urgence
  final bool showUrgentHeader;

  /// Texte du header d'urgence
  final String? urgentHeaderText;

  /// Affiche un badge de quantité limitée si quantité <= 3
  final bool showQuantityBadge;

  /// Affiche la section composition du repas (pour les repas)
  final bool showMealComposition;

  /// Sections personnalisées à ajouter
  final List<Widget>? customSections;

  /// Widget de pied personnalisé (remplace la barre de réservation)
  final Widget? footerWidget;

  /// Callback de réservation
  final VoidCallback? onReserve;

  /// Texte du bouton de réservation
  final String reservationButtonText;

  /// Couleur du bouton de réservation
  final Color? reservationButtonColor;

  /// Icône du bouton de réservation
  final IconData? reservationButtonIcon;

  /// Affiche la barre de réservation standard
  final bool showReservationBar;

  /// Hauteur de la modal (fraction de l'écran)
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remainingTime = offer.pickupEndTime.difference(DateTime.now());
    final isVeryUrgent = remainingTime.inMinutes <= 30;

    return Container(
      height: MediaQuery.of(context).size.height * height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Column(
        children: [
          // Header avec gradient et bouton fermer
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient:
                  headerGradient ??
                  (showUrgentHeader && isVeryUrgent
                      ? LinearGradient(
                          colors: [
                            theme.colorScheme.errorContainer,
                            theme.colorScheme.tertiaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null),
              color:
                  headerBackgroundColor ??
                  (headerGradient == null
                      ? theme.colorScheme.surfaceContainerLowest
                      : null),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showUrgentHeader && isVeryUrgent) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.warning,
                              color: theme.colorScheme.error,
                              size: 20.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              urgentHeaderText ??
                                  'URGENT - ${remainingTime.inMinutes} minutes restantes',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                      ],
                      Text(
                        title ?? offer.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle ?? 'Chez ${offer.merchantName}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge quantité limitée si applicable
                  if (showQuantityBadge && offer.quantity <= 3)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: theme.colorScheme.tertiary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            offer.quantity == 1
                                ? 'Dernier article disponible !'
                                : 'Plus que ${offer.quantity} articles disponibles',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Sections personnalisées en premier
                  if (customSections != null)
                    ...customSections!.map(
                      (section) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: section,
                      ),
                    ),

                  // Composition du repas (si activée)
                  if (showMealComposition) ...[
                    _buildMealComposition(context, offer),
                    const SizedBox(height: 16.0),
                  ],

                  // Sections standards
                  OfferInfoSection(offer: offer),
                  const SizedBox(height: 16.0),

                  OfferDetailsSection(offer: offer),
                  const SizedBox(height: 16.0),

                  OfferAddressSection(offer: offer),
                  const SizedBox(height: 16.0),

                  OfferBadgesSection(offer: offer),
                  const SizedBox(height: 16.0),

                  OfferMetadataSection(offer: offer),
                  const SizedBox(
                    height: 80.0,
                  ), // Espace pour la barre de réservation
                ],
              ),
            ),
          ),

          // Footer personnalisé ou barre de réservation
          if (footerWidget != null)
            footerWidget!
          else if (showReservationBar)
            _buildReservationBar(context, theme),
        ],
      ),
    );
  }

  Widget _buildMealComposition(BuildContext context, FoodOffer meal) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Composition du repas',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: theme.colorScheme.secondary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 20.0,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      meal.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (meal.isVegetarian) ...[
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.eco,
                            size: 12.0,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 2.0),
                          Text(
                            'Végétarien',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReservationBar(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: OfferReservationBar(
          offer: offer,
          isReserving: false,
          onReserve:
              onReserve ??
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Réservation pour "${offer.title}" confirmée !',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
        ),
      ),
    );
  }
}
