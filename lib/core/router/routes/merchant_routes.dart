import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/screens/merchant/dashboard_screen.dart';
import '../../../presentation/screens/merchant/offers/offers_list_screen.dart';
import '../../../presentation/screens/merchant/sales_screen.dart';
import '../../../presentation/screens/merchant/profile_screen.dart' as merchant_profile;
import '../../../presentation/screens/merchant/analytics/analytics_dashboard_screen.dart';
import '../../../presentation/screens/merchant/management/reservations_screen.dart';
import '../../../presentation/screens/merchant/offers/create_offer_screen.dart';
import '../../../presentation/screens/merchant/offers/edit_offer_screen.dart';
import '../../../presentation/screens/scan_screen.dart';
import '../../../presentation/screens/main_home_screen.dart';
import '../../../presentation/widgets/merchant_shell.dart';
import '../../../presentation/widgets/offer_card_example.dart';
import 'route_constants.dart';

/// Configuration des routes spécifiques aux marchands
/// 
/// Centralise toute la logique de navigation pour l'interface marchande
/// selon les directives EcoPlates
class MerchantRoutes {
  /// Routes avec navigation par onglets (ShellRoute)
  static List<RouteBase> get shellRoutes => [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        return MerchantShell(child: child);
      },
      routes: [
        GoRoute(
          path: RouteConstants.merchantDashboard,
          name: RouteConstants.merchantDashboardName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: MerchantDashboardScreen());
          },
        ),
        GoRoute(
          path: RouteConstants.merchantOffers,
          name: RouteConstants.merchantOffersName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: OffersListScreen());
          },
        ),
        GoRoute(
          path: RouteConstants.merchantSales,
          name: RouteConstants.merchantSalesName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: MerchantSalesScreen());
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
          path: RouteConstants.merchantAnalytics,
          name: RouteConstants.merchantAnalyticsName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: AnalyticsDashboardScreen());
          },
        ),
        GoRoute(
          path: RouteConstants.merchantProfile,
          name: RouteConstants.merchantProfileName,
          pageBuilder: (context, state) {
            return const MaterialPage(child: merchant_profile.MerchantProfileScreen());
          },
        ),
      ],
    ),
  ];

  /// Routes marchandes sans navigation par onglets
  static List<RouteBase> get standaloneRoutes => [
    // Fonctionnalités de scan
    GoRoute(
      path: RouteConstants.merchantScan,
      name: RouteConstants.merchantScanName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ScanScreen());
      },
    ),
    GoRoute(
      path: RouteConstants.merchantScanReturn,
      name: RouteConstants.merchantScanReturnName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ScanScreen());
      },
    ),
    
    // Gestion des offres
    GoRoute(
      path: RouteConstants.merchantOffersManagement,
      name: RouteConstants.merchantOffersManagementName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OffersListScreen());
      },
    ),
    GoRoute(
      path: RouteConstants.merchantCreateOffer,
      name: RouteConstants.merchantCreateOfferName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: CreateOfferScreen());
      },
    ),
    GoRoute(
      path: RouteConstants.merchantEditOffer,
      name: RouteConstants.merchantEditOfferName,
      pageBuilder: (context, state) {
        final offerId = state.pathParameters['id']!;
        return MaterialPage(child: EditOfferScreen(offerId: offerId));
      },
    ),
    
    // Gestion des réservations
    GoRoute(
      path: RouteConstants.merchantReservations,
      name: RouteConstants.merchantReservationsName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: ReservationsScreen());
      },
    ),
    
    // Route de test (développement uniquement)
    GoRoute(
      path: RouteConstants.testOfferCard,
      name: RouteConstants.testOfferCardName,
      pageBuilder: (context, state) {
        return const MaterialPage(child: OfferCardExample());
      },
    ),
  ];

  /// Toutes les routes marchandes
  static List<RouteBase> get allRoutes => [
    ...shellRoutes,
    ...standaloneRoutes,
  ];
}
