# 🔐 EcoPlates Security Setup Guide

*How to properly configure API keys and secrets for EcoPlates development and deployment*

---

## 🎯 Overview

This guide explains how to securely configure API keys and other sensitive data for EcoPlates. **Never commit secrets to version control.**

## 🚨 Quick Start (First Time Setup)

### 1. Create Environment Files

```bash
# Copy the template for each environment
cp .env.example environments/.env.dev
cp .env.example environments/.env.staging
cp .env.example environments/.env.prod
```

### 2. Configure Google Maps API Key

#### Get your API key:
1. Go to [Google Cloud Console](https://console.cloud.google.com/google/maps-apis)
2. Create a new project or select existing
3. Enable "Maps SDK for Android" and "Maps SDK for iOS"
4. Create credentials → API Key
5. **IMPORTANT**: Restrict the key:
   - For Android: Add your app package name and SHA-1 fingerprint
   - For iOS: Add your iOS bundle identifier

#### Add to environment files:
```bash
# In environments/.env.dev, .env.staging, .env.prod
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

### 3. Configure Platform-Specific Files

#### Android Setup:
```bash
# Copy template and configure
cp android/local.properties.example android/local.properties

# Edit android/local.properties
googleMapsApiKey=your_actual_api_key_here
```

#### iOS Setup:
```bash
# Copy template and configure  
cp ios/Config/Secrets.xcconfig.example ios/Config/Secrets.xcconfig

# Edit ios/Config/Secrets.xcconfig
GOOGLE_MAPS_API_KEY=your_actual_api_key_here
```

**For iOS**: You must also add `Secrets.xcconfig` to your Xcode project:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click Runner project → "Add Files to Runner"
3. Select `ios/Config/Secrets.xcconfig`
4. In project settings, set `Secrets` as the configuration file for Debug/Release

## 🏗️ Development Workflow

### Running the App

```bash
# The app will automatically load from environments/.env.dev
flutter run

# For different environments:
flutter run --dart-define=ENV=staging
flutter run --dart-define=ENV=prod
```

### Building

```bash
# Android
flutter build apk --release

# iOS  
flutter build ios --release
```

## 🔄 CI/CD Configuration

### GitHub Actions Secrets

Add these secrets to your GitHub repository:

- `GOOGLE_MAPS_API_KEY_DEV`
- `GOOGLE_MAPS_API_KEY_STAGING` 
- `GOOGLE_MAPS_API_KEY_PROD`

The CI workflow will automatically inject these during builds.

### Other CI Platforms

For GitLab CI, Azure DevOps, etc., add equivalent environment variables and update the workflow files.

## 📋 Security Checklist

### ✅ Development
- [ ] `.env*` files are in `.gitignore`
- [ ] `android/local.properties` is in `.gitignore`
- [ ] `ios/Config/Secrets.xcconfig` is in `.gitignore`
- [ ] No hardcoded secrets in source code
- [ ] API keys are properly restricted in Google Cloud Console

### ✅ Before Commit
- [ ] Run `git status` to verify no secrets are staged
- [ ] Search codebase for any hardcoded keys: `grep -r "AIzaSy" .`
- [ ] Verify builds work with placeholder/test keys

### ✅ Production Deploy
- [ ] Production API keys are configured in CI/CD secrets
- [ ] API keys have proper restrictions (package names, bundle IDs)
- [ ] Monitor API usage for unexpected spikes

## 🚨 Security Incidents

### If API Key is Compromised:

1. **Immediately revoke** the key in Google Cloud Console
2. **Generate a new key** with proper restrictions
3. **Update all environments** (dev, staging, prod)
4. **Rotate CI/CD secrets**
5. **Monitor billing** for unauthorized usage

## 🔧 Troubleshooting

### "GOOGLE_MAPS_API_KEY not found" Error
- Verify your `.env` file exists and contains the key
- Check file path: `environments/.env.dev` (not root `.env`)
- Ensure key has no quotes: `GOOGLE_MAPS_API_KEY=AIzaSy...` not `"AIzaSy..."`

### Maps Not Loading (Android)
- Check `android/local.properties` has the key
- Verify package name matches in Google Cloud restrictions
- Check SHA-1 fingerprint is correct (get with: `keytool -list -v -keystore ~/.android/debug.keystore`)

### Maps Not Loading (iOS)
- Ensure `Secrets.xcconfig` is added to Xcode project
- Check bundle identifier matches Google Cloud restrictions  
- Verify the key is active in Google Cloud Console

### CI/CD Build Failures
- Check that secrets are properly configured in your CI platform
- Verify the secret names match those used in workflow files
- Ensure environment files are created before builds

## 📞 Support

For security-related issues:
- Contact your team lead immediately
- Don't post API keys in Slack/tickets
- Use secure channels for sensitive information

---

## 🔄 Key Rotation Schedule

**Recommended rotation frequency:**
- Development keys: Every 6 months
- Staging keys: Every 3 months  
- Production keys: Every 3 months or immediately if compromised

---

*Last updated: September 2025*