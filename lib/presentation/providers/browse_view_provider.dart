import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum pour les modes d'affichage
enum BrowseViewMode {
  list('Liste'),
  map('Carte');

  const BrowseViewMode(this.label);
  final String label;
}

/// Notifier pour gérer le mode d'affichage
class BrowseViewModeNotifier extends Notifier<BrowseViewMode> {
  @override
  BrowseViewMode build() {
    return BrowseViewMode.list; // Mode par défaut : Liste
  }

  void setMode(BrowseViewMode mode) {
    state = mode;
  }

  void toggleMode() {
    state = state == BrowseViewMode.list
        ? BrowseViewMode.map
        : BrowseViewMode.list;
  }
}

/// Provider pour gérer le mode d'affichage actuel (Liste ou Carte)
final browseViewModeProvider =
    NotifierProvider<BrowseViewModeNotifier, BrowseViewMode>(
      BrowseViewModeNotifier.new,
    );
