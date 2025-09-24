import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enum pour les modes d'affichage
enum BrowseViewMode {
  list('Liste'),
  map('Carte');

  final String label;
  const BrowseViewMode(this.label);
}

/// Provider pour gérer le mode d'affichage actuel (Liste ou Carte)
final browseViewModeProvider = StateProvider<BrowseViewMode>((ref) {
  return BrowseViewMode.list; // Mode par défaut : Liste
});