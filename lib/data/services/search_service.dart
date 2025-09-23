import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/food_offer.dart';

/// Service de recherche intelligente
class SearchService {
  static const String _boxName = 'search_history';
  static const String _historyKey = 'recent_searches';
  static const int _maxHistoryItems = 20;

  late Box _box;

  /// Initialise le service de recherche
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// Récupère l'historique de recherche
  List<String> getSearchHistory() {
    final dynamic stored = _box.get(_historyKey);
    if (stored is List) {
      return stored.cast<String>().take(_maxHistoryItems).toList();
    }
    return [];
  }

  /// Ajoute un terme à l'historique
  Future<void> addToHistory(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;

    final history = getSearchHistory();

    // Retirer le terme s'il existe déjà pour le remettre au début
    history.remove(searchTerm);

    // Ajouter au début
    history.insert(0, searchTerm);

    // Limiter la taille
    if (history.length > _maxHistoryItems) {
      history.removeLast();
    }

    await _box.put(_historyKey, history);
  }

  /// Supprime un terme de l'historique
  Future<void> removeFromHistory(String searchTerm) async {
    final history = getSearchHistory();
    history.remove(searchTerm);
    await _box.put(_historyKey, history);
  }

  /// Efface tout l'historique
  Future<void> clearHistory() async {
    await _box.delete(_historyKey);
  }

  /// Recherche dans les offres
  List<FoodOffer> searchOffers(List<FoodOffer> offers, String query) {
    if (query.trim().isEmpty) return offers;

    final lowerQuery = query.toLowerCase();
    final words = lowerQuery.split(' ').where((w) => w.isNotEmpty).toList();

    return offers.where((offer) {
      // Score de pertinence
      int score = 0;

      // Recherche dans le titre (priorité haute)
      if (offer.title.toLowerCase().contains(lowerQuery)) {
        score += 100;
      } else {
        for (final word in words) {
          if (offer.title.toLowerCase().contains(word)) {
            score += 50;
          }
        }
      }

      // Recherche dans le nom du commerçant (priorité moyenne)
      if (offer.merchantName.toLowerCase().contains(lowerQuery)) {
        score += 80;
      } else {
        for (final word in words) {
          if (offer.merchantName.toLowerCase().contains(word)) {
            score += 40;
          }
        }
      }

      // Recherche dans la description (priorité basse)
      if (offer.description.toLowerCase().contains(lowerQuery)) {
        score += 60;
      } else {
        for (final word in words) {
          if (offer.description.toLowerCase().contains(word)) {
            score += 30;
          }
        }
      }

      // Recherche dans la catégorie
      if (_getCategoryName(offer.category).toLowerCase().contains(lowerQuery)) {
        score += 40;
      }

      // Recherche dans les tags spéciaux
      if (lowerQuery.contains('gratuit') && offer.isFree) score += 70;
      if (lowerQuery.contains('végé') && offer.isVegetarian) score += 60;
      if (lowerQuery.contains('vegan') && offer.isVegan) score += 60;
      if (lowerQuery.contains('halal') && offer.isHalal) score += 60;

      // Prix
      if (lowerQuery.contains('pas cher') && offer.discountedPrice < 5)
        score += 50;
      if (lowerQuery.contains('économie') && offer.discountPercentage > 50)
        score += 50;

      return score > 0;
    }).toList()..sort((a, b) {
      // Trier par score de pertinence
      int scoreA = _calculateScore(a, lowerQuery, words);
      int scoreB = _calculateScore(b, lowerQuery, words);
      return scoreB.compareTo(scoreA);
    });
  }

  /// Calcule le score de pertinence pour le tri
  int _calculateScore(FoodOffer offer, String query, List<String> words) {
    int score = 0;

    if (offer.title.toLowerCase().contains(query)) score += 100;
    if (offer.merchantName.toLowerCase().contains(query)) score += 80;
    if (offer.description.toLowerCase().contains(query)) score += 60;

    for (final word in words) {
      if (offer.title.toLowerCase().contains(word)) score += 50;
      if (offer.merchantName.toLowerCase().contains(word)) score += 40;
      if (offer.description.toLowerCase().contains(word)) score += 30;
    }

    return score;
  }

  /// Génère des suggestions basées sur l'historique et les termes populaires
  List<SearchSuggestion> getSuggestions(String query, List<FoodOffer> offers) {
    final suggestions = <SearchSuggestion>[];
    final lowerQuery = query.toLowerCase();

    if (query.isEmpty) {
      // Retourner l'historique récent
      final history = getSearchHistory().take(5);
      for (final term in history) {
        suggestions.add(
          SearchSuggestion(
            text: term,
            type: SuggestionType.history,
            icon: SearchSuggestionIcon.history,
          ),
        );
      }

      // Ajouter des suggestions populaires
      suggestions.addAll(_getPopularSuggestions());
    } else {
      // Suggestions basées sur la requête

      // Historique correspondant
      final matchingHistory = getSearchHistory()
          .where((term) => term.toLowerCase().contains(lowerQuery))
          .take(3);
      for (final term in matchingHistory) {
        suggestions.add(
          SearchSuggestion(
            text: term,
            type: SuggestionType.history,
            icon: SearchSuggestionIcon.history,
          ),
        );
      }

      // Catégories correspondantes
      for (final category in FoodCategory.values) {
        final categoryName = _getCategoryName(category);
        if (categoryName.toLowerCase().contains(lowerQuery)) {
          suggestions.add(
            SearchSuggestion(
              text: categoryName,
              type: SuggestionType.category,
              icon: SearchSuggestionIcon.category,
            ),
          );
        }
      }

      // Commerçants uniques correspondants
      final merchants = offers
          .map((o) => o.merchantName)
          .toSet()
          .where((name) => name.toLowerCase().contains(lowerQuery))
          .take(3);
      for (final merchant in merchants) {
        suggestions.add(
          SearchSuggestion(
            text: merchant,
            type: SuggestionType.merchant,
            icon: SearchSuggestionIcon.store,
          ),
        );
      }

      // Suggestions de filtres
      if ('gratuit'.contains(lowerQuery)) {
        suggestions.add(
          SearchSuggestion(
            text: 'Offres gratuites',
            type: SuggestionType.filter,
            icon: SearchSuggestionIcon.filter,
          ),
        );
      }
      if ('végétarien'.contains(lowerQuery) ||
          'vegetarien'.contains(lowerQuery)) {
        suggestions.add(
          SearchSuggestion(
            text: 'Végétarien',
            type: SuggestionType.filter,
            icon: SearchSuggestionIcon.filter,
          ),
        );
      }
    }

    return suggestions.take(10).toList();
  }

  /// Suggestions populaires par défaut
  List<SearchSuggestion> _getPopularSuggestions() {
    return [
      SearchSuggestion(
        text: 'Pizza',
        type: SuggestionType.popular,
        icon: SearchSuggestionIcon.trending,
      ),
      SearchSuggestion(
        text: 'Sandwich',
        type: SuggestionType.popular,
        icon: SearchSuggestionIcon.trending,
      ),
      SearchSuggestion(
        text: 'Salade',
        type: SuggestionType.popular,
        icon: SearchSuggestionIcon.trending,
      ),
      SearchSuggestion(
        text: 'Gratuit',
        type: SuggestionType.filter,
        icon: SearchSuggestionIcon.filter,
      ),
      SearchSuggestion(
        text: 'Boulangerie',
        type: SuggestionType.category,
        icon: SearchSuggestionIcon.category,
      ),
    ];
  }

  String _getCategoryName(FoodCategory category) {
    switch (category) {
      case FoodCategory.petitDejeuner:
        return 'Petit-déjeuner';
      case FoodCategory.dejeuner:
        return 'Déjeuner';
      case FoodCategory.diner:
        return 'Dîner';
      case FoodCategory.snack:
        return 'Snack';
      case FoodCategory.dessert:
        return 'Dessert';
      case FoodCategory.boisson:
        return 'Boisson';
      case FoodCategory.boulangerie:
        return 'Boulangerie';
      case FoodCategory.fruitLegume:
        return 'Fruits & Légumes';
      case FoodCategory.epicerie:
        return 'Épicerie';
      case FoodCategory.autre:
        return 'Autre';
    }
  }
}

/// Suggestion de recherche
class SearchSuggestion {
  final String text;
  final SuggestionType type;
  final SearchSuggestionIcon icon;

  SearchSuggestion({
    required this.text,
    required this.type,
    required this.icon,
  });
}

/// Type de suggestion
enum SuggestionType { history, popular, category, merchant, filter }

/// Icône de suggestion
enum SearchSuggestionIcon { history, trending, category, store, filter }

/// Provider pour le service de recherche
final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

/// Provider pour initialiser le service
final searchInitProvider = FutureProvider<void>((ref) async {
  final service = ref.read(searchServiceProvider);
  await service.init();
});
