
# 📱 Directives Modernes de Développement Project EcoPlates

*Guide complet pour le développement Android & iOS en entreprise*

---

## 🏗️ Architecture et Structure du Projet

### Architecture en Couches

* **Couche de Présentation (UI)** : Widgets, écrans, composants visuels
* **Couche Métier (Business Logic)** : Services, logique applicative, état
* **Couche Données** : Repository, API, base de données locale
* **Couche Domaine (optionnelle)** : Entités + Use Cases (recommandée pour les applis complexes en entreprise)

### Structure de Projet Recommandée

```
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   └── themes/
├── domain/              # Ajout entreprise
│   ├── entities/
│   └── usecases/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── bloc/
└── main.dart
```

---

## 🔧 Optimisation des Widgets

* Refactoriser en **widgets dédiés** plutôt qu’en méthodes
* Utiliser systématiquement `const` quand possible
* Minimiser l’usage de `MediaQuery` → préférer `LayoutBuilder` ou `flutter_screenutil`

---

## 📊 Gestion d'État Moderne

* **Riverpod 2.x** (standard recommandé 2025)
* Provider (simple et encore valide)
* BLoC (applications robustes à grande échelle)
* GetX (simple pour prototypage)

---

## 📦 Sélection des Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  go_router: ^13.0.0
  auto_route: ^7.8.0
  dio: ^5.3.2
  drift: ^2.13.0
  cached_network_image: ^3.3.0
  flutter_localizations:
    sdk: flutter
  flutter_secure_storage: ^9.0.0
  flutter_dotenv: ^5.1.0
```

---

## 🎨 Interface Utilisateur et Responsivité

* Utiliser **LayoutBuilder** pour l’adaptatif
* Utiliser `flutter_screenutil` pour gérer tailles & densités
* Prévoir **thèmes séparés** pour Android (Material 3) et iOS (Cupertino)

---

## ⚡ Code Asynchrone et Performance

* Gérer erreurs via `try/catch` et afficher feedback clair
* Libérer ressources dans `dispose()`
* Utiliser `const`, `AnimatedContainer` et widgets optimisés

---

## 🧪 Tests et Qualité

* **Unitaires** → logique métier
* **Widgets** → UI critique
* **Intégration (E2E)** → parcours complet utilisateur
* Blocage des merges si tests échouent (CI/CD)

---

## 🚀 Bonnes Pratiques de Déploiement

* Multi-environnements (`dev / staging / prod`) via `flutter_dotenv`
* CI/CD (GitHub Actions, GitLab CI, Codemagic) pour automatiser builds/tests
* Build release optimisé :

  ```bash
  flutter build apk --release --obfuscate --split-debug-info=debug-symbols/
  flutter build ios --release --obfuscate --split-debug-info=debug-symbols/
  ```

---

## 🔐 Sécurité et Données

* Ne jamais stocker de secrets en dur dans le code → utiliser `.env`
* `flutter_secure_storage` pour tokens et données sensibles
* Respect RGPD, App Store Review et Google Play Policy

---

## 📊 Observabilité & Monitoring

* Crashlytics (Firebase) ou Sentry pour crashs
* Firebase Analytics, Amplitude ou Mixpanel pour suivi d’usage
* Logs structurés côté serveur et appli

---

## 🌍 Accessibilité et Internationalisation

* Utiliser `Semantics` pour screen readers
* Respecter contrastes & tailles dynamiques
* Multi-langues avec `flutter_localizations` + `intl`

---

## 📱 Spécificités Plateformes

### Android

* Cibler API 33+
* Utiliser Material 3
* Optimiser tailles d’écran

### iOS avec Cupertino

* Utiliser **CupertinoApp** pour applis iOS natives
* Possibilité de combiner **MaterialApp + Cupertino widgets** pour hybride
* Toujours gérer **SafeArea** (encoches, Dynamic Island)
* Respecter les **Human Interface Guidelines** Apple

---

## 🏢 Spécificités Projet Entreprise

### 👥 Gestion d’Équipe

* **Code Review obligatoire** avant merge
* Règles de linting (ex : `very_good_analysis`)
* Documentation interne par module

### 📦 Packages internes & maintenance

* Limiter dépendances externes non maintenues
* Créer packages internes pour code réutilisable

### 🔄 Gouvernance technique

* Standardiser conventions de code et structure de projet
* Mettre en place un **guide de contribution** pour l’équipe

---

## 📋 Checklist Pré-Production

* [ ] Tests automatisés 100% OK
* [ ] Analyse (`flutter analyze`) sans warning
* [ ] CI/CD actif
* [ ] Perf validée sur appareils bas de gamme
* [ ] Crashlytics et monitoring configurés
* [ ] Sécurité des données vérifiée
* [ ] Accessibilité testée
* [ ] Internationalisation activée
* [ ] Documentation technique et produit à jour

---

*Guide mis à jour pour Flutter 3.x – 2025 (Entreprise Ready)*

---

👉 Voilà ton guide final **optimisé entreprise**.
Veux-tu que je t’en fasse aussi une **version PDF professionnelle** (style whitepaper avec design sobre) que tu pourrais partager en interne ou aux partenaires ?
Excellent ✅ je vais intégrer les **recommandations Entreprise** directement dans ton guide principal.
Voici la version **mise à jour et complète pour un projet d’entreprise Flutter 2025** :

---

# 📱 Directives Modernes de Développement Flutter 2025

*Guide complet pour le développement Android & iOS en entreprise*

---

## 🏗️ Architecture et Structure du Projet

### Architecture en Couches

* **Couche de Présentation (UI)** : Widgets, écrans, composants visuels
* **Couche Métier (Business Logic)** : Services, logique applicative, état
* **Couche Données** : Repository, API, base de données locale
* **Couche Domaine (optionnelle)** : Entités + Use Cases (recommandée pour les applis complexes en entreprise)

### Structure de Projet Recommandée

```
lib/
├── core/
│   ├── constants/
│   ├── utils/
│   └── themes/
├── domain/              # Ajout entreprise
│   ├── entities/
│   └── usecases/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── bloc/
└── main.dart
```

---

## 🔧 Optimisation des Widgets

* Refactoriser en **widgets dédiés** plutôt qu’en méthodes
* Utiliser systématiquement `const` quand possible
* Minimiser l’usage de `MediaQuery` → préférer `LayoutBuilder` ou `flutter_screenutil`

---

## 📊 Gestion d'État Moderne

* **Riverpod 2.x** (standard recommandé 2025)
* Provider (simple et encore valide)
* BLoC (applications robustes à grande échelle)
* GetX (simple pour prototypage)

---

## 📦 Sélection des Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  go_router: ^13.0.0
  auto_route: ^7.8.0
  dio: ^5.3.2
  drift: ^2.13.0
  cached_network_image: ^3.3.0
  flutter_localizations:
    sdk: flutter
  flutter_secure_storage: ^9.0.0
  flutter_dotenv: ^5.1.0
```

---

## 🎨 Interface Utilisateur et Responsivité

* Utiliser **LayoutBuilder** pour l’adaptatif
* Utiliser `flutter_screenutil` pour gérer tailles & densités
* Prévoir **thèmes séparés** pour Android (Material 3) et iOS (Cupertino)

---

## ⚡ Code Asynchrone et Performance

* Gérer erreurs via `try/catch` et afficher feedback clair
* Libérer ressources dans `dispose()`
* Utiliser `const`, `AnimatedContainer` et widgets optimisés

---

## 🧪 Tests et Qualité

* **Unitaires** → logique métier
* **Widgets** → UI critique
* **Intégration (E2E)** → parcours complet utilisateur
* Blocage des merges si tests échouent (CI/CD)

---

## 🚀 Bonnes Pratiques de Déploiement

* Multi-environnements (`dev / staging / prod`) via `flutter_dotenv`
* CI/CD (GitHub Actions, GitLab CI, Codemagic) pour automatiser builds/tests
* Build release optimisé :

  ```bash
  flutter build apk --release --obfuscate --split-debug-info=debug-symbols/
  flutter build ios --release --obfuscate --split-debug-info=debug-symbols/
  ```

---

## 🔐 Sécurité et Données

* Ne jamais stocker de secrets en dur dans le code → utiliser `.env`
* `flutter_secure_storage` pour tokens et données sensibles
* Respect RGPD, App Store Review et Google Play Policy

---

## 📊 Observabilité & Monitoring

* Crashlytics (Firebase) ou Sentry pour crashs
* Firebase Analytics, Amplitude ou Mixpanel pour suivi d’usage
* Logs structurés côté serveur et appli

---

## 🌍 Accessibilité et Internationalisation

* Utiliser `Semantics` pour screen readers
* Respecter contrastes & tailles dynamiques
* Multi-langues avec `flutter_localizations` + `intl`

---

## 📱 Spécificités Plateformes

### Android

* Cibler API 33+
* Utiliser Material 3
* Optimiser tailles d’écran

### iOS avec Cupertino

* Utiliser **CupertinoApp** pour applis iOS natives
* Possibilité de combiner **MaterialApp + Cupertino widgets** pour hybride
* Toujours gérer **SafeArea** (encoches, Dynamic Island)
* Respecter les **Human Interface Guidelines** Apple

---

## 🏢 Spécificités Projet Entreprise

### 👥 Gestion d’Équipe

* **Code Review obligatoire** avant merge
* Règles de linting (ex : `very_good_analysis`)
* Documentation interne par module

### 📦 Packages internes & maintenance

* Limiter dépendances externes non maintenues
* Créer packages internes pour code réutilisable

### 🔄 Gouvernance technique

* Standardiser conventions de code et structure de projet
* Mettre en place un **guide de contribution** pour l’équipe

---

## 📋 Checklist Pré-Production

* [ ] Tests automatisés 100% OK
* [ ] Analyse (`flutter analyze`) sans warning
* [ ] CI/CD actif
* [ ] Perf validée sur appareils bas de gamme
* [ ] Crashlytics et monitoring configurés
* [ ] Sécurité des données vérifiée
* [ ] Accessibilité testée
* [ ] Internationalisation activée
* [ ] Documentation technique et produit à jour

---

*Guide mis à jour pour Flutter 3.x – 2025 (Entreprise Ready)*
