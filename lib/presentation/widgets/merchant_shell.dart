import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/merchant_tabs.dart';
import '../providers/merchant_tab_provider.dart';

/// Shell pour l'interface merchant avec tab menu
class MerchantShell extends ConsumerWidget {
  const MerchantShell({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(merchantTabProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab.index,
        onDestinationSelected: (index) {
          final tab = MerchantTab.values[index];
          ref.read(merchantTabProvider.notifier).state = tab;
          context.go(tab.route);
        },
        destinations: MerchantTab.values.map((tab) {
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
