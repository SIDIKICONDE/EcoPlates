import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/consumer_tabs.dart';

/// Provider pour l'onglet actuel des consommateurs
final consumerTabProvider = StateProvider<ConsumerTab>((ref) {
  return ConsumerTab.discover; // Par défaut sur Découvrir
});

/// Provider pour l'index de l'onglet actuel
final consumerTabIndexProvider = Provider<int>((ref) {
  final tab = ref.watch(consumerTabProvider);
  return tab.index;
});
