import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/search_service.dart';
import '../../../domain/entities/food_offer.dart';
import '../merchant/offers_provider.dart';

/// État de la recherche
@immutable
class SearchState {
  final String query;
  final List<String> searchHistory;
  final List<SearchSuggestion> suggestions;
  final bool isSearching;
  final bool showSuggestions;

  const SearchState({
    this.query = '',
    this.searchHistory = const [],
    this.suggestions = const [],
    this.isSearching = false,
    this.showSuggestions = false,
  });

  SearchState copyWith({
    String? query,
    List<String>? searchHistory,
    List<SearchSuggestion>? suggestions,
    bool? isSearching,
    bool? showSuggestions,
  }) {
    return SearchState(
      query: query ?? this.query,
      searchHistory: searchHistory ?? this.searchHistory,
      suggestions: suggestions ?? this.suggestions,
      isSearching: isSearching ?? this.isSearching,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

/// Notifier pour gérer l'état de la recherche
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchService _searchService;
  final Ref _ref;

  SearchNotifier(this._searchService, this._ref) : super(const SearchState()) {
    _initialize();
  }

  /// Initialise le service de recherche
  Future<void> _initialize() async {
    await _searchService.init();
    _loadSearchHistory();
  }

  /// Charge l'historique de recherche
  void _loadSearchHistory() {
    final history = _searchService.getSearchHistory();
    state = state.copyWith(searchHistory: history);
  }

  /// Met à jour la requête de recherche
  void updateQuery(String query) {
    state = state.copyWith(
      query: query,
      isSearching: query.isNotEmpty,
      showSuggestions: true,
    );

    // Générer les suggestions
    _generateSuggestions(query);
  }

  /// Génère les suggestions basées sur la requête
  void _generateSuggestions(String query) async {
    final offers = await _ref.read(nearbyOffersProvider.future);
    final suggestions = _searchService.getSuggestions(query, offers);

    state = state.copyWith(suggestions: suggestions);
  }

  /// Exécute une recherche avec un terme
  Future<void> search(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;

    // Ajouter à l'historique
    await _searchService.addToHistory(searchTerm);

    // Mettre à jour l'état
    state = state.copyWith(
      query: searchTerm,
      isSearching: true,
      showSuggestions: false,
    );

    // Recharger l'historique
    _loadSearchHistory();
  }

  /// Sélectionne une suggestion
  void selectSuggestion(SearchSuggestion suggestion) {
    // Mettre à jour la requête avec la suggestion
    updateQuery(suggestion.text);

    // Si c'est un filtre, appliquer le filtre correspondant
    if (suggestion.type == SuggestionType.filter) {
      // TODO: Appliquer le filtre approprié
    }

    // Exécuter la recherche
    search(suggestion.text);
  }

  /// Efface la recherche
  void clearSearch() {
    state = state.copyWith(
      query: '',
      isSearching: false,
      showSuggestions: false,
      suggestions: [],
    );
  }

  /// Supprime un élément de l'historique
  Future<void> removeFromHistory(String searchTerm) async {
    await _searchService.removeFromHistory(searchTerm);
    _loadSearchHistory();
  }

  /// Efface tout l'historique
  Future<void> clearHistory() async {
    await _searchService.clearHistory();
    state = state.copyWith(searchHistory: []);
  }

  /// Active/désactive l'affichage des suggestions
  void toggleSuggestions(bool show) {
    state = state.copyWith(showSuggestions: show);

    if (show) {
      _generateSuggestions(state.query);
    }
  }
}

/// Provider principal pour la recherche
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final searchService = ref.watch(searchServiceProvider);
  return SearchNotifier(searchService, ref);
});

/// Provider pour les résultats de recherche
final searchResultsProvider = Provider<List<FoodOffer>>((ref) {
  final searchState = ref.watch(searchProvider);
  final offersAsync = ref.watch(nearbyOffersProvider);

  return offersAsync.when(
    data: (offers) {
      if (!searchState.isSearching || searchState.query.isEmpty) {
        return offers;
      }

      final searchService = ref.read(searchServiceProvider);
      return searchService.searchOffers(offers, searchState.query);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider simple pour la requête de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');
