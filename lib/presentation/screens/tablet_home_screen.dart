import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../widgets/navigation/tablet_tab_menu.dart';
import 'main_home_screen.dart';

/// Écran principal adaptatif qui utilise le menu tablette ou l'interface normale
class TabletHomeScreen extends ConsumerWidget {
  const TabletHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ResponsiveUtils.isTablet(context);
    
    // Si c'est une tablette, utiliser le menu tablette
    if (isTablet) {
      return const Scaffold(
        body: TabletTabMenu(),
      );
    }
    
    // Sinon, utiliser l'interface normale
    return const MainHomeScreen();
  }
}