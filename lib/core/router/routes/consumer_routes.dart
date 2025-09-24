import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/screens/profile_screen.dart';
import '../../../presentation/screens/merchant/management/reservations_screen.dart';
import '../../../presentation/screens/merchant_detail_screen.dart';
import '../../../presentation/screens/merchant_profile_screen.dart';
import '../../../presentation/screens/merchant/management/offer_detail_screen.dart';
import '../../../presentation/screens/recommended_offers_screen.dart';
import '../../../core/widgets/adaptive_navigation.dart';
import 'route_constants.dart';

/// Configuration des routes spécifiques aux consommateurs
/// 
/// Centralise toute la logique de navigation pour l'interface consommateur
/// selon les directives EcoPlates
class ConsumerRoutes {
  /// Routes avec navigation adaptative (ShellRoute)
  static List<RouteBase> get shellRoutes => [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        return AdaptiveNavigationScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: RouteConstants.profile,
          name: RouteConstants.profileName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: ProfileScreen());
          },
        ),
        GoRoute(
          path: RouteConstants.reservations,
          name: RouteConstants.reservationsName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: ReservationsScreen());
          },
        ),
      ],
    ),
  ];

  /// Routes consommateur sans navigation par onglets
  static List<RouteBase> get standaloneRoutes => [
    // Page "Recommandé pour vous"
    GoRoute(
      path: RouteConstants.recommended,
      name: RouteConstants.recommendedName,
      pageBuilder: (context, state) => const MaterialPage(
        child: RecommendedOffersScreen(),
      ),
    ),

    // Page de détail d'un marchand
    GoRoute(
      path: RouteConstants.merchantDetail,
      name: RouteConstants.merchantDetailName,
      pageBuilder: (context, state) {
        final merchantId = state.pathParameters['id']!;
        return MaterialPage(
          child: MerchantDetailScreen(merchantId: merchantId),
        );
      },
    ),
    
    // Page de profil du marchand (vue acheteur)
    GoRoute(
      path: RouteConstants.merchantProfileView,
      name: RouteConstants.merchantProfileViewName,
      pageBuilder: (context, state) {
        final merchantId = state.pathParameters['id']!;
        return MaterialPage(
          child: MerchantProfileScreen(merchantId: merchantId),
        );
      },
    ),
    
    // Page de détail d'une offre
    GoRoute(
      path: RouteConstants.offerDetail,
      name: RouteConstants.offerDetailName,
      pageBuilder: (context, state) {
        final offerId = state.pathParameters['id']!;
        return MaterialPage(
          child: OfferDetailScreen(offerId: offerId),
        );
      },
    ),
  ];

  /// Toutes les routes consommateur
  static List<RouteBase> get allRoutes => [
    ...shellRoutes,
    ...standaloneRoutes,
  ];
}
