import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/themes/deep_theme.dart';
import 'presentation/pages/theme_demo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Permettre toutes les orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const ThemeDemoApp());
}

class ThemeDemoApp extends StatelessWidget {
  const ThemeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyth - Démonstration du Thème Profond',
      debugShowCheckedModeBanner: false,
      // Utiliser le nouveau thème profond
      theme: DeepTheme.lightTheme,
      darkTheme: DeepTheme.darkTheme,
      home: const ThemeDemoPage(),
    );
  }
}