import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/merchant_tabs.dart';
import '../../core/widgets/adaptive_widgets.dart';
import '../providers/merchant_tab_provider.dart';
import 'merchant_tab_bar.dart';

/// Shell pour l'interface marchand avec navigation par onglets
class MerchantShell extends ConsumerStatefulWidget {
  final Widget child;
  
  const MerchantShell({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends ConsumerState<MerchantShell>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeController.forward();
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(merchantTabProvider);
    
    // Synchroniser la route avec l'état du provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = GoRouterState.of(context).uri.toString();
      final expectedRoute = currentTab.route;
      
      if (!currentRoute.startsWith(expectedRoute)) {
        // La route ne correspond pas à l'onglet sélectionné
        final tabFromRoute = MerchantTab.fromRoute(currentRoute);
        if (tabFromRoute != null && tabFromRoute != currentTab) {
          ref.read(merchantTabProvider.notifier).state = tabFromRoute;
        }
      }
    });

    if (PlatformUtils.shouldUseCupertino) {
      return _buildCupertinoShell();
    } else {
      return _buildMaterialShell();
    }
  }

  /// Construction de la shell iOS (Cupertino)
  Widget _buildCupertinoShell() {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          // Contenu principal
          Positioned.fill(
            bottom: 50, // Hauteur de la tab bar
            child: SafeArea(
              bottom: false,
              child: FadeTransition(
                opacity: _fadeController,
                child: widget.child,
              ),
            ),
          ),
          
          // Tab bar en bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: const MerchantTabBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construction de la shell Material
  Widget _buildMaterialShell() {
    return Scaffold(
      restorationId: 'merchant_shell',
      body: SafeArea(
        bottom: false,
        child: FadeTransition(
          opacity: _fadeController,
          child: widget.child,
        ),
      ),
      bottomNavigationBar: const MerchantTabBar(),
    );
  }
}

/// Variante avec IndexedStack pour conserver l'état des pages
class MerchantShellWithStack extends ConsumerStatefulWidget {
  final List<Widget> screens;
  
  const MerchantShellWithStack({
    super.key,
    required this.screens,
  });

  @override
  ConsumerState<MerchantShellWithStack> createState() => 
      _MerchantShellWithStackState();
}

class _MerchantShellWithStackState extends ConsumerState<MerchantShellWithStack>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final currentIndex = ref.watch(merchantTabIndexProvider);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapter le layout pour les tablettes
        final isTablet = constraints.maxWidth > 600;
        
        if (isTablet) {
          return _buildTabletLayout(currentIndex);
        }
        
        return _buildPhoneLayout(currentIndex);
      },
    );
  }

  /// Layout pour téléphone
  Widget _buildPhoneLayout(int currentIndex) {
    if (PlatformUtils.shouldUseCupertino) {
      return CupertinoPageScaffold(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: currentIndex,
                children: widget.screens,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: const MerchantTabBar(),
              ),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      restorationId: 'merchant_shell_stack',
      body: IndexedStack(
        index: currentIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: const MerchantTabBar(),
    );
  }

  /// Layout pour tablette avec navigation latérale
  Widget _buildTabletLayout(int currentIndex) {
    return Scaffold(
      restorationId: 'merchant_shell_stack_tablet',
      body: Row(
        children: [
          // Navigation latérale
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              final tab = MerchantTab.fromIndex(index);
              ref.read(merchantTabProvider.notifier).state = tab;
              context.go(tab.route);
            },
            labelType: NavigationRailLabelType.all,
            destinations: MerchantTab.values.map((tab) {
              return NavigationRailDestination(
                icon: Icon(tab.icon),
                selectedIcon: Icon(tab.activeIcon),
                label: Text(tab.shortLabel),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          
          // Contenu principal
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: widget.screens,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour préserver l'état d'une page
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  
  const KeepAlivePage({
    super.key,
    required this.child,
  });

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}