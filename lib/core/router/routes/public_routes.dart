import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/screens/main_home_screen.dart';
import 'route_constants.dart';

/// Configuration des routes publiques
/// 
/// Routes accessibles sans authentification ou navigation spécifique
/// selon les directives EcoPlates
class PublicRoutes {
  /// Routes publiques de base
  static List<RouteBase> get routes => [
    // Route d'onboarding (sans navigation)
    GoRoute(
      path: RouteConstants.onboarding,
      name: RouteConstants.onboardingName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: MainHomeScreen());
      },
    ),

    // Page d'accueil principale
    GoRoute(
      path: RouteConstants.mainHome,
      name: RouteConstants.mainHomeName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: MainHomeScreen());
      },
    ),
  ];
}
