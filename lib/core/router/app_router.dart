import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/browse_page.dart';
import '../../presentation/providers/app_mode_provider.dart';
import '../../presentation/screens/all_brands_screen.dart';
import '../../presentation/screens/all_urgent_offers_screen.dart';
import '../../presentation/screens/main_home_screen.dart';
import '../../presentation/screens/welcome_screen.dart';
import '../../presentation/widgets/app_shell.dart';
import '../constants/env_config.dart';
import 'error_page.dart';
import 'routes/public_routes.dart';
import 'routes/route_constants.dart';

/// Provider pour le router de l'application EcoPlates
/// 
/// Utilise Riverpod pour la gestion d'état et la réactivité
/// selon les directives EcoPlates
final appRouterProvider = Provider<GoRouter>((ref) {
  final appMode = ref.watch(appModeProvider);
  return AppRouter.createRouter(appMode);
});

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
    // Commencer par la page de bienvenue
    return RouteConstants.welcome;
  }

  /// Construit toutes les routes de l'application
  /// 
  /// Organise les routes par priorité et type d'utilisateur
  /// Retourne la liste complète des routes configurées
  static List<RouteBase> _buildAllRoutes() {
    return [
      // Page de bienvenue (première page)
      GoRoute(
        path: RouteConstants.welcome,
        name: RouteConstants.welcomeName,
        pageBuilder: (context, state) {
          return const MaterialPage(child: WelcomeScreen());
        },
      ),
      
      // Page toutes les marques
      GoRoute(
        path: RouteConstants.allBrands,
        name: RouteConstants.allBrandsName,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AllBrandsScreen());
        },
      ),
      
      // Page offres urgentes à sauver
      GoRoute(
        path: RouteConstants.urgentOffers,
        name: RouteConstants.urgentOffersName,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AllUrgentOffersScreen());
        },
      ),
      
      // Routes publiques
      ...PublicRoutes.routes,
      
      // Shell unifié (consumer + merchant)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          // Merchant routes (tabs)
          GoRoute(
            path: RouteConstants.merchantDashboard,
            name: RouteConstants.merchantDashboardName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.merchantStock,
            name: RouteConstants.merchantStockName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.merchantStore,
            name: RouteConstants.merchantStoreName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.merchantSales,
            name: RouteConstants.merchantSalesName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.merchantAnalytics,
            name: RouteConstants.merchantAnalyticsName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: '/merchant/home',
            name: 'merchant-home',
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),

          // Consumer routes (tabs)
          GoRoute(
            path: RouteConstants.consumerDiscover,
            name: RouteConstants.consumerDiscoverName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.consumerBrowse,
            name: RouteConstants.consumerBrowseName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: BrowsePage());
            },
          ),
          GoRoute(
            path: RouteConstants.consumerFavorites,
            name: RouteConstants.consumerFavoritesName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.consumerCart,
            name: RouteConstants.consumerCartName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.consumerDelivery,
            name: RouteConstants.consumerDeliveryName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
          GoRoute(
            path: RouteConstants.consumerProfile,
            name: RouteConstants.consumerProfileName,
            pageBuilder: (context, state) {
              return const MaterialPage(child: MainHomeScreen());
            },
          ),
        ],
      ),
    ];
  }

  /// Détermine si le mode debug est activé
  /// 
  /// Retourne true en mode debug, false en production
  static bool _isDebugMode() {
    // Activer les logs de debug uniquement si autorisés et hors production
    return EnvConfig.enableDebugLogs && !EnvConfig.isProduction;
  }

  /// Clés de navigation pour l'accès externe
  /// 
  /// Permet l'accès aux clés de navigation depuis d'autres parties
  /// de l'application si nécessaire
  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;
}
