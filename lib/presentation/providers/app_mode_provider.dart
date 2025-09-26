import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';

/// Mode de l'application selon le type d'utilisateur
enum AppMode {
  consumer, // Mode consommateur
  merchant, // Mode commerçant
  onboarding, // Mode onboarding (pas encore connecté)
}

/// Notifier pour gérer le mode de l'application
class AppModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() {
    return AppMode.consumer; // Démarrage direct en mode consommateur
  }

  /// Change le mode de l'application selon le type d'utilisateur
  void setModeFromUser(User user) {
    if (user.isConsumer) {
      state = AppMode.consumer;
    } else if (user.isMerchant || user.type == UserType.staff) {
      state = AppMode.merchant;
    } else {
      // Admin utilise aussi le mode merchant avec plus de fonctionnalités
      state = AppMode.merchant;
    }
  }

  /// Réinitialise le mode (lors de la déconnexion)
  void reset() {
    state = AppMode.onboarding;
  }

  /// Force un mode spécifique (utile pour les tests)
  void setMode(AppMode mode) {
    state = mode;
  }
}

/// Notifier pour l'utilisateur actuel
class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  void setUser(User? user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

/// Provider pour le mode actuel de l'application
final appModeProvider = NotifierProvider<AppModeNotifier, AppMode>(
  AppModeNotifier.new,
);

/// Provider pour l'utilisateur actuel
final currentUserProvider = NotifierProvider<CurrentUserNotifier, User?>(
  CurrentUserNotifier.new,
);

/// Provider pour déterminer si on doit afficher l'interface consommateur
final isConsumerModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.consumer;
});

/// Provider pour déterminer si on doit afficher l'interface commerçant
final isMerchantModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.merchant;
});

/// Provider pour déterminer si l'utilisateur n'est pas connecté
final isOnboardingModeProvider = Provider<bool>((ref) {
  return ref.watch(appModeProvider) == AppMode.onboarding;
});

/// Provider pour déterminer si l'application fonctionne sur iOS
final isIOSProvider = Provider<bool>((ref) {
  return defaultTargetPlatform == TargetPlatform.iOS;
});
