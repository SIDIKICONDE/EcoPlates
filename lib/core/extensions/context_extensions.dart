import 'package:flutter/material.dart';

import '../error/failures.dart';

/// Extensions pour BuildContext pour faciliter l'affichage d'erreurs et de notifications
extension ContextExtensions on BuildContext {
  // === Gestion des erreurs ===

  /// Affiche une erreur sous forme de SnackBar
  void showError(Failure failure) {
    final messenger = ScaffoldMessenger.of(this);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                failure.userMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: _getErrorColor(failure),
        behavior: SnackBarBehavior.floating,
        duration: _getErrorDuration(failure),
        action: failure is NetworkFailure
            ? SnackBarAction(
                label: 'Réessayer',
                textColor: Colors.white,
                onPressed: () {
                  // L'action sera gérée par le widget parent
                },
              )
            : null,
      ),
    );
  }

  /// Affiche un message de succès
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un message d'information
  void showInfo(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un avertissement
  void showWarning(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // === Dialogs ===

  /// Affiche un dialog d'erreur détaillé
  Future<void> showErrorDialog(
    Failure failure, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: _getErrorColor(failure)),
            const SizedBox(width: 8),
            Text(title ?? 'Erreur'),
          ],
        ),
        content: SingleChildScrollView(child: Text(failure.userMessage)),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Réessayer'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Affiche un dialog de confirmation
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Affiche un loading dialog
  void showLoadingDialog([String? message]) {
    showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(message ?? 'Chargement...')),
          ],
        ),
      ),
    );
  }

  /// Ferme le loading dialog
  void hideLoadingDialog() {
    Navigator.of(this).pop();
  }

  // === Bottom Sheets ===

  /// Affiche un bottom sheet avec options
  Future<T?> showOptionsBottomSheet<T>({
    required String title,
    required List<BottomSheetOption<T>> options,
  }) async {
    return showModalBottomSheet<T>(
      context: this,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const Divider(height: 1),
            ...options.map(
              (option) => ListTile(
                leading: option.icon != null ? Icon(option.icon) : null,
                title: Text(option.title),
                subtitle: option.subtitle != null
                    ? Text(option.subtitle!)
                    : null,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // === Utilitaires ===

  /// Récupère le thème actuel
  ThemeData get theme => Theme.of(this);

  /// Récupère les couleurs du thème
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Récupère la taille de l'écran
  Size get screenSize => MediaQuery.of(this).size;

  /// Récupère la largeur de l'écran
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Récupère la hauteur de l'écran
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Vérifie si l'écran est en mode sombre
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Vérifie si c'est un écran large (tablette)
  bool get isTablet => MediaQuery.of(this).size.width >= 768;

  /// Ferme le clavier
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  // === Méthodes privées ===

  Color _getErrorColor(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return Colors.orange;
      case ValidationFailure _:
        return Colors.amber;
      case AuthenticationFailure _:
      case AuthorizationFailure _:
        return Colors.red;
      case NotFoundFailure _:
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  Duration _getErrorDuration(Failure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure _:
        return const Duration(seconds: 4);
      case NetworkFailure _:
        return const Duration(seconds: 6);
      default:
        return const Duration(seconds: 3);
    }
  }
}

/// Option pour les bottom sheets
class BottomSheetOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;

  const BottomSheetOption({
    required this.title,
    this.subtitle,
    this.icon,
    required this.value,
  });
}
