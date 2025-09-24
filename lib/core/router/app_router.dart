import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/main_home_screen.dart';
import '../../presentation/screens/merchant_detail_screen.dart';
import '../../presentation/screens/merchant_profile_screen.dart';
import '../../presentation/screens/merchant/merchant_home_screen.dart';
import '../../presentation/screens/scan_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/onboarding/user_type_selection_screen.dart';
import '../../presentation/screens/merchant/management/reservations_screen.dart';
import '../../presentation/screens/merchant/analytics/analytics_dashboard_screen.dart';
import '../../presentation/screens/merchant/offers/offers_list_screen.dart';
import '../../presentation/screens/merchant/offers/create_offer_screen.dart';
import '../../presentation/screens/merchant/offers/edit_offer_screen.dart';
import '../../presentation/screens/merchant/management/offer_detail_screen.dart';
import '../../presentation/widgets/offer_card_example.dart';
import '../../presentation/providers/app_mode_provider.dart';
import '../widgets/adaptive_navigation.dart';

/// Provider pour le router
final appRouterProvider = Provider<GoRouter>((ref) {
  final appMode = ref.watch(appModeProvider);
  return AppRouter.createRouter(appMode);
});

/// Configuration du router de l'application
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AppMode mode) {
    // Déterminer la route initiale selon le mode
    String initialLocation;
    switch (mode) {
      case AppMode.consumer:
        initialLocation = '/';
        break;
      case AppMode.merchant:
        initialLocation = '/merchant/dashboard';
        break;
      case AppMode.onboarding:
        initialLocation = '/onboarding';
        break;
    }

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      routes: [
        // Route d'onboarding (sans navigation)
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) {
            return const MaterialPage(child: UserTypeSelectionScreen());
          },
        ),

        // Page d'accueil principale 
        
        GoRoute(
          path: '/',
          name: 'main-home',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MainHomeScreen());
          },
        ),

        // Page de détail d'un merchant
        GoRoute(
          path: '/merchant/:id',
          name: 'merchant-detail',
          pageBuilder: (context, state) {
            final merchantId = state.pathParameters['id']!;
            return MaterialPage(
              child: MerchantDetailScreen(merchantId: merchantId),
            );
          },
        ),
        
        // Page de profil du merchant (vue acheteur)
        GoRoute(
          path: '/merchant-profile/:id',
          name: 'merchant-profile',
          pageBuilder: (context, state) {
            final merchantId = state.pathParameters['id']!;
            return MaterialPage(
              child: MerchantProfileScreen(merchantId: merchantId),
            );
          },
        ),
        
        // Page de détail d'une offre
        GoRoute(
          path: '/offer/:id',
          name: 'offer-detail',
          pageBuilder: (context, state) {
            final offerId = state.pathParameters['id']!;
            return MaterialPage(
              child: OfferDetailScreen(offerId: offerId),
            );
          },
        ),
        
        // Route de test pour l'OfferCard
        GoRoute(
          path: '/test-offer-card',
          name: 'test-offer-card',
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: OfferCardExample(),
            );
          },
        ),

        // Routes consommateur avec navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return AdaptiveNavigationScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) {
                return const MaterialPage(child: ProfileScreen());
              },
            ),
            GoRoute(
              path: '/reservations',
              name: 'reservations',
              pageBuilder: (context, state) {
                return const MaterialPage(child: ReservationsScreen());
              },
            ),
          ],
        ),
        // Routes commerçant (sans bottom navigation)
        GoRoute(
          path: '/merchant/dashboard',
          name: 'merchant-dashboard',
          pageBuilder: (context, state) {
            return const MaterialPage(child: MerchantHomeScreen());
          },
        ),

        // Scan réservé aux commerçants
        GoRoute(
          path: '/merchant/scan',
          name: 'merchant-scan',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ScanScreen());
          },
        ),
        GoRoute(
          path: '/merchant/scan-return',
          name: 'merchant-scan-return',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ScanScreen());
          },
        ),

        // Dashboard Analytics
        GoRoute(
          path: '/merchant/analytics',
          name: 'merchant-analytics',
          pageBuilder: (context, state) {
            return const MaterialPage(child: AnalyticsDashboardScreen());
          },
        ),

        // Gestion des offres
        GoRoute(
          path: '/merchant/offers',
          name: 'merchant-offers',
          pageBuilder: (context, state) {
            return const MaterialPage(child: OffersListScreen());
          },
        ),

        // Création d'offre
        GoRoute(
          path: '/merchant/offers/create',
          name: 'merchant-create-offer',
          pageBuilder: (context, state) {
            return const MaterialPage(child: CreateOfferScreen());
          },
        ),

        // Édition d'offre
        GoRoute(
          path: '/merchant/offers/:id/edit',
          name: 'merchant-edit-offer',
          pageBuilder: (context, state) {
            final offerId = state.pathParameters['id']!;
            return MaterialPage(child: EditOfferScreen(offerId: offerId));
          },
        ),
      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Page non trouvée',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.uri.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Retour à l\'accueil'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
