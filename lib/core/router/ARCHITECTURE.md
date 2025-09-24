# 🏗️ Architecture du Router EcoPlates

## 📊 Diagramme de l'architecture

```mermaid
graph TB
    A[AppRouter] --> B[PublicRoutes]
    A --> C[MerchantRoutes]
    A --> D[ConsumerRoutes]
    A --> E[EcoPlatesErrorPage]
    
    B --> B1[Onboarding]
    B --> B2[Main Home]
    
    C --> C1[Shell Routes]
    C --> C2[Standalone Routes]
    
    C1 --> C11[Dashboard]
    C1 --> C12[Stock]
    C1 --> C13[Sales]
    C1 --> C14[Store]
    C1 --> C15[Analytics]
    C1 --> C16[Profile]
    
    C2 --> C21[Scan]
    C2 --> C22[Offers]
    C2 --> C23[Create Offer]
    C2 --> C24[Edit Offer]
    C2 --> C25[Reservations]
    
    D --> D1[Shell Routes]
    D --> D2[Standalone Routes]
    
    D1 --> D11[Profile]
    D1 --> D12[Reservations]
    
    D2 --> D21[Merchant Detail]
    D2 --> D22[Merchant Profile]
    D2 --> D23[Offer Detail]
    
    E --> E1[404 Error]
    E --> E2[Merchant Not Found]
    E --> E3[Offer Not Found]
    
    F[RouteConstants] --> A
    F --> B
    F --> C
    F --> D
    F --> E
```

## 🔄 Flux de navigation

```mermaid
sequenceDiagram
    participant U as User
    participant R as Router
    participant M as MerchantRoutes
    participant C as ConsumerRoutes
    participant E as ErrorPage
    
    U->>R: Navigation Request
    R->>R: Check AppMode
    
    alt Merchant Mode
        R->>M: Route to Merchant Interface
        M->>U: Display Merchant Screen
    else Consumer Mode
        R->>C: Route to Consumer Interface
        C->>U: Display Consumer Screen
    else Invalid Route
        R->>E: Show Error Page
        E->>U: Display Error with Actions
    end
```

## 📁 Structure des fichiers

```
lib/core/router/
├── app_router.dart              # 🎯 Point d'entrée principal
│   ├── Provider Riverpod        # Gestion d'état réactive
│   ├── Configuration GoRouter   # Setup du router
│   └── Logique de mode app      # Consumer/Merchant/Onboarding
│
├── routes/
│   ├── index.dart               # 📦 Export centralisé
│   ├── route_constants.dart     # 🔧 Constantes des routes
│   ├── public_routes.dart       # 🌐 Routes publiques
│   ├── merchant_routes.dart     # 🏪 Routes marchandes
│   └── consumer_routes.dart     # 👤 Routes consommateur
│
├── error_page.dart              # 🚨 Gestion d'erreurs
│   ├── UX optimisée             # Interface claire
│   ├── Messages contextuels     # Erreurs spécifiques
│   └── Actions de récupération  # Boutons de navigation
│
├── README.md                    # 📚 Documentation complète
└── ARCHITECTURE.md              # 🏗️ Ce fichier
```

## 🎯 Avantages de cette architecture

### ✅ Séparation des responsabilités
- **Routes publiques** : Onboarding et accueil
- **Routes marchandes** : Interface de gestion
- **Routes consommateur** : Interface d'achat
- **Gestion d'erreurs** : Centralisée et personnalisée

### ✅ Maintenabilité
- **Code modulaire** : Chaque type de route dans son fichier
- **Constantes centralisées** : Évite la duplication
- **Documentation complète** : Guide de maintenance

### ✅ Extensibilité
- **Ajout facile** de nouvelles routes
- **Support multi-modes** : Consumer/Merchant/Onboarding
- **Navigation adaptative** : ShellRoute pour les interfaces complexes

### ✅ Performance
- **Lazy loading** : Chargement à la demande
- **Navigation optimisée** : Utilisation des ShellRoute
- **Gestion mémoire** : Libération automatique

## 🔧 Configuration par mode

| Mode | Route initiale | Interface | Navigation |
|------|----------------|-----------|------------|
| `consumer` | `/merchant/dashboard` | Consommateur | Adaptative |
| `merchant` | `/merchant/dashboard` | Marchande | Par onglets |
| `onboarding` | `/onboarding` | Sélection | Simple |

## 🚀 Prochaines étapes

1. **Tests automatisés** : Validation de la navigation
2. **Monitoring** : Suivi des erreurs de navigation
3. **Optimisations** : Performance et UX
4. **Documentation** : Guide utilisateur

---

*Architecture conçue selon les directives EcoPlates - 2025*
