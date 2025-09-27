import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

/// Widget utilitaire qui permet de fournir un builder par type d'appareil
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.desktopLarge,
    super.key,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;
  final WidgetBuilder? desktopLarge;

  @override
  Widget build(BuildContext context) {
    final type = Breakpoints.deviceTypeOf(context);
    switch (type) {
      case DeviceType.mobile:
        return mobile(context);
      case DeviceType.tablet:
        return (tablet ?? desktop ?? desktopLarge ?? mobile)(context);
      case DeviceType.desktop:
        return (desktop ?? tablet ?? desktopLarge ?? mobile)(context);
      case DeviceType.desktopLarge:
        return (desktopLarge ?? desktop ?? tablet ?? mobile)(context);
    }
  }
}
