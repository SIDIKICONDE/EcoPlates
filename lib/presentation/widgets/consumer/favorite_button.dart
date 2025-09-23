import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/consumer/favorites_provider.dart';

/// Bouton favori animé pour les offres
class FavoriteButton extends ConsumerStatefulWidget {
  final String offerId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showAnimation;
  final VoidCallback? onToggle;

  const FavoriteButton({
    super.key,
    required this.offerId,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showAnimation = true,
    this.onToggle,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite() async {
    // Lancer l'animation
    if (widget.showAnimation) {
      _animationController.forward();
    }

    // Toggle le favori
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    await favoritesNotifier.toggleOfferFavorite(widget.offerId);

    // Callback optionnel
    widget.onToggle?.call();

    // Feedback haptique
    // HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isOfferFavoriteProvider(widget.offerId));
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor = widget.inactiveColor ?? Colors.grey;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(isFavorite),
                  color: isFavorite ? activeColor : inactiveColor,
                  size: widget.size,
                ),
              ),
              onPressed: _toggleFavorite,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: widget.size + 16,
                minHeight: widget.size + 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Bouton favori pour les commerçants
class MerchantFavoriteButton extends ConsumerWidget {
  final String merchantId;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const MerchantFavoriteButton({
    super.key,
    required this.merchantId,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isMerchantFavoriteProvider(merchantId));
    final activeColor = this.activeColor ?? Theme.of(context).primaryColor;
    final inactiveColor = this.inactiveColor ?? Colors.grey;

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.store : Icons.store_outlined,
        color: isFavorite ? activeColor : inactiveColor,
        size: size,
      ),
      onPressed: () async {
        final favoritesNotifier = ref.read(favoritesProvider.notifier);
        await favoritesNotifier.toggleMerchantFavorite(merchantId);
      },
    );
  }
}

/// Badge de favoris pour afficher le nombre
class FavoritesBadge extends ConsumerWidget {
  final Widget child;
  final bool showBadge;
  final Color? badgeColor;
  final Color? textColor;

  const FavoritesBadge({
    super.key,
    required this.child,
    this.showBadge = true,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(favoritesStatsProvider);
    final count = stats.totalOffers;

    if (!showBadge || count == 0) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: badgeColor ?? Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
