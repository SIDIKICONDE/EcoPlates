import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/app_mode_provider.dart';
import 'routes/public_routes.dart';
import 'routes/merchant_routes.dart';
import 'routes/consumer_routes.dart';
import 'routes/route_constants.dart';
import 'error_page.dart';

/// Provider pour le router de l'application EcoPlates
/// 
/// Utilise Riverpod pour la gestion d'état et la réactivité
/// selon les directives EcoPlates
final appRouterProvider = Provider<GoRouter>((ref) {
  final appMode = ref.watch(appModeProvider);
  return AppRouter.createRouter(appMode);
});

/// Configuration centralisée du router de l'application EcoPlates
/// 
/// Architecture modulaire respectant les directives EcoPlates :
/// - Séparation des responsabilités par type d'utilisateur
/// - Gestion d'erreurs personnalisée
/// - Navigation adaptative selon le mode d'application
/// - Code maintenable et extensible
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Crée et configure le router selon le mode d'application
  /// 
  /// [mode] : Mode d'application (consumer, merchant, onboarding)
  /// Retourne une instance de GoRouter configurée
  static GoRouter createRouter(AppMode mode) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: _getInitialLocation(mode),
      debugLogDiagnostics: _isDebugMode(),
      routes: _buildAllRoutes(),
      errorPageBuilder: (context, state) {
        return MaterialPage(
          child: EcoPlatesErrorPage(state: state),
        );
      },
    );
  }

  /// Détermine la route initiale selon le mode d'application
  /// 
  /// [mode] : Mode d'application actuel
  /// Retourne le chemin de la route initiale
  static String _getInitialLocation(AppMode mode) {
    switch (mode) {
      case AppMode.consumer:
        // TODO: Implémenter la logique de redirection consommateur
        return RouteConstants.merchantDashboard;
      case AppMode.merchant:
        return RouteConstants.merchantDashboard;
      case AppMode.onboarding:
        return RouteConstants.onboarding;
    }
  }

  /// Construit toutes les routes de l'application
  /// 
  /// Organise les routes par priorité et type d'utilisateur
  /// Retourne la liste complète des routes configurées
  static List<RouteBase> _buildAllRoutes() {
    return [
      // Routes publiques (priorité haute)
      ...PublicRoutes.routes,
      
      // Routes marchandes (avec et sans navigation)
      ...MerchantRoutes.allRoutes,
      
      // Routes consommateur (avec et sans navigation)
      ...ConsumerRoutes.allRoutes,
    ];
  }

  /// Détermine si le mode debug est activé
  /// 
  /// Retourne true en mode debug, false en production
  static bool _isDebugMode() {
    // TODO: Utiliser une configuration d'environnement
    return true; // Temporaire pour le développement
  }

  /// Clés de navigation pour l'accès externe
  /// 
  /// Permet l'accès aux clés de navigation depuis d'autres parties
  /// de l'application si nécessaire
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;
}