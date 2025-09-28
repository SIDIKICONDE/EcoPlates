import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';
import '../../core/router/routes/route_constants.dart';
import '../widgets/common/responsive_button.dart';

/// Page de bienvenue pour choisir le type d'utilisateur
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(
                alpha: EcoPlatesDesignTokens.opacity.gradientPrimary,
              ),
              Theme.of(context).primaryColor.withValues(
                alpha: EcoPlatesDesignTokens.opacity.gradientSecondary,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: _buildMobileLayout,
            tablet: _buildTabletLayout,
            desktop: _buildDesktopLayout,
            desktopLarge: _buildDesktopLayout,
          ),
        ),
      ),
    );
  }

  /// Layout pour mobile (écrans étroits)
  Widget _buildMobileLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    // Adaptation pour très petits écrans
    final isVerySmallScreen =
        availableHeight < EcoPlatesDesignTokens.layout.verySmallScreenThreshold;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: availableHeight,
          minWidth: screenWidth,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: isVerySmallScreen
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              SizedBox(
                height: isVerySmallScreen
                    ? EcoPlatesDesignTokens.layout.compactScreenSpacing
                    : EcoPlatesDesignTokens.layout.mobileScreenSpacing,
              ),
              _buildHeader(context),
              Flexible(
                child: SizedBox(
                  height: isVerySmallScreen
                      ? EcoPlatesDesignTokens.layout.compactScreenSpacing *
                            EcoPlatesDesignTokens.layout.extendedSpacingFactor /
                            EcoPlatesDesignTokens.layout.verySmallScreenFactor
                      : EcoPlatesDesignTokens.layout.mobileSectionSpacing,
                ),
              ),
              _buildButtons(context),
              Flexible(
                child: SizedBox(
                  height: isVerySmallScreen
                      ? EcoPlatesDesignTokens.layout.compactScreenSpacing *
                            (EcoPlatesDesignTokens
                                        .layout
                                        .extendedSpacingFactor /
                                    EcoPlatesDesignTokens
                                        .layout
                                        .verySmallScreenFactor)
                                .round()
                      : EcoPlatesDesignTokens.layout.mobileContentSpacing,
                ),
              ),
              _buildFooterMessage(context),
              SizedBox(
                height: isVerySmallScreen
                    ? EcoPlatesDesignTokens.layout.compactScreenSpacing
                    : EcoPlatesDesignTokens.layout.mobileScreenSpacing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout pour tablette
  Widget _buildTabletLayout(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    // Adaptation selon l'orientation
    final isLandscape = orientation == Orientation.landscape;
    final containerWidth = isLandscape
        ? screenWidth * EcoPlatesDesignTokens.layout.landscapeContainerRatio
        : screenWidth * EcoPlatesDesignTokens.layout.portraitContainerRatio;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: containerWidth.clamp(
              EcoPlatesDesignTokens.layout.mainContainerMinWidth,
              EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context),
            ),
            minHeight:
                screenHeight *
                EcoPlatesDesignTokens.layout.minContainerHeightRatio,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(context),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: EcoPlatesDesignTokens.layout.buttonSectionMaxWidth(
                    context,
                  ),
                ),
                child: _buildButtons(context),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
              ),
              _buildFooterMessage(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout pour desktop
  Widget _buildDesktopLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeDesktop =
        screenWidth > EcoPlatesDesignTokens.layout.largeDesktopThreshold;

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: EcoPlatesDesignTokens.layout.mainContainerMaxWidth(context),
        ),
        child: Row(
          children: [
            // Côté gauche - Header
            Expanded(
              flex: isLargeDesktop
                  ? EcoPlatesDesignTokens.layout.largeDesktopMainFlex
                  : EcoPlatesDesignTokens.layout.standardFlex,
              child: Container(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.layout.sectionPadding(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(context),
                  ],
                ),
              ),
            ),
            // Séparateur visuel optionnel
            Container(
              width: EcoPlatesDesignTokens.layout.verticalSeparatorWidth,
              height: EcoPlatesDesignTokens.layout.separatorHeight,
              color: EcoPlatesDesignTokens.colors.decorative,
              margin: EdgeInsets.symmetric(
                horizontal:
                    EcoPlatesDesignTokens.layout.separatorHorizontalMargin,
              ),
            ),
            // Côté droit - Boutons et message
            Expanded(
              flex: isLargeDesktop
                  ? EcoPlatesDesignTokens.layout.largeDesktopSecondaryFlex
                  : EcoPlatesDesignTokens.layout.standardFlex,
              child: Container(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.layout.sectionPadding(context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: EcoPlatesDesignTokens.layout
                            .buttonSectionMaxWidth(context),
                      ),
                      child: _buildButtons(context),
                    ),
                    SizedBox(
                      height: EcoPlatesDesignTokens.spacing.sectionSpacing(
                        context,
                      ),
                    ),
                    _buildFooterMessage(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header avec titre et sous-titres
  Widget _buildHeader(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isVerySmallScreen =
        screenHeight < EcoPlatesDesignTokens.layout.verySmallScreenThreshold;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo/Titre principal avec adaptation pour très petits écrans
        Text(
          'EcoPlates',
          style: TextStyle(
            fontSize: isVerySmallScreen
                ? EcoPlatesDesignTokens.typography.titleSize(context) *
                      EcoPlatesDesignTokens.layout.verySmallScreenFactor
                : EcoPlatesDesignTokens.typography.titleSize(context),
            fontWeight: EcoPlatesDesignTokens.typography.bold,
            color: EcoPlatesDesignTokens.colors.textPrimary,
            letterSpacing: EcoPlatesDesignTokens.typography.titleLetterSpacing(
              context,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: EcoPlatesDesignTokens.spacing.sm),
        // Sous-titre de bienvenue
        Text(
          'Bienvenue !',
          style: TextStyle(
            fontSize: isVerySmallScreen
                ? EcoPlatesDesignTokens.typography.subtitleSize(context) *
                      EcoPlatesDesignTokens.layout.verySmallScreenFactor
                : EcoPlatesDesignTokens.typography.subtitleSize(context),
            color: EcoPlatesDesignTokens.colors.textPrimary,
            fontWeight: EcoPlatesDesignTokens.typography.regular,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: EcoPlatesDesignTokens.spacing.xs),
        // Instructions
        Text(
          'Choisissez votre profil',
          style: TextStyle(
            fontSize: EcoPlatesDesignTokens.typography.text(context),
            color: EcoPlatesDesignTokens.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Boutons de sélection du profil
  Widget _buildButtons(BuildContext context) {
    final buttonSpacing = EcoPlatesDesignTokens.spacing.md;

    final horizontalPadding = context.responsiveValue(
      mobile: EcoPlatesDesignTokens.spacing.lg,
      tablet: EcoPlatesDesignTokens.radius.none,
      desktop: EcoPlatesDesignTokens.radius.none,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          // Bouton Merchant
          FractionallySizedBox(
            widthFactor: EcoPlatesDesignTokens.layout.buttonWidthFactor(
              context,
            ),
            child: ResponsiveButton(
              isFullWidth: false,
              text: 'Merchant',
              icon: Icons.store,
              onPressed: () {
                context.go(RouteConstants.merchantStore);
              },
            ),
          ),

          SizedBox(height: buttonSpacing),

          // Bouton Consommateur
          FractionallySizedBox(
            widthFactor: EcoPlatesDesignTokens.layout.buttonWidthFactor(
              context,
            ),
            child: ResponsiveButton(
              isFullWidth: false,
              text: 'Consommateur',
              icon: Icons.person,
              variant: ButtonVariant.secondary,
              onPressed: () {
                context.go(RouteConstants.consumerDiscover);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Message informatif en bas
  Widget _buildFooterMessage(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    final horizontalPadding = context.responsiveValue(
      mobile:
          screenWidth < EcoPlatesDesignTokens.layout.veryNarrowScreenThreshold
          ? EcoPlatesDesignTokens.spacing.md
          : EcoPlatesDesignTokens.spacing.xxxl,
      tablet: isLandscape
          ? EcoPlatesDesignTokens.spacing.xxxl
          : EcoPlatesDesignTokens.spacing.xxl,
      desktop: EcoPlatesDesignTokens.spacing.xxxl,
      desktopLarge:
          EcoPlatesDesignTokens.spacing.xxxl *
          EcoPlatesDesignTokens.layout.extendedSpacingFactor,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: EcoPlatesDesignTokens.layout.contentContainerMaxWidth(
          context,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Text(
        "Les deux options mènent à la même page d'accueil pour le moment",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.hint(context),
          color: EcoPlatesDesignTokens.colors.textSecondary,
          fontStyle: FontStyle.italic,
          height: EcoPlatesDesignTokens.layout.textLineHeight,
        ),
      ),
    );
  }
}
