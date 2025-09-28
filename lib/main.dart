import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

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

    // Déterminer la taille de design responsive selon le type d'appareil
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Utiliser une taille de design adaptative
    late ui.Size designSize;
    if (screenWidth >= 1440) {
      // Grand écran desktop
      designSize = ui.Size(1440, 900);
    } else if (screenWidth >= 768) {
      // Tablette
      designSize = ui.Size(768, 1024);
    } else if (screenWidth >= 900) {
      // Écran moyen
      designSize = ui.Size(900, 1200);
    } else {
      // Mobile (par défaut)
      designSize = ui.Size(375, 812); // iPhone X comme référence
    }

    // Note: ScreenUtilInit est maintenu pour la compatibilité avec les widgets existants
    // mais le nouveau système responsive (context.responsiveValue) est prioritaire
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Utilise AdaptiveApp qui détecte automatiquement la plateforme
        // AdaptiveApp utilise maintenant EcoTheme avec le système responsive intégré
        return AdaptiveApp(router: router);
      },
    );
  }
}
