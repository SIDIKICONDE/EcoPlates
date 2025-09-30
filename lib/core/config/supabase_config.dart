import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration pour Supabase
/// 
/// Cette classe centralise toute la configuration Supabase
/// Les clés sont stockées dans les fichiers .env pour la sécurité
class SupabaseConfig {
  SupabaseConfig._();

  /// URL du projet Supabase
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  /// Clé publique anonyme Supabase
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Vérifier si la configuration est valide
  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  /// Options de configuration pour l'authentification
  static const authCallbackUrlHostname = 'login-callback';
  
  /// Configuration des tables
  static const String usersTable = 'users';
  static const String merchantsTable = 'merchants';
  static const String merchantProfilesTable = 'merchant_profiles';
  static const String foodOffersTable = 'food_offers';
  static const String ordersTable = 'orders';
  static const String reservationsTable = 'reservations';
  static const String stockItemsTable = 'stock_items';
  static const String salesTable = 'sales';
  static const String saleItemsTable = 'sale_items';
  static const String categoriesTable = 'categories';
  static const String brandsTable = 'brands';
  static const String qrCodesTable = 'qr_codes';
  static const String qrScansTable = 'qr_scans';
  
  /// Configuration des buckets de stockage
  static const String offerImagesBucket = 'offer-images';
  static const String merchantLogosBucket = 'merchant-logos';
  static const String profilePicturesBucket = 'profile-pictures';
  static const String stockImagesBucket = 'stock-images';
  
  /// Configuration des politiques RLS
  static const bool enableRLS = true;
  
  /// Configuration des temps d'expiration
  static const Duration sessionRefreshInterval = Duration(minutes: 5);
  static const Duration cacheExpiration = Duration(hours: 1);
}