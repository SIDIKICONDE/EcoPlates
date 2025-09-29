# Configuration Google Maps

## Configuration de l'API Key

1. **Créer un projet Google Cloud Console**
   - Aller sur https://console.cloud.google.com/
   - Créer un nouveau projet ou sélectionner un projet existant

2. **Activer l'API Google Maps**
   - Activer les APIs suivantes :
     - Maps SDK for Android
     - Maps SDK for iOS
     - Geocoding API (optionnel)

3. **Créer une clé API**
   - Aller dans "APIs & Services" > "Credentials"
   - Créer une nouvelle "API Key"
   - Restreindre la clé aux APIs activées

4. **Configuration dans l'application**
   - Créer un fichier `.env` dans le dossier `environments/`
   - Ajouter : `GOOGLE_MAPS_API_KEY=votre_clé_api_ici`
   - Le fichier `.env` doit être ajouté au `.gitignore`

5. **Restrictions de sécurité**
   - Restreindre la clé API aux applications Android/iOS
   - Pour Android : Ajouter le package name et SHA-1 du certificat
   - Pour iOS : Ajouter le Bundle ID

## Permissions

Les permissions suivantes sont automatiquement configurées :
- Android : `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`
- iOS : `NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`
