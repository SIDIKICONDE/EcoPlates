import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// Widget de layout responsive qui adapte automatiquement le contenu
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.child,
    this.breakpoints,
  }) : assert(
         mobile != null || child != null,
         'Au moins mobile ou child doit être fourni',
       );

  /// Widget pour mobile (< 600px)
  final Widget? mobile;

  /// Widget pour tablette (600-904px)
  final Widget? tablet;

  /// Widget pour desktop (>= 905px)
  final Widget? desktop;

  /// Widget par défaut si les autres ne sont pas fournis
  final Widget? child;

  /// Breakpoints personnalisés (optionnel)
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile ?? child!;
      case DeviceType.tablet:
        return tablet ?? mobile ?? child!;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile ?? child!;
    }
  }
}

/// Layout avec contenu centré et largeur maximale
class CenteredResponsiveLayout extends StatelessWidget {
  const CenteredResponsiveLayout({
    required this.child,
    super.key,
    this.maxWidth,
    this.padding,
    this.backgroundColor,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Container(
          width: maxWidth ?? context.maxContentWidth,
          padding: padding ?? context.responsivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Layout en grille responsive
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.desktopLargeColumns, // Nouveau : pour les écrans >= 1440px
    this.spacing = 16,
    this.runSpacing,
    this.childAspectRatio,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int? desktopLargeColumns; // Nouveau : pour les écrans >= 1440px
  final double spacing;
  final double? runSpacing;
  final double? childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveColumns(
      context,
      mobileColumns: mobileColumns,
      tabletColumns: tabletColumns,
      desktopColumns: desktopColumns,
      desktopLargeColumns: desktopLargeColumns,
    );

    return GridView.builder(
      physics: physics,
      shrinkWrap: shrinkWrap,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing ?? spacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Layout wrap responsive
class ResponsiveWrap extends StatelessWidget {
  const ResponsiveWrap({
    required this.children,
    super.key,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.direction = Axis.horizontal,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.isMobile ? spacing : spacing * 1.5,
      runSpacing: context.isMobile ? runSpacing : runSpacing * 1.5,
      alignment: alignment,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
      direction: direction,
      children: children,
    );
  }
}

/// Layout de colonnes responsive (sidebar + contenu)
class ResponsiveColumns extends StatelessWidget {
  const ResponsiveColumns({
    required this.sidebar,
    required this.content,
    super.key,
    this.sidebarWidth = 300,
    this.spacing = 16,
    this.stackOnMobile = true,
    this.sidebarFirst = true,
  });

  final Widget sidebar;
  final Widget content;
  final double sidebarWidth;
  final double spacing;
  final bool stackOnMobile;
  final bool sidebarFirst;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile && stackOnMobile) {
      // Sur mobile, empiler verticalement
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: sidebarFirst
            ? [
                sidebar,
                SizedBox(height: spacing),
                // Pas d'Expanded ici pour éviter les contraintes non bornées
                content,
              ]
            : [
                content,
                SizedBox(height: spacing),
                sidebar,
              ],
      );
    }

    // Sur tablet/desktop, afficher côte à côte
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sidebarFirst
          ? [
              SizedBox(width: sidebarWidth, child: sidebar),
              SizedBox(width: spacing),
              Expanded(child: content),
            ]
          : [
              Expanded(child: content),
              SizedBox(width: spacing),
              SizedBox(width: sidebarWidth, child: sidebar),
            ],
    );
  }
}

/// Scaffold responsive avec navigation adaptative
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.useNavigationRail = true,
    this.railDestinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool useNavigationRail;
  final List<NavigationRailDestination>? railDestinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      appBar: appBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: context.isMobile ? bottomNavigationBar : null,
      backgroundColor: backgroundColor,
      body: _buildBody(context),
    );

    return scaffold;
  }

  Widget _buildBody(BuildContext context) {
    if (!context.isMobile && useNavigationRail && railDestinations != null) {
      return Row(
        children: [
          NavigationRail(
            destinations: railDestinations!,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: context.isDesktop,
            minExtendedWidth: 200,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      );
    }

    return body;
  }
}

/// Breakpoints personnalisés
class ResponsiveBreakpoints {
  const ResponsiveBreakpoints({
    this.mobile = 600,
    this.tablet = 905,
    this.desktop = 1240,
  });

  final double mobile;
  final double tablet;
  final double desktop;
}

/// Widget qui s'adapte automatiquement à la taille de l'écran
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.builder,
    super.key,
    this.breakpoints,
  });

  final Widget Function(
    BuildContext context,
    DeviceType deviceType,
    Size screenSize,
  )
  builder;
  final ResponsiveBreakpoints? breakpoints;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final deviceType = ResponsiveUtils.getDeviceType(context);

    return builder(context, deviceType, screenSize);
  }
}

/// Grille responsive optimisée pour les cartes avec hauteur contrôlée
class ResponsiveCardGrid extends StatelessWidget {
  const ResponsiveCardGrid({
    required this.children,
    super.key,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16.0,
    this.runSpacing,
    this.maxCardHeight = 160.0,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double? runSpacing;
  final double maxCardHeight;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 905;

    final columns = isMobile
        ? mobileColumns
        : isTablet
        ? tabletColumns
        : desktopColumns;

    final itemWidth = (screenWidth - (columns + 1) * spacing) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing ?? spacing,
      children: children
          .map(
            (child) => SizedBox(
              width: itemWidth,
              child: Container(
                constraints: BoxConstraints(maxHeight: maxCardHeight),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Container avec padding responsive
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? context.responsivePadding,
      margin: margin,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      constraints: constraints,
      alignment: alignment,
      child: child,
    );
  }
}
