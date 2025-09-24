import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/merchant_tabs.dart';

/// Provider pour l'onglet actuellement sélectionné dans la navigation marchand
final merchantTabProvider = StateProvider<MerchantTab>((ref) {
  return MerchantTab.stock;
});

/// Provider pour l'index de l'onglet actuellement sélectionné
final merchantTabIndexProvider = Provider<int>((ref) {
  final currentTab = ref.watch(merchantTabProvider);
  return currentTab.index;
});

/// Notifier pour gérer les changements d'onglets avec logique métier
class MerchantTabNotifier extends StateNotifier<MerchantTab> {
  MerchantTabNotifier() : super(MerchantTab.stock);

  /// Change l'onglet actuel
  void selectTab(MerchantTab tab) {
    state = tab;
  }

  /// Change l'onglet actuel via son index
  void selectTabByIndex(int index) {
    state = MerchantTab.fromIndex(index);
  }

  /// Navigue vers l'onglet suivant
  void nextTab() {
    final currentIndex = state.index;
    final nextIndex = (currentIndex + 1) % MerchantTab.values.length;
    selectTabByIndex(nextIndex);
  }

  /// Navigue vers l'onglet précédent
  void previousTab() {
    final currentIndex = state.index;
    final previousIndex = currentIndex == 0 
        ? MerchantTab.values.length - 1 
        : currentIndex - 1;
    selectTabByIndex(previousIndex);
  }
}

/// Provider pour le notifier de navigation
final merchantTabNotifierProvider = 
    StateNotifierProvider<MerchantTabNotifier, MerchantTab>((ref) {
  return MerchantTabNotifier();
});

/// Helper pour vérifier si un onglet est actuellement sélectionné
final isMerchantTabSelectedProvider = Provider.family<bool, MerchantTab>((ref, tab) {
  final currentTab = ref.watch(merchantTabProvider);
  return currentTab == tab;
});

/// Provider pour obtenir la route actuelle selon l'onglet sélectionné
final currentMerchantRouteProvider = Provider<String>((ref) {
  final currentTab = ref.watch(merchantTabProvider);
  return currentTab.route;
});