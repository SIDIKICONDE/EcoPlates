import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/models/product_model.dart';
import 'data/models/stock_movement_model.dart';
import 'core/constants/env_config.dart';
import 'core/widgets/adaptive_app.dart';
import 'core/router/app_router.dart';

void main() async {
  // Assurer l'initialisation des widgets
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Hive pour Flutter et enregistrer les adapters (une seule fois)
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(10)) Hive.registerAdapter(ProductModelAdapter());
  if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter(StockModelAdapter());
  if (!Hive.isAdapterRegistered(12)) Hive.registerAdapter(NutritionalInfoModelAdapter());
  if (!Hive.isAdapterRegistered(13)) Hive.registerAdapter(StockMovementModelAdapter());

  // Charger la configuration de l'environnement
  await EnvConfig.load();

  // Afficher la config en mode debug
  EnvConfig.printConfig();

  // Configurer l'orientation préférée
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Lancer l'application avec Riverpod
  runApp(const ProviderScope(child: EcoPlatesApp()));
}

class EcoPlatesApp extends ConsumerWidget {
  const EcoPlatesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X dimensions comme référence
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Utilise AdaptiveApp qui détecte automatiquement la plateforme
        return AdaptiveApp(router: router);
      },
    );
  }
}
