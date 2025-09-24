# Guide de Configuration Google Maps API

## 🔑 Erreur Actuelle
Votre application EcoPlates affiche l'erreur :
```
Authorization failure. Please see https://developers.google.com/maps/documentation/android-sdk/start
API Key: AIzaSyCt57yjJiwlrr81dQQusoPVwmKFTWWhR_k
Android Application (<cert_fingerprint>;<package_name>): 4F:A6:9C:2C:D5:F5:D6:D3:63:0F:7E:AB:79:7E:0E:71:74:98:AA:69;com.example.ecoplates
```

## 🛠️ Étapes de Configuration

### 1. Obtenir le Certificat de Signature Debug

Ouvrez un terminal et exécutez :
```bash
# Pour Windows (avec Java installé)
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# Pour macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Vous obtiendrez le SHA-1 fingerprint (exemple : `4F:A6:9C:2C:D5:F5:D6:D3:63:0F:7E:AB:79:7E:0E:71:74:98:AA:69`)

### 2. Configurer Google Cloud Console

1. **Aller sur Google Cloud Console** : https://console.cloud.google.com/

2. **Sélectionner votre projet** ou en créer un nouveau

3. **Activer les APIs** :
   - Allez dans "APIs & Services" > "Library"
   - Recherchez et activez :
     - Maps SDK for Android
     - Maps SDK for iOS (si vous déployez sur iOS)

4. **Configurer la clé API** :
   - Allez dans "APIs & Services" > "Credentials"
   - Cliquez sur votre clé API `AIzaSyCt57yjJiwlrr81dQQusoPVwmKFTWWhR_k`
   - Dans "Application restrictions", sélectionnez "Android apps"
   - Ajoutez ces configurations :

   **Pour Debug (développement)** :
   - Package name : `com.example.ecoplates`
   - SHA-1 certificate fingerprint : `4F:A6:9C:2C:D5:F5:D6:D3:63:0F:7E:AB:79:7E:0E:71:74:98:AA:69`

   **Pour Release (production)** :
   - Vous devrez obtenir le SHA-1 de votre certificat de production

5. **API Restrictions** :
   - Dans "API restrictions", sélectionnez "Restrict key"
   - Cochez : "Maps SDK for Android" et "Maps SDK for iOS"

### 3. Configuration iOS (si nécessaire)

Pour iOS, vous devez aussi ajouter le Bundle ID dans les restrictions :
- Bundle ID : `com.example.ecoplates` (ou votre vrai bundle ID iOS)

### 4. Tester la Configuration

Après avoir configuré la clé API, redémarrez l'application :
```bash
flutter clean
flutter run --debug
```

## 🔧 Configuration Alternative (Temporaire)

Si vous voulez tester rapidement, vous pouvez utiliser une clé API sans restrictions, mais **ce n'est pas recommandé pour la production**.

## 📋 Checklist de Validation

- [ ] Maps SDK for Android activé dans Google Cloud Console
- [ ] Clé API créée et configurée
- [ ] Certificat SHA-1 ajouté pour le package `com.example.ecoplates`
- [ ] API restrictions configurées
- [ ] Application testée après redémarrage

## 🚨 Sécurité Importante

⚠️ **Ne partagez jamais votre clé API** dans le code source ou les repositories publics.

Pour la production :
1. Utilisez des clés API différentes pour développement et production
2. Restreignez toujours les clés API
3. Surveillez l'utilisation dans Google Cloud Console
4. Activez la facturation si nécessaire

## 💡 Dépannage

Si vous avez toujours des erreurs :
1. Vérifiez que l'API est activée
2. Vérifiez les restrictions de la clé API
3. Vérifiez le package name dans `android/app/src/main/AndroidManifest.xml`
4. Redémarrez l'émulateur/appareil
5. Utilisez `flutter clean` avant de relancer

## 📞 Support

Si vous rencontrez des difficultés, consultez :
- [Documentation Google Maps](https://developers.google.com/maps/documentation/android-sdk/start)
- [Google Cloud Console](https://console.cloud.google.com/)
