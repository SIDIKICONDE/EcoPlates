import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Configuration d'une grille responsive
class ResponsiveGridConfig {
  const ResponsiveGridConfig({
    this.mobile = 1,
    this.tablet,
    this.desktop,
    this.desktopLarge,
    this.spacing = 8.0,
    this.aspectRatio = 1.0,
  });

  final int mobile;
  final int? tablet;
  final int? desktop;
  final int? desktopLarge;
  final double spacing;
  final double aspectRatio;

  /// Nombre de colonnes selon le device type
  int getColumnCount(BuildContext context) {
    final type = Breakpoints.deviceTypeOf(context);
    switch (type) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? desktop ?? desktopLarge ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? desktopLarge ?? mobile;
      case DeviceType.desktopLarge:
        return desktopLarge ?? desktop ?? tablet ?? mobile;
    }
  }
}

/// Widget grille responsive qui s'adapte automatiquement selon le device
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.config = const ResponsiveGridConfig(),
    super.key,
  });

  final List<Widget> children;
  final ResponsiveGridConfig config;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = config.getColumnCount(context);
        final itemWidth = (constraints.maxWidth - (columnCount - 1) * config.spacing) / columnCount;

        return Wrap(
          spacing: config.spacing,
          runSpacing: config.spacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: AspectRatio(
                aspectRatio: config.aspectRatio,
                child: child,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Widget pour créer une grille avec un nombre fixe d'éléments par ligne
class FixedResponsiveGrid extends StatelessWidget {
  const FixedResponsiveGrid({
    required this.children,
    required this.crossAxisCount,
    this.spacing = 8.0,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.aspectRatio = 1.0,
    super.key,
  });

  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing ?? spacing,
      mainAxisSpacing: mainAxisSpacing ?? spacing,
      childAspectRatio: aspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }
}

/// Extension pour créer facilement des grilles responsives
extension ResponsiveGridExtension on List<Widget> {
  /// Convertit la liste en grille responsive
  Widget toResponsiveGrid({
    ResponsiveGridConfig config = const ResponsiveGridConfig(),
  }) {
    return ResponsiveGrid(
      children: this,
      config: config,
    );
  }

  /// Convertit la liste en grille avec nombre fixe de colonnes
  Widget toFixedGrid({
    required int crossAxisCount,
    double spacing = 8.0,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double aspectRatio = 1.0,
  }) {
    return FixedResponsiveGrid(
      children: this,
      crossAxisCount: crossAxisCount,
      spacing: spacing,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      aspectRatio: aspectRatio,
    );
  }
}
