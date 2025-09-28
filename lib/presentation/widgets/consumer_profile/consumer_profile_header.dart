import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/color_tokens.dart';
import '../../../core/themes/tokens/spacing_tokens.dart';
import '../../../domain/entities/user.dart';
import 'consumer_tier_utils.dart';

/// En-tête du profil consommateur avec photo et informations principales
class ConsumerProfileHeader extends StatelessWidget {
  const ConsumerProfileHeader({
    required this.user,
    super.key,
    this.onEditProfile,
    this.onEditPhoto,
  });

  final User? user;
  final VoidCallback? onEditProfile;
  final VoidCallback? onEditPhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Valeurs par défaut si pas d'utilisateur
    final displayName = user?.name ?? 'Utilisateur';
    final email = user?.email ?? 'email@example.com';
    final consumerProfile = user?.profile as ConsumerProfile?;
    final tier = consumerProfile?.tier ?? ConsumerTier.bronze;

    return Container(
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: EcoSpacing.lg,
          tablet: EcoSpacing.xl,
          desktop: EcoSpacing.xxl,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EcoColorTokens.success.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            colors.surface,
            EcoColorTokens.eco.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle / 2,
            ),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: EcoPlatesDesignTokens.radius.lg,
            tablet: EcoPlatesDesignTokens.radius.xl,
            desktop: EcoPlatesDesignTokens.radius.xxl,
          ),
        ),
        border: Border.all(
          color: EcoColorTokens.success.withValues(
            alpha: EcoPlatesDesignTokens.opacity.verySubtle,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: EcoColorTokens.success.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.largeBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset * 2,
          ),
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Éléments décoratifs écologiques
          Positioned(
            top: -context.scaleMD_LG_XL_XXL,
            right: -context.scaleMD_LG_XL_XXL,
            child: Icon(
              Icons.eco,
              size: EcoPlatesDesignTokens.size.minTouchTarget,
              color: EcoColorTokens.success.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
            ),
          ),
          Positioned(
            bottom: -context.scaleXXS_XS_SM_MD,
            left: -context.scaleXXS_XS_SM_MD,
            child: Icon(
              Icons.recycling,
              size: EcoPlatesDesignTokens.size.buttonHeight(context) * 1.33,
              color: EcoColorTokens.eco.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
            ),
          ),
          Positioned(
            top: context.scaleLG_XL_XXL_XXXL,
            left: context.scaleLG_XL_XXL_XXXL,
            child: Icon(
              Icons.spa,
              size: EcoPlatesDesignTokens.size.buttonHeight(context),
              color: EcoColorTokens.success.withValues(
                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
              ),
            ),
          ),

          // Contenu principal
          Column(
            children: [
              Row(
                children: [
                  // Photo de profil
                  Stack(
                    children: [
                      // Cercle extérieur décoratif
                      Container(
                        width: context.responsiveValue(
                          mobile: 80.0.toDouble(),
                          tablet: 90.0.toDouble(),
                          desktop: DesignConstants.hundred.toDouble(),
                        ),
                        height: context.responsiveValue(
                          mobile: 80.0.toDouble(),
                          tablet: 90.0.toDouble(),
                          desktop: DesignConstants.hundred.toDouble(),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              EcoColorTokens.success.withValues(
                                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                              ),
                              EcoColorTokens.eco.withValues(
                                alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: context.responsiveValue(
                          mobile: 36.0,
                          tablet: 42.0,
                          desktop: 48.0,
                        ),
                        backgroundColor: colors.surface,
                        child: CircleAvatar(
                          radius: context.responsiveValue(
                            mobile: 34.0,
                            tablet: 40.0,
                            desktop: 46.0,
                          ),
                          backgroundColor: colors.primaryContainer,
                          child: Text(
                            _getInitials(displayName),
                            style: textTheme.headlineMedium?.copyWith(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (onEditPhoto != null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(
                              context.scaleXXS_XS_SM_MD,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.surface,
                                width: DesignConstants.two,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size:
                                  EcoPlatesDesignTokens.size.icon(context) *
                                  0.8,
                              color: colors.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: context.responsiveValue(
                      mobile: EcoSpacing.md,
                      tablet: EcoSpacing.lg,
                      desktop: EcoSpacing.xl,
                    ),
                  ),

                  // Informations utilisateur
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.scaleXXS_XS_SM_MD),
                        Text(
                          email,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withValues(
                              alpha:
                                  EcoPlatesDesignTokens.opacity.semiTransparent,
                            ),
                          ),
                        ),
                        SizedBox(height: context.scaleXS_SM_MD_LG),

                        // Badge de niveau
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.scaleMD_LG_XL_XXL,
                            vertical: context.scaleXXS_XS_SM_MD,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ConsumerTierUtils.getTierColor(
                                  tier,
                                  brightness: Theme.of(context).brightness,
                                ).withValues(
                                  alpha:
                                      EcoPlatesDesignTokens.opacity.verySubtle,
                                ),
                            borderRadius: BorderRadius.circular(
                              EcoPlatesDesignTokens.radius.md,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getTierIcon(tier),
                                size:
                                    EcoPlatesDesignTokens.size.icon(context) *
                                    0.8,
                                color: ConsumerTierUtils.getTierColor(
                                  tier,
                                  brightness: Theme.of(context).brightness,
                                ),
                              ),
                              SizedBox(width: context.scaleXXS_XS_SM_MD),
                              Text(
                                _getTierLabel(tier),
                                style: textTheme.labelSmall?.copyWith(
                                  color: ConsumerTierUtils.getTierColor(
                                    tier,
                                    brightness: Theme.of(context).brightness,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bouton d'édition
                  if (onEditProfile != null)
                    IconButton(
                      onPressed: onEditProfile,
                      icon: Icon(
                        Icons.edit,
                        color: colors.primary,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: colors.primaryContainer.withValues(
                          alpha: EcoPlatesDesignTokens.opacity.subtle,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(
                height: context.responsiveValue(
                  mobile: EcoSpacing.md,
                  tablet: EcoSpacing.lg,
                  desktop: EcoSpacing.xl,
                ),
              ),

              // Statistiques rapides avec fond décoratif
              Container(
                padding: EdgeInsets.all(
                  context.responsiveValue(
                    mobile: EcoSpacing.md,
                    tablet: EcoSpacing.lg,
                    desktop: EcoSpacing.xl,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: context.responsiveValue(
                    mobile: EcoSpacing.xs,
                    tablet: EcoSpacing.sm,
                    desktop: EcoSpacing.md,
                  ),
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
                  ),
                  borderRadius: BorderRadius.circular(
                    context.responsiveValue(
                      mobile: EcoPlatesDesignTokens.radius.md,
                      tablet: EcoPlatesDesignTokens.radius.lg,
                      desktop: EcoPlatesDesignTokens.radius.xl,
                    ),
                  ),
                  border: Border.all(
                    color: EcoColorTokens.success.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                    ),
                  ),
                ),
                child: context.isMobileDevice
                    ? Column(
                        children: _buildMobileStats(context, consumerProfile),
                      )
                    : Row(
                        children: _buildDesktopStats(context, consumerProfile),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMobileStats(
    BuildContext context,
    ConsumerProfile? consumerProfile,
  ) {
    final colors = Theme.of(context).colorScheme;
    return [
      Row(
        children: [
          Expanded(
            child: _buildQuickStat(
              context,
              'EcoScore',
              '${consumerProfile?.ecoScore ?? 0}',
              Icons.eco,
              EcoColorTokens.success,
            ),
          ),
          const SizedBox(width: EcoSpacing.sm),
          Expanded(
            child: _buildQuickStat(
              context,
              'Assiettes utilisées',
              '${consumerProfile?.totalPlatesUsed ?? 0}',
              Icons.dinner_dining,
              colors.primary,
            ),
          ),
        ],
      ),
      const SizedBox(height: EcoSpacing.sm),
      _buildQuickStat(
        context,
        'CO₂ économisé',
        '${(consumerProfile?.co2Saved ?? 0).toStringAsFixed(1)} kg',
        Icons.recycling,
        EcoColorTokens.info,
      ),
    ];
  }

  List<Widget> _buildDesktopStats(
    BuildContext context,
    ConsumerProfile? consumerProfile,
  ) {
    final colors = Theme.of(context).colorScheme;
    return [
      Expanded(
        child: _buildQuickStat(
          context,
          'EcoScore',
          '${consumerProfile?.ecoScore ?? 0}',
          Icons.eco,
          EcoColorTokens.success,
        ),
      ),
      _buildVerticalDivider(context),
      Expanded(
        child: _buildQuickStat(
          context,
          'Assiettes utilisées',
          '${consumerProfile?.totalPlatesUsed ?? 0}',
          Icons.dinner_dining,
          colors.primary,
        ),
      ),
      _buildVerticalDivider(context),
      Expanded(
        child: _buildQuickStat(
          context,
          'CO₂ économisé',
          '${(consumerProfile?.co2Saved ?? 0).toStringAsFixed(1)} kg',
          Icons.recycling,
          EcoColorTokens.info,
        ),
      ),
    ];
  }

  Widget _buildVerticalDivider(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: context.responsiveValue(
        mobile: 40.0,
        tablet: 50.0,
        desktop: 60.0,
      ),
      width: DesignConstants.one,
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          mobile: EcoSpacing.xs,
          tablet: EcoSpacing.sm,
          desktop: EcoSpacing.md,
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            colors.outline.withValues(
              alpha: EcoPlatesDesignTokens.opacity.subtle,
            ),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      children: [
        Icon(
          icon,
          size: context.responsiveValue(
            mobile: context.scaleIconStandard * 0.9,
            tablet: context.scaleIconStandard,
            desktop: context.scaleIconStandard * 1.1,
          ),
          color: color,
        ),
        SizedBox(height: context.scaleXXS_XS_SM_MD),
        Text(
          value,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  IconData _getTierIcon(ConsumerTier tier) {
    switch (tier) {
      case ConsumerTier.bronze:
        return Icons.military_tech;
      case ConsumerTier.silver:
        return Icons.military_tech;
      case ConsumerTier.gold:
        return Icons.stars;
      case ConsumerTier.platinum:
        return Icons.diamond;
    }
  }

  String _getTierLabel(ConsumerTier tier) {
    switch (tier) {
      case ConsumerTier.bronze:
        return 'Bronze';
      case ConsumerTier.silver:
        return 'Argent';
      case ConsumerTier.gold:
        return 'Or';
      case ConsumerTier.platinum:
        return 'Platine';
    }
  }
}
