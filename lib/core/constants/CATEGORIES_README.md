# 📂 Système Centralisé de Catégories - EcoPlates

## 🎯 Vue d'ensemble

Le système de catégories d'EcoPlates est maintenant entièrement centralisé pour assurer cohérence, maintenabilité et expérience utilisateur optimale.

## 📁 Structure

```
lib/core/constants/
├── categories.dart           # Registre central des catégories
└── CATEGORIES_README.md     # Cette documentation
```

## 🔧 Utilisation

### 1. Accès aux informations de catégories

```dart
import '../../core/constants/categories.dart';

// Obtenir le label d'une catégorie
String label = Categories.labelOf(FoodCategory.dejeuner); // "Déjeuner"

// Obtenir l'icône d'une catégorie
IconData icon = Categories.iconOf(FoodCategory.dejeuner); // Icons.lunch_dining

// Obtenir la couleur d'une catégorie
Color color = Categories.colorOf(FoodCategory.dejeuner); // Colors.blue

// Liste ordonnée de toutes les catégories
List<FoodCategory> ordered = Categories.ordered;

// Conversion depuis une chaîne
FoodCategory? category = Categories.fromString("déjeuner");
```

### 2. Utilisation dans les widgets

#### Affichage d'une catégorie avec icône et couleur
```dart
Widget buildCategoryChip(FoodCategory category) {
  return Chip(
    avatar: Icon(
      Categories.iconOf(category),
      color: Categories.colorOf(category),
      size: 16,
    ),
    label: Text(Categories.labelOf(category)),
  );
}
```

#### Filtrage d'offres par catégorie
```dart
// Dans store_offers_provider.dart
List<FoodOffer> filteredOffers = allOffers
    .where((offer) => selectedCategories.contains(offer.category))
    .toList();
```

### 3. Système de filtrage de la page d'accueil

#### Provider de catégorie sélectionnée
```dart
// Import dans sections/categories_section.dart
final selectedCategoryProvider = StateProvider<FoodCategory?>((ref) => null);

// Provider de filtrage automatique
final filterOffersByCategoryProvider = Provider.family<List<FoodOffer>, List<FoodOffer>>(
  (ref, offers) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    if (selectedCategory == null) return offers; // "Tous"
    return offers.where((offer) => offer.category == selectedCategory).toList();
  }
);
```

#### Utilisation dans une section
```dart
// Dans recommended_section.dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final recommendedOffersAsync = ref.watch(recommendedOffersProvider);
  
  return recommendedOffersAsync.when(
    data: (allOffers) {
      // Filtrage automatique selon la catégorie sélectionnée
      final offers = ref.watch(filterOffersByCategoryProvider(allOffers));
      
      return ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) => OfferCard(offer: offers[index]),
      );
    },
    loading: () => CircularProgressIndicator(),
    error: (error, stack) => ErrorWidget(error),
  );
}
```

## 🎨 Personnalisation

### Modifier une catégorie existante

Dans `categories.dart`, modifiez les informations :

```dart
static const Map<FoodCategory, CategoryInfo> _info = {
  FoodCategory.dejeuner: CategoryInfo(
    id: FoodCategory.dejeuner,
    slug: 'dejeuner',
    label: 'Déjeuner', // ← Modifier ici
    synonyms: ['lunch', 'midi', 'repas'], // ← Ou ici
  ),
  // ...
};

// Et dans les méthodes iconOf/colorOf :
static IconData iconOf(FoodCategory category) {
  switch (category) {
    case FoodCategory.dejeuner:
      return Icons.lunch_dining; // ← Modifier l'icône
    // ...
  }
}
```

### Ajouter une nouvelle catégorie

1. Ajouter dans l'enum `FoodCategory` (dans `food_offer.dart`)
2. Ajouter dans `Categories._info`
3. Ajouter dans `Categories.ordered`
4. Ajouter dans `iconOf()` et `colorOf()`

## 📍 Fichiers concernés

### ✅ Fichiers déjà migrés :
- `lib/presentation/widgets/stock/stock_category_*_menu.dart`
- `lib/presentation/widgets/home/sections/categories_section.dart`
- `lib/presentation/widgets/store/store_filter_chips.dart`
- `lib/presentation/providers/store_offers_provider.dart`
- `lib/presentation/providers/browse_search_provider.dart`

### 🎯 Exemple d'intégration :
- `lib/presentation/widgets/home/sections/recommended_section.dart` (filtrage automatique)

## 🔄 Migration Guide

Pour migrer un widget existant :

### Avant (strings hardcodées) :
```dart
final categories = ['Petit-déjeuner', 'Déjeuner', 'Dîner'];
final selectedCategory = 'Déjeuner';

return FilterChip(
  label: Text(selectedCategory),
  selected: true,
);
```

### Après (système centralisé) :
```dart
final categories = Categories.ordered;
final selectedCategory = FoodCategory.dejeuner;

return FilterChip(
  avatar: Icon(
    Categories.iconOf(selectedCategory),
    color: Categories.colorOf(selectedCategory),
  ),
  label: Text(Categories.labelOf(selectedCategory)),
  selected: true,
);
```

## 🎁 Avantages

✅ **Cohérence** : Icônes et couleurs unifiées  
✅ **Type Safety** : Utilisation d'enums vs strings  
✅ **Maintenabilité** : Un seul endroit à modifier  
✅ **Internationalisation** : Prêt pour i18n  
✅ **Évolutivité** : Ajout facile de nouvelles catégories  
✅ **Performance** : Filtrage optimisé  

---

*Dernière mise à jour : 2025 - Architecture EcoPlates v2*