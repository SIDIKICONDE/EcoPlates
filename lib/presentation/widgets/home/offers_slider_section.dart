import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import '../../../domain/entities/food_offer.dart';
import '../../providers/offers_slider_provider.dart';
import '../offer_card.dart';

/// Section de slider d'offres réutilisable avec carousel horizontal
/// Supporte différents providers et filtres
class OffersSliderSection extends ConsumerStatefulWidget {
  final String title;
  final String? subtitle;
  final StateNotifierProvider<OffersSliderNotifier, OffersSliderState> provider;
  final IconData? titleIcon;
  final Color? accentColor;
  final String? seeAllRoute;
  final bool showDistance;
  final VoidCallback? onSeeAll;
  final double cardWidth;
  final double cardHeight;
  final bool autoPlay;
  final Duration autoPlayDuration;

  const OffersSliderSection({
    super.key,
    required this.title,
    required this.provider,
    this.subtitle,
    this.titleIcon,
    this.accentColor,
    this.seeAllRoute,
    this.showDistance = true,
    this.onSeeAll,
    this.cardWidth = 320,
    this.cardHeight = 380,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 4),
  });

  @override
  ConsumerState<OffersSliderSection> createState() => _OffersSliderSectionState();
}

class _OffersSliderSectionState extends ConsumerState<OffersSliderSection>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(widget.autoPlayDuration, () {
      if (mounted && _pageController.hasClients) {
        final state = ref.read(widget.provider);
        if (state.offers.isNotEmpty) {
          final nextPage = (_currentPage + 1) % state.offers.length;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        _startAutoPlay();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isIOS = Platform.isIOS;
    final state = ref.watch(widget.provider);

    return Semantics(
      label: 'Section ${widget.title}',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de section
            _buildSectionHeader(context, theme, state),
            
            const SizedBox(height: 12),
            
            // Contenu de la section avec gestion des états
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _buildContent(context, state, theme, isDark, isIOS),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, ThemeData theme, OffersSliderState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.titleIcon != null) ...[
                      Icon(
                        widget.titleIcon,
                        size: 24,
                        color: widget.accentColor ?? theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineSmall?.color,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (state.offers.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.accentColor ?? theme.primaryColor)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${state.offers.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.accentColor ?? theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (widget.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (widget.seeAllRoute != null || widget.onSeeAll != null)
            TextButton(
              onPressed: widget.onSeeAll ?? () => context.push(widget.seeAllRoute!),
              child: Row(
                children: [
                  Text(
                    'Voir tout',
                    style: TextStyle(
                      color: widget.accentColor ?? theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: widget.accentColor ?? theme.primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OffersSliderState state,
    ThemeData theme,
    bool isDark,
    bool isIOS,
  ) {
    // État de chargement
    if (state.isLoading && state.offers.isEmpty) {
      return _buildLoadingState(theme, isDark);
    }

    // État d'erreur
    if (state.error != null && state.offers.isEmpty) {
      return _buildErrorState(context, state.error!, theme, isIOS);
    }

    // État vide
    if (state.offers.isEmpty) {
      return _buildEmptyState(theme);
    }

    // Affichage du carousel
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildCarousel(context, state.offers, theme),
    );
  }

  Widget _buildLoadingState(ThemeData theme, bool isDark) {
    return SizedBox(
      height: widget.cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: widget.cardWidth,
            margin: const EdgeInsets.only(right: 12),
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, ThemeData theme, bool isIOS) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIOS ? CupertinoIcons.exclamationmark_circle : Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Oups ! Quelque chose s\'est mal passé',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(widget.provider.notifier).refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor ?? theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune offre disponible',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Revenez plus tard pour découvrir de nouvelles offres',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, List<FoodOffer> offers, ThemeData theme) {
    return SizedBox(
      height: widget.cardHeight,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          final isCurrentPage = _currentPage == index;

          final scaleFactor = isCurrentPage ? 1.0 : 0.95;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.diagonal3Values(scaleFactor, scaleFactor, 1.0),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Semantics(
              label: 'Offre ${index + 1} sur ${offers.length}: ${offer.title}',
              child: GestureDetector(
                onTap: () {
                  // Navigation vers le détail de l'offre
                  context.push('/offers/${offer.id}');
                },
                child: OfferCard(
                  offer: offer,
                  showDistance: widget.showDistance,
                  distance: offer.location.distanceFrom(
                    48.8566, // Latitude Paris (exemple)
                    2.3522,  // Longitude Paris (exemple)
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Widget pour les indicateurs de page (points)
class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? (activeColor ?? theme.primaryColor)
                : (inactiveColor ?? Colors.grey[400]),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}