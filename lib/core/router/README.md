# 🧭 Router EcoPlates

## 📋 Vue d'ensemble

Le router de l'application EcoPlates est conçu selon une architecture modulaire respectant les directives EcoPlates. Il gère la navigation entre les différentes interfaces utilisateur (consommateur, marchand) avec une gestion d'erreurs robuste.

## 🏗️ Architecture

### Structure des fichiers

```
lib/core/router/
├── app_router.dart              # Configuration principale du router
├── error_page.dart              # Page d'erreur personnalisée
├── routes/
│   ├── index.dart               # Export centralisé
│   ├── route_constants.dart     # Constantes des routes
│   ├── public_routes.dart       # Routes publiques
│   ├── merchant_routes.dart     # Routes marchandes
│   └── consumer_routes.dart     # Routes consommateur
└── README.md                    # Cette documentation
```

### Principes de conception

1. **Séparation des responsabilités** : Chaque type de route est dans son propre fichier
2. **Centralisation des constantes** : Toutes les routes sont définies dans `route_constants.dart`
3. **Gestion d'erreurs robuste** : Page d'erreur personnalisée avec UX optimisée
4. **Navigation adaptative** : Support des différents modes d'application

## 🚀 Utilisation

### Import du router

```dart
import 'package:ecoplates/core/router/app_router.dart';

// Utilisation avec Riverpod
final router = ref.watch(appRouterProvider);
```

### Navigation programmatique

```dart
import 'package:ecoplates/core/router/routes/route_constants.dart';

// Navigation par nom (recommandé)
context.goNamed(RouteConstants.merchantDashboardName);

// Navigation par chemin
context.go(RouteConstants.merchantDashboard);
```

## 📱 Types de routes

### Routes publiques
- `/onboarding` : Sélection du type d'utilisateur
- `/` : Page d'accueil principale

### Routes marchandes
- **Avec navigation par onglets** :
  - `/merchant/dashboard` : Tableau de bord
  - `/merchant/stock` : Gestion des stocks
  - `/merchant/sales` : Ventes
  - `/merchant/store` : Boutique
  - `/merchant/analytics` : Analytics
  - `/merchant/profile` : Profil marchand

- **Sans navigation** :
  - `/merchant/scan` : Scanner QR
  - `/merchant/offers` : Gestion des offres
  - `/merchant/offers/create` : Création d'offre
  - `/merchant/offers/:id/edit` : Modification d'offre

### Routes consommateur
- **Avec navigation adaptative** :
  - `/profile` : Profil utilisateur
  - `/reservations` : Réservations

- **Sans navigation** :
  - `/merchant/:id` : Détail d'un marchand
  - `/merchant-profile/:id` : Profil public d'un marchand
  - `/offer/:id` : Détail d'une offre

## 🔧 Configuration

### Modes d'application

Le router s'adapte automatiquement selon le mode d'application :

```dart
enum AppMode {
  consumer,    // Interface consommateur
  merchant,    // Interface marchande
  onboarding,  // Processus d'onboarding
}
```

### Route initiale

La route initiale est déterminée automatiquement selon le mode :
- `consumer` → `/merchant/dashboard` (temporaire)
- `merchant` → `/merchant/dashboard`
- `onboarding` → `/onboarding`

## 🚨 Gestion d'erreurs

### Page d'erreur personnalisée

La page d'erreur `EcoPlatesErrorPage` offre :
- **UX optimisée** : Interface claire et intuitive
- **Messages contextuels** : Erreurs spécifiques selon le type de route
- **Actions de récupération** : Boutons pour retourner à l'accueil ou revenir en arrière
- **Animation** : Transitions fluides pour une meilleure expérience

### Types d'erreurs gérées

- **404** : Page non trouvée
- **Marchand introuvable** : Route `/merchant/:id` invalide
- **Offre introuvable** : Route `/offer/:id` invalide

## 🔄 Maintenance

### Ajout d'une nouvelle route

1. **Ajouter la constante** dans `route_constants.dart`
2. **Créer la route** dans le fichier approprié (`merchant_routes.dart` ou `consumer_routes.dart`)
3. **Tester la navigation** et la gestion d'erreurs
4. **Mettre à jour cette documentation**

### Modification d'une route existante

1. **Modifier la constante** dans `route_constants.dart`
2. **Mettre à jour la configuration** dans le fichier de routes approprié
3. **Vérifier la compatibilité** avec les liens existants
4. **Tester les redirections**

## 📊 Bonnes pratiques

### Navigation
- **Privilégier les noms de routes** plutôt que les chemins pour la navigation programmatique
- **Utiliser les constantes** définies dans `route_constants.dart`
- **Gérer les erreurs** de navigation avec des try-catch appropriés

### Performance
- **Lazy loading** : Les écrans sont chargés à la demande
- **Navigation optimisée** : Utilisation des ShellRoute pour les interfaces avec onglets
- **Gestion mémoire** : Libération automatique des ressources

### Sécurité
- **Validation des paramètres** : Vérification des IDs dans les routes dynamiques
- **Authentification** : Gestion des accès selon le mode d'application
- **Protection des routes** : Redirection automatique selon les permissions

## 🧪 Tests

### Tests recommandés

1. **Tests unitaires** : Validation de la logique de navigation
2. **Tests d'intégration** : Parcours utilisateur complets
3. **Tests d'erreurs** : Gestion des routes invalides
4. **Tests de performance** : Temps de chargement des écrans

### Exemple de test

```dart
testWidgets('Navigation vers le dashboard marchand', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Simuler la navigation
  context.goNamed(RouteConstants.merchantDashboardName);
  await tester.pumpAndSettle();
  
  // Vérifier que l'écran est affiché
  expect(find.byType(MerchantDashboardScreen), findsOneWidget);
});
```

---

*Documentation mise à jour selon les directives EcoPlates - 2025*
