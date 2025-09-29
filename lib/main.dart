//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//

import 'core/constants/env_config.dart';
import 'core/providers/cache_config_provider.dart';
import 'core/router/app_router.dart';
import 'core/widgets/adaptive_app.dart';

void main() async {
  // Assurer l'initialisation des widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive pour Flutter et enregistrer les adapters (une seule fois)

  // Charger la configuration de l'environnement
  await EnvConfig.load();

  // Initialiser le cache d'images
  await CacheConfig.initialize();
  CacheConfig.configurePerformance();

  // Afficher la config en mode debug
  EnvConfig.printConfig();

  // Permettre toutes les orientations pour le système responsive
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Lancer l'application avec Riverpod
  runApp(const ProviderScope(child: EcoPlatesApp()));
}

class EcoPlatesApp extends ConsumerWidget {
  const EcoPlatesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // L'init responsive/ScreenUtil est gérée par AdaptiveApp -> ResponsiveScreenUtilInit

    // Éviter la double initialisation: laisser AdaptiveApp + ResponsiveScreenUtilInit gérer
    // l'init ScreenUtil via ResponsiveScreenUtilInit/ResponsiveConfig.
    return AdaptiveApp(router: router);
  }
}
