import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/food_offer.dart';
import '../../../providers/recommended_offers_provider.dart';
import '../../../screens/all_recommended_offers_screen.dart';
import '../../offer_card.dart';
import '../../offer_detail/index.dart';

/// Section des offres recommandées avec style Material 3
class RecommendedSection extends ConsumerWidget {
  const RecommendedSection({super.key});

  static const double _horizontalPadding = 20;
  static const double _sectionSpacing = 24;
  static const double _cardHeight = 280;
  static const double _cardWidth = 340;
  static const double _cardSpacing = 12;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedOffersAsync = ref.watch(recommendedOffersProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de section avec style amélioré
        Container(
          padding: const EdgeInsets.fromLTRB(
            _horizontalPadding,
            _sectionSpacing / 2,
            _horizontalPadding - 8,
            16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommandé pour vous',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const AllRecommendedOffersScreen(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Voir tout',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Liste horizontale d'offres avec animations
        SizedBox(
          height: _cardHeight,
          child: recommendedOffersAsync.when(
            data: (offers) => offers.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: _horizontalPadding - _cardSpacing / 2,
                    ),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 50)),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(
                          horizontal: _cardSpacing / 2,
                        ),
                        child: SizedBox(
                          width: _cardWidth,
                          child: Material(
                            elevation: 2,
                            shadowColor: colorScheme.shadow.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: OfferCard(
                              offer: offer,
                              compact: true,
                              distance: 1.2 + (index * 0.3),
                              onTap: () =>
                                  _showOfferDetailModal(context, offer),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => _buildLoadingState(context),
            error: (error, stack) => _buildErrorState(context, ref),
          ),
        ),

        const SizedBox(height: _sectionSpacing),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des recommandations...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Impossible de charger les offres',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vérifiez votre connexion internet',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.invalidate(recommendedOffersProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_rounded,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune recommandation',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Revenez plus tard pour découvrir de nouvelles offres',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showOfferDetailModal(BuildContext context, FoodOffer offer) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => _buildOfferDetailModal(context, offer),
    );
  }

  Widget _buildOfferDetailModal(BuildContext context, FoodOffer offer) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: mediaQuery.size.height * 0.9,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Indicateur de glissement
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header de la modal avec style Material 3
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Détails de l'offre",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),

          // Contenu scrollable avec animations
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations principales avec animation
                  _AnimatedSection(
                    delay: 0,
                    child: OfferInfoSection(offer: offer),
                  ),
                  const SizedBox(height: 32),

                  // Détails pratiques
                  _AnimatedSection(
                    delay: 100,
                    child: OfferDetailsSection(offer: offer),
                  ),
                  const SizedBox(height: 32),

                  // Adresse
                  _AnimatedSection(
                    delay: 200,
                    child: OfferAddressSection(offer: offer),
                  ),
                  const SizedBox(height: 32),

                  // Badges allergènes
                  _AnimatedSection(
                    delay: 300,
                    child: OfferBadgesSection(offer: offer),
                  ),
                  const SizedBox(height: 32),

                  // Métadonnées
                  _AnimatedSection(
                    delay: 400,
                    child: OfferMetadataSection(offer: offer),
                  ),
                  const SizedBox(
                    height: 120,
                  ), // Espace pour la barre de réservation
                ],
              ),
            ),
          ),

          // Barre de réservation avec style amélioré
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: OfferReservationBar(
                offer: offer,
                isReserving: false,
                onReserve: () {
                  Navigator.pop(context);
                  _showReservationConfirmation(context, offer);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReservationConfirmation(BuildContext context, FoodOffer offer) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: colorScheme.onPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Réservation pour "${offer.title}" confirmée !',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Voir',
          textColor: colorScheme.onPrimary,
          onPressed: () {
            // Navigation vers les réservations
          },
        ),
      ),
    );
  }
}

// Widget d'animation pour les sections
class _AnimatedSection extends StatefulWidget {
  const _AnimatedSection({required this.child, required this.delay});
  final Widget child;
  final int delay;

  @override
  State<_AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
