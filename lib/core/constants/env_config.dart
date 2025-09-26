import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration de l'environnement
class EnvConfig {
  static const String apiUrl =
      'https://api.ecoplates.com'; // À remplacer par votre URL
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';
  static bool get useMockData => isDevelopment && !isBackendAvailable();

  static bool isBackendAvailable() {
    // Determine backend availability from environment variables or environment
    final envValue = dotenv.env['BACKEND_AVAILABLE'];
    if (envValue != null) {
      final normalized = envValue.toLowerCase().trim();
      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }
    // Default: backend available in staging/production, disabled in dev unless explicitly enabled
    if (isStaging || isProduction) {
      return true;
    }
    return false;
  }

  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Feature flags
  static bool get enableDebugLogs => dotenv.env['ENABLE_DEBUG_LOGS'] == 'true';

  // Version
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get buildNumber => dotenv.env['BUILD_NUMBER'] ?? '1';

  // APIs externes
  static String get googleMapsApiKey {
    final key = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'GOOGLE_MAPS_API_KEY not found in environment configuration. '
        'Please ensure your .env file is properly configured. '
        'See .env.example for reference.'
      );
    }
    return key;
  }

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  /// Charger l'environnement approprié
  static Future<void> load({String? env}) async {
    final envFile =
        env ?? const String.fromEnvironment('ENV', defaultValue: 'dev');
    await dotenv.load(fileName: 'environments/.env.$envFile');
  }

  /// Afficher la configuration actuelle (pour debug)
  static void printConfig() {
    if (enableDebugLogs) {
      final config =
          '''
====== ENV CONFIG ======
Environment: $environment
API Base URL: $apiBaseUrl
API Timeout: $apiTimeout ms
Debug Logs: $enableDebugLogs
Version: $appVersion (Build: $buildNumber)
========================
''';
      dev.log(config, name: 'EnvConfig');
    }
  }
}
