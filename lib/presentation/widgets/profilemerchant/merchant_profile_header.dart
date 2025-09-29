import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/services/image_cache_service.dart';
import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/merchant_profile.dart';

/// Widget d'en-tête du profil merchant
///
/// Affiche les informations principales avec photo/logo
/// selon les directives EcoPlates
class MerchantProfileHeader extends ConsumerWidget {
  const MerchantProfileHeader({
    required this.profile,
    super.key,
    this.onEditPhoto,
    this.onEditProfile,
  });

  final MerchantProfile profile;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 768.0;
        final avatarSize = isWideScreen ? 120.0 : 80.0;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.1),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Avatar avec bouton d'édition
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildAvatar(context, avatarSize, colors),
                  if (onEditPhoto != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildEditPhotoButton(context, colors),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Nom et catégorie
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              // Badge catégorie
              _buildCategoryBadge(context, colors),

              const SizedBox(height: 8.0),

              // Statut d'ouverture
              _buildOpenStatus(context, theme, colors),

              // Description
              if (profile.description != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  profile.description!,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                if (onEditProfile != null) ...[
                  const SizedBox(height: 16.0),
                  _buildEditButton(context, theme, colors),
                ],
              ],

              // Note et avis
              if (profile.rating > 0) ...[
                const SizedBox(height: 16.0),
                _buildRatingSection(context, theme, colors),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, double size, ColorScheme colors) {
    if (profile.logoUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: EcoCachedImage(
          imageUrl: profile.logoUrl!,
          width: size,
          height: size,
          size: ImageSize.thumbnail,
          placeholder: Container(
            width: size,
            height: size,
            color: colors.surfaceContainerHighest,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: _buildDefaultAvatar(context, size, colors),
        ),
      );
    }
    return _buildDefaultAvatar(context, size, colors);
  }

  Widget _buildDefaultAvatar(
    BuildContext context,
    double size,
    ColorScheme colors,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.store,
        size: size * 0.5,
        color: colors.primary,
      ),
    );
  }

  Widget _buildEditPhotoButton(BuildContext context, ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primary,
      ),
      child: IconButton(
        icon: Icon(
          Icons.camera_alt,
          size: 16.0,
        ),
        color: colors.onPrimary,
        onPressed: onEditPhoto,
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, ColorScheme colors) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForCategory(profile.category),
            size: 16.0,
            color: colors.secondary,
          ),
          const SizedBox(width: 6.0),
          Text(
            profile.category.displayName,
            style: TextStyle(
              color: colors.secondary,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenStatus(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    final status = profile.getCurrentStatus();
    final todayHours = profile.getTodayHours();

    Color statusColor;
    switch (status) {
      case OpenStatus.open:
        statusColor = Colors.green;
      case OpenStatus.closingSoon:
        statusColor = Colors.orange;
      case OpenStatus.closed:
        statusColor = colors.error;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: statusColor,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          status.displayName,
          style: TextStyle(
            fontSize: 14.0,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '• ${todayHours?.shortFormat ?? 'N/A'}',
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return OutlinedButton.icon(
      onPressed: onEditProfile,
      icon: const Icon(
        Icons.edit,
        size: 16.0,
      ),
      label: const Text('Modifier le profil'),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary),
      ),
    );
  }

  Widget _buildRatingSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          profile.rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          '(${profile.totalReviews} avis)',
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(MerchantCategory category) {
    switch (category) {
      case MerchantCategory.bakery:
        return Icons.bakery_dining;
      case MerchantCategory.restaurant:
        return Icons.restaurant;
      case MerchantCategory.grocery:
        return Icons.shopping_basket;
      case MerchantCategory.cafe:
        return Icons.coffee;
      case MerchantCategory.supermarket:
        return Icons.store;
      case MerchantCategory.butcher:
        return Icons.restaurant_menu;
      case MerchantCategory.fishmonger:
        return Icons.set_meal;
      case MerchantCategory.delicatessen:
        return Icons.lunch_dining;
      case MerchantCategory.farmShop:
        return Icons.agriculture;
      case MerchantCategory.other:
        return Icons.storefront;
    }
  }
}
