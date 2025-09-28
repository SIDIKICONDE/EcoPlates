# 🎨 Architecture des Thèmes EcoPlates

## 📋 Vue d'ensemble

Le système de thèmes EcoPlates est basé sur une architecture modulaire et cohérente utilisant Material Design 3 avec des extensions personnalisées pour l'identité visuelle de la marque.

## 🏗️ Structure

### 🎯 **Thème Principal**
- **`eco_theme.dart`** - Thème unifié EcoPlates avec tous les composants

### ⚙️ **Gestion d'État**
- **`theme_provider.dart`** - Provider Riverpod pour le changement de thème (clair/sombre/système)

### 🎨 **Tokens de Design**
- **`color_tokens.dart`** - Palette de couleurs complète
- **`typography_tokens.dart`** - Styles de texte cohérents  
- **`spacing_tokens.dart`** - Espacements standardisés
- **`elevation_tokens.dart`** - Ombres et élévations
- **`radius_tokens.dart`** - Rayons de bordure

### 🧩 **Composants Thématiques**
- **`button_theme.dart`** - Styles pour tous les boutons
- **`card_theme.dart`** - Styles des cartes et conteneurs
- **`input_theme.dart`** - Styles des champs de saisie
- **`navigation_theme.dart`** - Styles de navigation (AppBar, BottomNav, etc.)

### 📱 **Thèmes Spécialisés**
- **`cupertino_theme.dart`** - Thème iOS/macOS adaptatif

## 🚀 **Usage**

### Import centralisé
```dart
import '../../core/themes/themes.dart';
```

### Utilisation du thème
```dart
// Dans un widget
Theme.of(context).colorScheme.primary
context.ecoColors.success // Couleurs personnalisées

// Avec Riverpod
final theme = ref.watch(currentThemeProvider);
final isDark = ref.watch(isDarkThemeProvider);
```

### Changement de thème
```dart
// Changer le mode
ref.read(themeProvider.notifier).setThemeMode(EcoThemeMode.dark);

// Basculer
ref.read(themeProvider.notifier).toggleTheme();
```

## ✨ **Avantages**

- 🎯 **Cohérence** - Design uniforme dans toute l'app
- 🔄 **Maintenabilité** - Modifications centralisées
- 🌓 **Thème adaptatif** - Support clair/sombre/système
- 📱 **Multi-plateforme** - Material + Cupertino
- 🎨 **Extensible** - Couleurs et styles personnalisés
- ⚡ **Performance** - Providers optimisés

## 📚 **Références**

- [Material Design 3](https://m3.material.io/)
- [Flutter Theming](https://docs.flutter.dev/ui/design/material)
- [Riverpod State Management](https://riverpod.dev/)
