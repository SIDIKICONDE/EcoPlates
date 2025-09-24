import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/consumer_tabs.dart';
import '../providers/consumer_tab_provider.dart';

/// Shell pour l'interface consumer avec tab menu
class ConsumerShell extends ConsumerWidget {
  final Widget child;
  
  const ConsumerShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(consumerTabProvider);
    
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab.index,
        onDestinationSelected: (index) {
          final tab = ConsumerTab.values[index];
          ref.read(consumerTabProvider.notifier).state = tab;
          context.go(tab.route);
        },
        destinations: ConsumerTab.values.map((tab) {
          return NavigationDestination(
            icon: Icon(tab.icon),
            selectedIcon: Icon(tab.activeIcon),
            label: tab.shortLabel,
          );
        }).toList(),
      ),
    );
  }
}