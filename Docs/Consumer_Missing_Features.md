# 📋 Fonctionnalités Manquantes - Module Consommateur EcoPlates

## 🚨 Priorité CRITIQUE (À implémenter immédiatement)

### 1. Scanner QR Code pour Assiettes
**Fichier concerné:** `lib/presentation/screens/scan_screen.dart`
- **Statut:** Interface présente, logique absente
- **Actions requises:**
  - Intégrer package `mobile_scanner` ou `qr_code_scanner`
  - Implémenter la logique d'emprunt/retour
  - Créer le système de tracking des assiettes
  - Ajouter validation et feedback utilisateur

### 2. Système de Filtrage des Offres
**Fichier concerné:** `lib/presentation/screens/consumer/food_offers_screen.dart`
- **Statut:** UI présente, non fonctionnelle
- **Actions requises:**
  - Créer un provider de filtres avec Riverpod
  - Implémenter la logique de filtrage multicritères
  - Ajouter persistance des préférences
  - Créer une bottom sheet de filtres avancés

### 3. Vue Carte des Offres
**Fichier concerné:** `lib/presentation/screens/consumer/food_offers_screen.dart`
- **Statut:** Bouton présent, fonctionnalité absente
- **Actions requises:**
  - Intégrer `google_maps_flutter` et/ou `apple_maps_flutter`
  - Créer un écran dédié avec carte
  - Ajouter clustering des marqueurs
  - Implémenter navigation vers le commerçant

## 🔥 Priorité HAUTE (Expérience utilisateur)

### 4. Système de Favoris
**Fichiers concernés:** 
- `lib/presentation/screens/consumer/offer_detail_screen.dart`
- Nouveau: `lib/presentation/screens/consumer/favorites_screen.dart`
- **Actions requises:**
  - Créer provider de favoris
  - Implémenter stockage local (Drift/Hive)
  - Créer écran de gestion des favoris
  - Ajouter animations de like/unlike

### 5. Notifications Push
**Actions requises:**
- Intégrer Firebase Cloud Messaging
- Créer service de notifications
- Implémenter les triggers:
  - Nouvelles offres dans la zone
  - Rappels 30min avant collecte
  - Offres favorites disponibles
  - Changements de statut réservation

### 6. Système de Paiement
**Actions requises:**
- Intégrer Stripe/PayPal SDK
- Créer écran de paiement sécurisé
- Implémenter wallet virtuel
- Ajouter historique des transactions
- Gérer les remboursements

### 7. Recherche Intelligente
**Actions requises:**
- Créer barre de recherche avec suggestions
- Implémenter recherche full-text
- Ajouter filtres de recherche rapides
- Historique de recherche

## 📈 Priorité MOYENNE (Engagement & Rétention)

### 8. Statistiques Dynamiques
**Fichier concerné:** `lib/presentation/screens/consumer/food_offers_screen.dart`
- **Actions requises:**
  - Remplacer valeurs hardcodées
  - Créer service de calcul CO₂
  - Implémenter tracking des économies
  - Ajouter graphiques d'évolution

### 9. Système de Notes et Avis
**Actions requises:**
- Créer modèle Review
- Interface de notation (1-5 étoiles)
- Système de commentaires modérés
- Affichage des avis sur les offres

### 10. Partage Social
**Fichier concerné:** `lib/presentation/screens/consumer/offer_detail_screen.dart`
- **Actions requises:**
  - Intégrer `share_plus` package
  - Créer deep links pour partage
  - Ajouter système de parrainage
  - Intégrer réseaux sociaux

### 11. Gamification
**Actions requises:**
- Système de points EcoCoins
- Badges et achievements
- Défis hebdomadaires/mensuels
- Classement entre amis
- Récompenses échangeables

## 🎨 Priorité BASSE (Améliorations UX)

### 12. Mode Sombre
**Actions requises:**
- Créer thème sombre
- Implémenter switch de thème
- Persister préférence utilisateur
- Support mode système

### 13. Multi-langue (i18n)
**Actions requises:**
- Intégrer `flutter_localizations`
- Traduire tous les textes
- Support minimum: FR, EN, ES
- Détection langue système

### 14. Accessibilité
**Actions requises:**
- Ajouter Semantics widgets
- Support navigation clavier
- Tailles de police adaptatives
- Contraste amélioré

### 15. Fonctionnalités Avancées
- **Mode hors-ligne** avec synchronisation
- **Chat** avec les commerçants
- **Programme de fidélité** inter-commerces
- **Suggestions IA** basées sur l'historique
- **Widget iOS/Android** pour offres du jour

## 📊 Tableau de Priorisation

| Priorité | Fonctionnalité | Effort (j/h) | Impact | Statut |
|----------|---------------|--------------|--------|---------|
| 🚨 CRITIQUE | Scanner QR | 3-5j | Très Élevé | TODO |
| 🚨 CRITIQUE | Filtres | 2-3j | Très Élevé | TODO |
| 🚨 CRITIQUE | Carte | 3-4j | Très Élevé | TODO |
| 🔥 HAUTE | Favoris | 2j | Élevé | TODO |
| 🔥 HAUTE | Notifications | 3-4j | Élevé | TODO |
| 🔥 HAUTE | Paiement | 5-7j | Très Élevé | TODO |
| 🔥 HAUTE | Recherche | 2-3j | Élevé | TODO |
| 📈 MOYENNE | Stats dynamiques | 2j | Moyen | TODO |
| 📈 MOYENNE | Notes/Avis | 3j | Moyen | TODO |
| 📈 MOYENNE | Partage | 1-2j | Moyen | TODO |
| 📈 MOYENNE | Gamification | 4-5j | Élevé | TODO |
| 🎨 BASSE | Mode sombre | 1j | Faible | TODO |
| 🎨 BASSE | i18n | 2-3j | Moyen | TODO |
| 🎨 BASSE | Accessibilité | 2j | Moyen | TODO |

## 🚀 Plan d'Action Recommandé

### Phase 1 (Sprint 1-2) - Fonctionnalités Core
1. Implémenter Scanner QR
2. Activer système de filtrage
3. Intégrer vue carte

### Phase 2 (Sprint 3-4) - Monétisation & Engagement
4. Système de paiement
5. Notifications push
6. Favoris et recherche

### Phase 3 (Sprint 5-6) - Croissance & Rétention
7. Gamification
8. Système d'avis
9. Partage social
10. Statistiques dynamiques

### Phase 4 (Sprint 7+) - Polish & Optimisation
11. Mode sombre
12. Multi-langue
13. Accessibilité
14. Fonctionnalités avancées

## 📦 Packages Recommandés

```yaml
dependencies:
  # Scanner QR
  mobile_scanner: ^3.5.0
  
  # Cartes
  google_maps_flutter: ^2.5.0
  
  # Notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.0.0
  
  # Paiement
  flutter_stripe: ^9.5.0
  
  # Partage
  share_plus: ^7.2.0
  
  # Internationalisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1
  
  # Gamification
  confetti: ^0.7.0
  lottie: ^2.7.0
```

## 💡 Notes Importantes

1. **Prioriser l'expérience mobile** avant le web
2. **Tests utilisateurs** après chaque phase
3. **Analytics** dès la Phase 1 pour mesurer l'impact
4. **Backend API** doit supporter toutes ces fonctionnalités
5. **Performance** : optimiser avant d'ajouter trop de features

---

*Document généré le 23/01/2025 - À mettre à jour après chaque sprint*