import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import '../constants/env_config.dart';
import '../themes/cupertino_theme.dart';
import '../themes/eco_theme.dart';

/// Widget adaptatif qui sélectionne automatiquement le bon thème selon la plateforme
class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({required this.router, super.key});

  final GoRouter router;

  /// Détermine si on doit utiliser Cupertino ou Material
  bool get _shouldUseCupertino {
    // Sur le web, toujours utiliser Material
    if (kIsWeb) return false;

    // Utiliser Cupertino sur iOS et macOS
    return Platform.isIOS || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldUseCupertino) {
      // Application iOS/macOS avec Cupertino
      return CupertinoApp.router(
        title: 'EcoPlates',
        debugShowCheckedModeBanner: !EnvConfig.isProduction,
        theme: CupertinoThemeConfig.lightTheme,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      );
    } else {
      // Application Android/Web/Windows/Linux avec Material
      return MaterialApp.router(
        title: 'EcoPlates',
        debugShowCheckedModeBanner: !EnvConfig.isProduction,
        theme: EcoTheme.lightTheme,
        darkTheme: EcoTheme.darkTheme,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
      );
    }
  }
}
