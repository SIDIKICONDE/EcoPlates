import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/router/routes/route_constants.dart';
import '../widgets/common/eco_button.dart';

/// Page de bienvenue pour choisir le type d'utilisateur
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaffoldInit(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(
                alpha: 0.8,
              ),
              Theme.of(context).primaryColor.withValues(
                alpha: 0.9,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: CenteredResponsiveLayout(
            child: ResponsiveLayout(
              mobile: _buildMobileLayout(context),
              tablet: _buildTabletLayout(context),
              desktop: _buildDesktopLayout(context),
            ),
          ),
        ),
      ),
    );
  }

  /// Layout pour mobile (écrans étroits) - Utilise les widgets responsifs
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ResponsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VerticalGap(multiplier: 2),
            _buildHeader(context),
            const VerticalGap(multiplier: 3),
            _buildButtons(context),
            const VerticalGap(multiplier: 2),
            _buildFooterMessage(context),
            const VerticalGap(multiplier: 2),
          ],
        ),
      ),
    );
  }

  /// Layout pour tablette - Utilise ResponsiveConstrainedBox
  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ResponsiveConstrainedBox(
          maxWidth: 800,
          child: ResponsiveContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context),
                const VerticalGap(multiplier: 1.5),
                ResponsiveConstrainedBox(
                  maxWidth: 400,
                  child: _buildButtons(context),
                ),
                const VerticalGap(multiplier: 1.5),
                _buildFooterMessage(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Layout pour desktop - Utilise ResponsiveColumns
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: ResponsiveConstrainedBox(
        maxWidth: 1200,
        child: ResponsiveColumns(
          sidebar: ResponsiveContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context),
              ],
            ),
          ),
          content: ResponsiveContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ResponsiveConstrainedBox(
                  maxWidth: 400,
                  child: _buildButtons(context),
                ),
                const VerticalGap(multiplier: 1.5),
                _buildFooterMessage(context),
              ],
            ),
          ),
          sidebarWidth: context.responsive(
            mobile: 300,
            tablet: 350,
            desktop: 400,
          ),
          spacing: context.horizontalSpacing,
        ),
      ),
    );
  }

  /// Header avec titre et sous-titres - Utilise ResponsiveText
  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        // Logo/Titre principal avec tailles responsives
        ResponsiveText(
          'EcoPlates',
          fontSize: FontSizes.titleLarge,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        VerticalGap(multiplier: 0.5),
        // Sous-titre de bienvenue
        ResponsiveText(
          'Bienvenue !',
          fontSize: FontSizes.subtitleLarge,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        VerticalGap(multiplier: 0.25),
        // Instructions
        ResponsiveText(
          'Choisissez votre profil',
          fontSize: FontSizes.bodyMedium,
          style: TextStyle(
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Boutons de sélection du profil - Utilise ResponsiveButton
  Widget _buildButtons(BuildContext context) {
    return ResponsiveContainer(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(
          mobile: 24.0,
          tablet: 32.0,
          desktop: 48.0,
        ),
      ),
      child: Column(
        children: [
          // Bouton Merchant avec le nouveau système EcoButton
          FractionallySizedBox(
            widthFactor: 0.8,
            child: EcoButton(
              text: 'Merchant',
              onPressed: () {
                context.go(RouteConstants.merchantStore);
              },
              icon: Icons.store,
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              size: EcoButtonSizeHelper.getAdaptiveSize(context),
            ),
          ),

          const VerticalGap(multiplier: 0.5),  // Réduction de l'espacement

          // Bouton Consommateur avec le nouveau système EcoButton
          FractionallySizedBox(
            widthFactor: 0.8,
            child: EcoButton(
              text: 'Consommateur',
              onPressed: () {
                context.go(RouteConstants.consumerDiscover);
              },
              icon: Icons.person,
              variant: EcoButtonVariant.outline,
              borderColor: Colors.white,
              foregroundColor: Colors.white,
              borderWidth: 2.0,
              size: EcoButtonSizeHelper.getAdaptiveSize(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Message informatif en bas - Utilise ResponsiveConstrainedBox et ResponsiveText
  Widget _buildFooterMessage(BuildContext context) {
    return ResponsiveConstrainedBox(
      maxWidth: 600,
      child: ResponsiveContainer(
        child: ResponsiveText(
          "Les deux options mènent à la même page d'accueil pour le moment",
          fontSize: FontSizes.bodySmall,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontStyle: FontStyle.italic,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
