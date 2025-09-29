import 'package:flutter/material.dart';

import '../../../core/themes/tokens/color_tokens.dart';
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
        16.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            EcoColorTokens.success.withValues(
              alpha: 0.01,
            ),
            colors.surface,
            EcoColorTokens.eco.withValues(
              alpha: 0.01 / 2,
            ),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
        border: Border.all(
          color: EcoColorTokens.success.withValues(
            alpha: 0.01,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: EcoColorTokens.success.withValues(
              alpha: 0.01,
            ),
            blurRadius: 12.0,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: 0.01,
            ),
            blurRadius: 8.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Éléments décoratifs écologiques
          Positioned(
            top: -16.0,
            right: -16.0,
            child: Icon(
              Icons.eco,
              size: 48.0,
              color: EcoColorTokens.success.withValues(
                alpha: 0.01,
              ),
            ),
          ),
          Positioned(
            bottom: -4.0,
            left: -4.0,
            child: Icon(
              Icons.recycling,
              size: 56.0 * 1.33,
              color: EcoColorTokens.eco.withValues(
                alpha: 0.01,
              ),
            ),
          ),
          Positioned(
            top: 24.0,
            left: 24.0,
            child: Icon(
              Icons.spa,
              size: 56.0,
              color: EcoColorTokens.success.withValues(
                alpha: 0.01,
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
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              EcoColorTokens.success.withValues(
                                alpha: 0.01,
                              ),
                              EcoColorTokens.eco.withValues(
                                alpha: 0.01,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 36.0,
                        backgroundColor: colors.surface,
                        child: CircleAvatar(
                          radius: 34.0,
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
                              4.0,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.surface,
                                width: 2.0,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20.0 * 0.8,
                              color: colors.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 16.0,
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
                        SizedBox(height: 4.0),
                        Text(
                          email,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),

                        // Badge de niveau
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ConsumerTierUtils.getTierColor(
                                  tier,
                                  brightness: Theme.of(context).brightness,
                                ).withValues(
                                  alpha: 0.01,
                                ),
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getTierIcon(tier),
                                size: 20.0 * 0.8,
                                color: ConsumerTierUtils.getTierColor(
                                  tier,
                                  brightness: Theme.of(context).brightness,
                                ),
                              ),
                              SizedBox(width: 4.0),
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
                          alpha: 0.3,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(
                height: 16.0,
              ),

              // Statistiques rapides avec fond décoratif
              Container(
                padding: EdgeInsets.all(16.0),
                margin: EdgeInsets.only(
                  top: 8.0,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(
                    alpha: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: EcoColorTokens.success.withValues(
                      alpha: 0.01,
                    ),
                  ),
                ),
                child: MediaQuery.of(context).size.width < 600
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
          const SizedBox(width: 8.0),
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
      const SizedBox(height: 8.0),
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
      height: 40.0,
      width: 1.0,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            colors.outline.withValues(
              alpha: 0.3,
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
          size: 24.0,
          color: color,
        ),
        SizedBox(height: 4.0),
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
              alpha: 0.9,
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
