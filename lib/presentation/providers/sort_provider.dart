import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/sort_options.dart';

/// Notifier pour l'option de tri
class SortOptionNotifier extends Notifier<SortOption> {
  @override
  SortOption build() {
    return SortOption.relevance;
  }

  void setSortOption(SortOption option) {
    state = option;
  }
}

/// Notifier pour l'état du modal de tri
class SortModalNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void open() {
    state = true;
  }

  void close() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider pour l'option de tri sélectionnée
final sortOptionProvider = NotifierProvider<SortOptionNotifier, SortOption>(
  SortOptionNotifier.new,
);

/// Provider pour savoir si le modal de tri est ouvert
final sortModalOpenProvider = NotifierProvider<SortModalNotifier, bool>(
  SortModalNotifier.new,
);
