/// Constantes des routes de l'application EcoPlates
/// 
/// Centralise toutes les définitions de routes pour maintenir
/// la cohérence et faciliter la maintenance
class RouteConstants {
  // Routes publiques
  static const String onboarding = '/onboarding';
  static const String mainHome = '/';
  
  // Routes consommateur
  static const String profile = '/profile';
  static const String reservations = '/reservations';
  static const String brands = '/brands';
  static const String recommended = '/recommended';
  
  // Routes marchand - Navigation principale
  static const String merchantDashboard = '/merchant/dashboard';
  static const String merchantOffers = '/merchant/offers';
  static const String merchantSales = '/merchant/sales';
  static const String merchantStore = '/merchant/store';
  static const String merchantAnalytics = '/merchant/analytics';
  static const String merchantProfile = '/merchant/profile';
  
  // Routes marchand - Fonctionnalités
  static const String merchantScan = '/merchant/scan';
  static const String merchantScanReturn = '/merchant/scan-return';
  static const String merchantOffersManagement = '/merchant/offers-management';
  static const String merchantCreateOffer = '/merchant/offers/create';
  static const String merchantEditOffer = '/merchant/offers/:id/edit';
  static const String merchantReservations = '/merchant/reservations';
  
  // Routes dynamiques
  static const String merchantDetail = '/merchant/:id';
  static const String merchantProfileView = '/merchant-profile/:id';
  static const String offerDetail = '/offer/:id';
  
  // Routes de test/développement
  static const String testOfferCard = '/test-offer-card';
  
  // Noms des routes (pour la navigation programmatique)
  static const String onboardingName = 'onboarding';
  static const String mainHomeName = 'main-home';
  static const String profileName = 'profile';
  static const String reservationsName = 'reservations';
  static const String brandsName = 'brands';
  static const String recommendedName = 'recommended';
  static const String merchantDashboardName = 'merchant-dashboard';
  static const String merchantOffersName = 'merchant-offers';
  static const String merchantSalesName = 'merchant-sales';
  static const String merchantStoreName = 'merchant-store';
  static const String merchantAnalyticsName = 'merchant-analytics';
  static const String merchantProfileName = 'merchant-profile-settings';
  static const String merchantScanName = 'merchant-scan';
  static const String merchantScanReturnName = 'merchant-scan-return';
  static const String merchantOffersManagementName = 'merchant-offers-management';
  static const String merchantCreateOfferName = 'merchant-create-offer';
  static const String merchantEditOfferName = 'merchant-edit-offer';
  static const String merchantReservationsName = 'merchant-reservations';
  static const String merchantDetailName = 'merchant-detail';
  static const String merchantProfileViewName = 'merchant-profile';
  static const String offerDetailName = 'offer-detail';
  static const String testOfferCardName = 'test-offer-card';
}
