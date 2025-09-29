# ListOfferCard - Architecture Refactorisée

Ce dossier contient les composants refactorisés de la carte d'offre de liste, organisés selon les principes de séparation des responsabilités.

## Structure du dossier

```
list_offer_card/
├── README.md                 # Cette documentation
├── index.dart                # Exports publics du module
├── list_offer_card.dart      # Widget principal refactorisé
├── offer_background_image.dart    # Image de fond avec overlay
├── merchant_logo_with_badge.dart  # Logo avec badge de quantité
└── offer_info_section.dart        # Section d'informations détaillées
```

## Composants

### `ListOfferCard`
Widget principal qui orchestre tous les autres composants. Gère :
- Les animations de tap (scale & elevation)
- La logique de rendu principale
- L'accessibilité (Semantics)

### `OfferBackgroundImage`
Gère l'affichage de l'image de fond avec :
- Image depuis l'offre ou image par défaut selon la catégorie
- Overlay gradient pour la lisibilité du texte
- Gestion des états de chargement et d'erreur

### `MerchantLogoWithBadge`
Affiche le logo du restaurant avec :
- Initiale du nom du restaurant
- Badge indiquant la quantité disponible (vert/orange selon disponibilité)

### `OfferInfoSection`
Section d'informations détaillées contenant :
- Nom du restaurant
- Titre de l'offre
- Prix avec indication gratuite ou réduction
- Distance (optionnelle)
- Horaires de collecte formatés

## Extensions et Utilitaires

### `FoodOfferExtensions` (dans `lib/core/extensions/`)
Extensions ajoutées à `FoodOffer` :
- `isClosed`: Vérifie si la boutique est fermée
- `reopenTime`: Heure de réouverture formatée
- `pickupTimeFormatted`: Heure de collecte formatée
- `backgroundImageUrl`: URL d'image selon la catégorie
- `semanticLabel`: Label d'accessibilité

## Avantages du refactoring

1. **Séparation des responsabilités** : Chaque widget a une responsabilité claire
2. **Réutilisabilité** : Les composants peuvent être réutilisés ailleurs
3. **Maintenance** : Plus facile à modifier et tester individuellement
4. **Lisibilité** : Code plus clair et organisé
5. **Performance** : Widgets plus petits, rebuilds plus ciblés

## Utilisation

```dart
import 'package:ecoplates/presentation/widgets/list_offer_card.dart';

ListOfferCard(
  offer: myFoodOffer,
  distance: 2.5,
  onTap: () => navigateToOfferDetails(),
)
```

## Migration

Le fichier `lib/presentation/widgets/list_offer_card.dart` fait office de facade et exporte automatiquement tous les composants pour maintenir la compatibilité avec l'existant.
