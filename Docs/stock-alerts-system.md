# Système d'Alertes de Stock Faible

## Vue d'ensemble

Le système d'alertes permet de configurer des seuils de stock minimum pour chaque article et d'être notifié lorsque le stock devient faible.

## Fonctionnalités implémentées

### 1. Configuration du seuil d'alerte
- **Champ optionnel** : `lowStockThreshold` sur chaque article
- **Configuration** : Via le formulaire d'édition avec un switch on/off
- **Validation** : Le seuil doit être positif ou nul

### 2. Niveaux d'alerte
Trois niveaux sont définis dans `StockAlertLevel` :
- **Normal** : Stock au-dessus du seuil
- **Low** (Stock faible) : Stock <= seuil configuré mais > 0
- **OutOfStock** (Rupture) : Stock = 0

### 3. Indicateurs visuels

#### Badge d'alerte (`StockAlertBadge`)
- Icône et couleur selon le niveau
- Mode compact disponible
- Affichage optionnel du label

#### Indicateur de stock (`StockIndicator`)
- Affiche la quantité avec couleur codée
- Badge d'alerte intégré

#### Résumé des alertes (`StockAlertsSummary`)
- Affiché en haut de la page stock
- Compte des articles en rupture et stock faible
- Caché si aucune alerte

### 4. Intégration dans l'interface

#### Page de stock principale
- Résumé des alertes sous la barre de recherche
- Badges d'alerte dans chaque item de la liste
- Compteurs dans l'AppBar

#### Page de détail
- Affichage du seuil configuré si défini
- Badge d'alerte selon l'état actuel

#### Formulaire d'édition
- Widget `StockThresholdField` pour configurer le seuil
- Switch pour activer/désactiver l'alerte
- Validation en temps réel

### 5. Providers disponibles

- `lowStockItemsProvider` : Liste des articles avec stock faible
- `stockAlertItemsProvider` : Tous les articles nécessitant une alerte
- `outOfStockItemsProvider` : Articles en rupture (existant)

## Exemples d'utilisation

### Configurer un seuil d'alerte
```dart
// Dans le formulaire, le seuil est configuré via StockThresholdField
StockThresholdField(
  controller: _thresholdController,
  unit: item.unit,
  onChanged: (value) {
    // Mise à jour du seuil
  },
)
```

### Afficher un badge d'alerte
```dart
StockAlertBadge(
  alertLevel: item.alertLevel,
  showLabel: true,
  compact: false,
)
```

### Récupérer les articles avec alertes
```dart
final lowStockItems = ref.watch(lowStockItemsProvider);
final alertItems = ref.watch(stockAlertItemsProvider);
```

## Articles de test avec seuils

Les articles suivants ont des seuils configurés pour démonstration :
- **Pommes Gala** : Seuil 10 kg (stock normal à 25 kg)
- **Tomates cerises** : Seuil 15 barquettes (stock faible à 12)
- **Lasagnes veggie** : Seuil 10 portions (stock faible à 6)
- **Smoothie vert** : Seuil 8 bouteilles (stock faible à 7)

## Évolutions futures possibles

1. **Notifications push** : Alertes en temps réel
2. **Configuration globale** : Seuils par catégorie
3. **Historique** : Suivi des alertes dans le temps
4. **Actions automatiques** : Commandes de réapprovisionnement
5. **Personnalisation** : Couleurs et icônes configurables