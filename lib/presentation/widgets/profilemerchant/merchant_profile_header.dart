import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/services/image_cache_service.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
        final isDesktop = constraints.maxWidth > 1024.0;
        final isWideScreen = constraints.maxWidth > 768.0;
        final avatarSize = isWideScreen ? 120.0 : 80.0;

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: DeepColorTokens
                .neutral50, // Fond clair cohérent avec les autres composants
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: isDesktop
              ? _buildDesktopLayout(context, theme, colors, avatarSize)
              : _buildMobileLayout(context, theme, colors, avatarSize),
        );
      },
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
    double avatarSize,
  ) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenu textuel à gauche (plus d'espace)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom et catégorie
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Badge catégorie
                  _buildCategoryBadge(context, colors),
                  const SizedBox(height: 12.0),

                  // Statut d'ouverture
                  _buildOpenStatus(context, theme, colors),
                  const SizedBox(height: 16.0),

                  // Description
                  if (profile.description != null) ...[
                    Text(
                      profile.description!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        height: 1.5,
                      ),
                      maxLines: 4,
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
            ),
            const SizedBox(width: 24.0),

            // Avatar centré à droite (moins d'espace)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Center(
                    child: Stack(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
    double avatarSize,
  ) {
    return Column(
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
            color: DeepColorTokens.surfaceElevated,
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
        color: DeepColorTokens.primaryLight.withValues(alpha: 0.3),
      ),
      child: Icon(
        Icons.store,
        size: size * 0.5,
        color: DeepColorTokens.primary,
      ),
    );
  }

  Widget _buildEditPhotoButton(BuildContext context, ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: DeepColorTokens.primary,
      ),
      child: IconButton(
        icon: Icon(
          Icons.camera_alt,
          size: 16.0,
        ),
        color: DeepColorTokens.neutral0,
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
        color: DeepColorTokens.secondaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForCategory(profile.category),
            size: 16.0,
            color: DeepColorTokens.secondary,
          ),
          const SizedBox(width: 6.0),
          Text(
            profile.category.displayName,
            style: TextStyle(
              color: DeepColorTokens.secondary,
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
        statusColor = DeepColorTokens.success;
      case OpenStatus.closingSoon:
        statusColor = DeepColorTokens.warning;
      case OpenStatus.closed:
        statusColor = DeepColorTokens.error;
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
          color: DeepColorTokens.accent,
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
