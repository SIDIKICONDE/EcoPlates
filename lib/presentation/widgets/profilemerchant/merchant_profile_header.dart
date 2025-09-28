import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/merchant_enums.dart';
import '../../../core/responsive/design_tokens.dart';
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
        final avatarSize = isWideScreen
            ? EcoPlatesDesignTokens.size.modalIcon(context) * 1.5
            : EcoPlatesDesignTokens.size.modalIcon(context);

        return Container(
          padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.xl,
            ),
            boxShadow: [
              BoxShadow(
                color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                offset: EcoPlatesDesignTokens.elevation.standardOffset,
              ),
            ],
          ),
          child: Column(
            children: [
              // Photo de profil / Logo
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  _buildAvatar(context, avatarSize, colors),
                  if (onEditPhoto != null)
                    _buildEditPhotoButton(context, colors),
                ],
              ),
              SizedBox(height: context.scaleMD_LG_XL_XXL),

              // Nom et catégorie
              Text(
                profile.name,
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),

              // Badge catégorie
              _buildCategoryBadge(context, colors),

              SizedBox(height: context.scaleXXS_XS_SM_MD),

              // Statut d'ouverture
              _buildOpenStatus(context, theme, colors),

              // Description
              if (profile.description != null) ...[
                SizedBox(height: context.scaleMD_LG_XL_XXL),
                Text(
                  profile.description!,
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: EcoPlatesDesignTokens.layout.descriptionMaxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Bouton d'édition
              if (onEditProfile != null) ...[
                SizedBox(height: context.scaleMD_LG_XL_XXL),
                _buildEditButton(context, theme, colors),
              ],

              // Note et avis
              if (profile.rating > 0) ...[
                SizedBox(height: context.scaleMD_LG_XL_XXL),
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
        color: colors.primary.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
      ),
      child: Icon(
        _getIconForCategory(profile.category),
        size: EcoPlatesDesignTokens.size.icon(context),
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
          size: EcoPlatesDesignTokens.size.indicator(context),
        ),
        color: colors.onPrimary,
        onPressed: onEditPhoto,
        padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context, ColorScheme colors) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForCategory(profile.category),
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: colors.secondary,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
          Text(
            profile.category.displayName,
            style: TextStyle(
              color: colors.secondary,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              fontWeight: EcoPlatesDesignTokens.typography.medium,
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
          width: EcoPlatesDesignTokens.size.indicator(context) / 2,
          height: EcoPlatesDesignTokens.size.indicator(context) / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: statusColor,
          ),
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD),
        Text(
          status.displayName,
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            color: statusColor,
            fontWeight: EcoPlatesDesignTokens.typography.medium,
          ),
        ),
        if (todayHours != null && !todayHours.isClosed) ...[
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            '• ${todayHours.shortFormat}',
            style: TextStyle(
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
            ),
          ),
        ],
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
      icon: Icon(
        Icons.edit,
        size: EcoPlatesDesignTokens.size.indicator(context),
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
        Icon(
          Icons.star,
          color: Colors.amber,
          size: EcoPlatesDesignTokens.size.indicator(context),
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
        Text(
          profile.rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
          ),
        ),
        SizedBox(width: context.scaleXXS_XS_SM_MD),
        Text(
          '(${profile.totalReviews} avis)',
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.hint(context),
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
