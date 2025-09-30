# Guide d'utilisation du Thème Profond Nyth

## 🎨 Vue d'ensemble

Le nouveau thème profond de Nyth offre une palette de couleurs sophistiquée et confiante, parfaite pour une application professionnelle et moderne. Ce thème inspire la stabilité, la confiance et le professionnalisme.

## 🎯 Palette de couleurs principales

### Couleurs Primaires - Bleu Profond
- **Primary**: `#133784` - Bleu profond confiant
- **Primary Light**: `#365597` - Bleu profond clair
- **Primary Dark**: `#0B2367` - Bleu nuit

### Couleurs Secondaires - Violet Profond
- **Secondary**: `#4C1E7A` - Violet profond créatif
- **Secondary Light**: `#6B3F99` - Violet moyen
- **Secondary Dark**: `#2D0E5C` - Violet très sombre

### Couleurs Tertiaires - Teal Profond
- **Tertiary**: `#006874` - Teal profond moderne
- **Tertiary Light**: `#00838F` - Teal moyen
- **Tertiary Dark**: `#004D57` - Teal très sombre

### Couleurs d'Accent Premium - Or Antique
- **Accent**: `#8B6914` - Or antique
- **Accent Light**: `#B8860B` - Or sombre
- **Accent Dark**: `#654808` - Or très sombre

## 📱 Comment utiliser le thème

### 1. Dans votre main.dart

```dart
import 'package:flutter/material.dart';
import 'package:nyth/core/themes/deep_theme.dart';
// ou si vous voulez garder l'ancien thème aussi
import 'package:nyth/core/themes/eco_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyth',
      // Utiliser le nouveau thème profond
      theme: DeepTheme.lightTheme,
      darkTheme: DeepTheme.darkTheme,
      // Ou garder l'option de l'ancien thème
      // theme: EcoTheme.lightTheme,
      // darkTheme: EcoTheme.darkTheme,
      home: HomePage(),
    );
  }
}
```

### 2. Utiliser les couleurs dans vos widgets

```dart
import 'package:flutter/material.dart';
import 'package:nyth/core/themes/tokens/deep_color_tokens.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // Utiliser directement les tokens de couleur
      color: DeepColorTokens.primary,
      child: Text(
        'Texte confiant',
        style: TextStyle(
          color: DeepColorTokens.neutral0,
        ),
      ),
    );
  }
}
```

### 3. Accéder aux couleurs personnalisées via l'extension

```dart
import 'package:nyth/core/themes/deep_theme.dart';

class PremiumCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deepColors = Theme.of(context).deepColors;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            deepColors?.premiumLight ?? Colors.purple,
            deepColors?.premium ?? Colors.deepPurple,
            deepColors?.premiumDark ?? Colors.deepPurple[900]!,
          ],
        ),
      ),
      child: Text(
        'Contenu Premium',
        style: TextStyle(
          color: DeepColorTokens.neutral0,
        ),
      ),
    );
  }
}
```

### 4. Utiliser les gradients prédéfinis

```dart
class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: DeepColorTokens.primaryGradient,
      ),
      child: Center(
        child: Text(
          'Nyth',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: DeepColorTokens.neutral0,
          ),
        ),
      ),
    );
  }
}
```

## 🌓 Mode Sombre

Le thème inclut un mode sombre sophistiqué avec des surfaces très profondes:

- **Surface principale**: `#1A1D21` - Surface sombre principale
- **Surface élevée**: `#22262B` - Pour les cartes et éléments en relief
- **Surface container**: `#2B3035` - Pour les containers

## 🎭 États et Badges

### Couleurs sémantiques profondes
- **Success**: `#0F5132` - Vert forêt profond
- **Warning**: `#8B4513` - Orange brûlé profond
- **Error**: `#8B0000` - Rouge sang profond
- **Info**: `#0C5460` - Bleu pétrole profond

### Badges spéciaux
- **Urgent**: `#B71C1C` - Rouge profond urgent
- **Premium**: `#4A148C` - Violet royal profond
- **Exclusive**: `#1A237E` - Bleu exclusif
- **Special**: `#4A148C` - Violet spécial

## 💡 Exemples d'utilisation

### Bouton Premium
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: DeepColorTokens.premium,
    foregroundColor: DeepColorTokens.neutral0,
  ),
  onPressed: () {},
  child: Text('Accès Premium'),
)
```

### Card avec gradient de confiance
```dart
Container(
  decoration: BoxDecoration(
    gradient: DeepColorTokens.confidenceGradient,
    borderRadius: BorderRadius.circular(16),
  ),
  padding: EdgeInsets.all(20),
  child: Column(
    children: [
      Icon(Icons.security, color: DeepColorTokens.neutral0, size: 48),
      Text(
        'Vos données sont sécurisées',
        style: TextStyle(
          color: DeepColorTokens.neutral0,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
)
```

### Badge urgent
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: DeepColorTokens.urgent,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    'URGENT',
    style: TextStyle(
      color: DeepColorTokens.neutral0,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
  ),
)
```

## 🔄 Migration depuis l'ancien thème

Si vous souhaitez migrer progressivement:

1. Remplacez `EcoTheme` par `DeepTheme` dans votre `main.dart`
2. Remplacez `EcoColorTokens` par `DeepColorTokens` dans vos widgets
3. Les composants utilisant `Theme.of(context)` s'adapteront automatiquement

## 📊 Comparaison des thèmes

| Aspect | Thème Eco (Ancien) | Thème Deep (Nouveau) |
|--------|-------------------|---------------------|
| Couleur primaire | Vert écologique | Bleu profond confiant |
| Ambiance | Écologique, frais | Professionnel, stable |
| Mode sombre | Gris neutre | Surfaces très profondes |
| Accent | Orange chaleureux | Or antique premium |
| Utilisation | App écologique | App professionnelle |

## 🎯 Cas d'usage recommandés

Le thème profond est parfait pour:
- Applications professionnelles et B2B
- Plateformes financières ou de confiance
- Applications premium avec abonnements
- Interfaces nécessitant une image de stabilité
- Applications de nuit ou à usage prolongé

## 🚀 Performance

Les couleurs ont été optimisées pour:
- Excellent contraste en mode clair et sombre
- Accessibilité WCAG AAA pour le texte principal
- Réduction de la fatigue oculaire en usage prolongé
- Transitions fluides entre les modes clair/sombre