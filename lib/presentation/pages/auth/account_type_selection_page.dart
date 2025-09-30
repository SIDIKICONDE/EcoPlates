import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';

class AccountTypeSelectionPage extends StatelessWidget {
  const AccountTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeepColorTokens.surface,
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: (_) => _buildMobileLayout(context),
          tablet: (_) => _buildTabletLayout(context),
          desktop: (_) => _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.verticalSpacing * 2),
          _buildHeader(context),
          SizedBox(height: context.verticalSpacing * 4),
          _buildConsumerCard(context),
          SizedBox(height: context.verticalSpacing * 2),
          _buildMerchantCard(context),
          SizedBox(height: context.verticalSpacing * 3),
          _buildLoginOption(context),
          SizedBox(height: context.verticalSpacing * 2),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(context.horizontalSpacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(context),
            SizedBox(height: context.verticalSpacing * 4),
            Row(
              children: [
                Expanded(child: _buildConsumerCard(context)),
                SizedBox(width: context.horizontalSpacing * 2),
                Expanded(child: _buildMerchantCard(context)),
              ],
            ),
            SizedBox(height: context.verticalSpacing * 3),
            _buildLoginOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Panneau gauche avec l'image de marque
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DeepColorTokens.primary,
                  DeepColorTokens.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 120,
                    color: Colors.white,
                  ),
                  SizedBox(height: context.verticalSpacing * 2),
                  Text(
                    'EcoPlates',
                    style: TextStyle(
                      fontSize: FontSizes.titleLarge.getSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.verticalSpacing),
                  Text(
                    'Sauvons la planète, une assiette à la fois',
                    style: TextStyle(
                      fontSize: FontSizes.bodyLarge.getSize(context),
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Panneau droit avec les options
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(context.horizontalSpacing * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  SizedBox(height: context.verticalSpacing * 4),
                  _buildConsumerCard(context),
                  SizedBox(height: context.verticalSpacing * 2),
                  _buildMerchantCard(context),
                  SizedBox(height: context.verticalSpacing * 3),
                  _buildLoginOption(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        if (!context.isDesktop) ...[
          Icon(
            Icons.eco_rounded,
            size: 80,
            color: DeepColorTokens.primary,
          ),
          SizedBox(height: context.verticalSpacing * 2),
        ],
        Text(
          'Bienvenue sur EcoPlates',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSizes.titleLarge.getSize(context),
            fontWeight: FontWeight.bold,
            color: DeepColorTokens.textPrimary,
          ),
        ),
        SizedBox(height: context.verticalSpacing),
        Text(
          'Choisissez le type de compte qui vous correspond',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: FontSizes.bodyLarge.getSize(context),
            color: DeepColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConsumerCard(BuildContext context) {
    return _AccountTypeCard(
      icon: Icons.person_outline_rounded,
      iconColor: DeepColorTokens.success,
      title: 'Je suis consommateur',
      subtitle: 'Trouvez des offres incroyables près de chez vous',
      features: const [
        'Découvrez des repas à prix réduits',
        'Réduisez le gaspillage alimentaire',
        'Soutenez les commerces locaux',
        'Gagnez des points de fidélité',
      ],
      onTap: () => context.push('/auth/signup/consumer'),
    );
  }

  Widget _buildMerchantCard(BuildContext context) {
    return _AccountTypeCard(
      icon: Icons.store_outlined,
      iconColor: DeepColorTokens.primary,
      title: 'Je suis marchand',
      subtitle: 'Vendez vos invendus et attirez de nouveaux clients',
      features: const [
        'Réduisez vos pertes',
        'Atteignez de nouveaux clients',
        'Gestion simplifiée des stocks',
        'Analyses et statistiques détaillées',
      ],
      onTap: () => context.push('/auth/signup/merchant'),
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Vous avez déjà un compte ?',
          style: TextStyle(
            fontSize: FontSizes.bodyMedium.getSize(context),
            color: DeepColorTokens.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => context.push('/auth/login'),
          child: Text(
            'Se connecter',
            style: TextStyle(
              fontSize: FontSizes.bodyMedium.getSize(context),
              color: DeepColorTokens.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Carte pour le choix du type de compte
class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<String> features;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.borderRadius * 1.5),
        side: BorderSide(
          color: DeepColorTokens.divider,
          width: 1,
        ),
      ),
      color: DeepColorTokens.surfaceBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.borderRadius * 1.5),
        child: Padding(
          padding: EdgeInsets.all(context.horizontalSpacing * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec icône et titre
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.horizontalSpacing),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.borderRadius),
                    ),
                    child: Icon(
                      icon,
                      size: ResponsiveUtils.getIconSize(context) * 1.5,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(width: context.horizontalSpacing),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: FontSizes.titleMedium.getSize(context),
                            fontWeight: FontWeight.bold,
                            color: DeepColorTokens.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.verticalSpacing / 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: FontSizes.bodySmall.getSize(context),
                            color: DeepColorTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Liste des caractéristiques
              if (features.isNotEmpty) ...[
                SizedBox(height: context.verticalSpacing * 1.5),
                ...features.map(
                  (feature) => Padding(
                    padding: EdgeInsets.only(
                      bottom: context.verticalSpacing / 2,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: ResponsiveUtils.getIconSize(context) * 0.8,
                          color: DeepColorTokens.success,
                        ),
                        SizedBox(width: context.horizontalSpacing / 2),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              fontSize: FontSizes.bodySmall.getSize(context),
                              color: DeepColorTokens.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Bouton d'action
              SizedBox(height: context.verticalSpacing),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: context.verticalSpacing,
                ),
                decoration: BoxDecoration(
                  color: DeepColorTokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Commencer',
                      style: TextStyle(
                        fontSize: FontSizes.bodyMedium.getSize(context),
                        color: DeepColorTokens.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: context.horizontalSpacing / 2),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: ResponsiveUtils.getIconSize(context),
                      color: DeepColorTokens.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
