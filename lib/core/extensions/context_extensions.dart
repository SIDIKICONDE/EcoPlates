import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../error/failures.dart';
import '../responsive/design_tokens.dart';

/// Extensions pour BuildContext pour faciliter l'affichage d'erreurs et de notifications
extension ContextExtensions on BuildContext {
  // === Gestion des erreurs ===

  /// Affiche une erreur sous forme de SnackBar
  void showError(Failure failure) {
    if (this is! Element || !(this as Element).mounted) return;

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: EcoPlatesDesignTokens.colors.textPrimary,
              size: EcoPlatesDesignTokens.notificationIconSize,
            ),
            SizedBox(width: EcoPlatesDesignTokens.notificationIconSpacing),
            Expanded(
              child: Text(
                failure.userMessage,
                style: TextStyle(
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: EcoPlatesDesignTokens.notificationError(this),
        behavior: SnackBarBehavior.floating,
        duration: _getErrorDuration(failure),
        action: failure is NetworkFailure
            ? SnackBarAction(
                label: 'Réessayer',
                textColor: EcoPlatesDesignTokens.colors.textPrimary,
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
    if (this is! Element || !(this as Element).mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: EcoPlatesDesignTokens.colors.textPrimary,
              size: EcoPlatesDesignTokens.notificationIconSize,
            ),
            SizedBox(width: EcoPlatesDesignTokens.notificationIconSpacing),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: EcoPlatesDesignTokens.notificationSuccess(this),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un message d'information
  void showInfo(String message) {
    if (this is! Element || !(this as Element).mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: EcoPlatesDesignTokens.colors.textPrimary,
              size: EcoPlatesDesignTokens.notificationIconSize,
            ),
            SizedBox(width: EcoPlatesDesignTokens.notificationIconSpacing),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: EcoPlatesDesignTokens.notificationInfo(this),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un avertissement
  void showWarning(String message) {
    if (this is! Element || !(this as Element).mounted) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_outlined,
              color: EcoPlatesDesignTokens.colors.textPrimary,
              size: EcoPlatesDesignTokens.notificationIconSize,
            ),
            SizedBox(width: EcoPlatesDesignTokens.notificationIconSpacing),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: EcoPlatesDesignTokens.notificationWarning(this),
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
    if (this is! Element || !(this as Element).mounted) return;
    return showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: EcoPlatesDesignTokens.notificationError(this),
            ),
            SizedBox(width: EcoPlatesDesignTokens.errorDialogSpacing),
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
    if (this is! Element || !(this as Element).mounted) return null;
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
    if (this is! Element || !(this as Element).mounted) return;
    unawaited(
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
      ),
    );
  }

  /// Ferme le loading dialog
  void hideLoadingDialog() {
    if (this is! Element || !(this as Element).mounted) return;
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: ui.Radius.circular(EcoPlatesDesignTokens.dialogBorderRadius),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(EcoPlatesDesignTokens.dialogPadding),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            Divider(height: EcoPlatesDesignTokens.dividerHeight),
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
            SizedBox(height: EcoPlatesDesignTokens.bottomSheetEndSpacing),
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
  ui.Size get screenSize => MediaQuery.of(this).size;

  /// Récupère la largeur de l'écran
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Récupère la hauteur de l'écran
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Vérifie si l'écran est en mode sombre
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Vérifie si c'est un écran large (tablette)
  bool get isTablet =>
      MediaQuery.of(this).size.width >= EcoPlatesDesignTokens.tabletBreakpoint;

  /// Ferme le clavier
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  // === Méthodes privées ===

  Duration _getErrorDuration(Failure failure) {
    if (failure is ValidationFailure) {
      return const Duration(seconds: 4);
    } else if (failure is NetworkFailure) {
      return const Duration(seconds: 6);
    } else {
      return const Duration(seconds: 3);
    }
  }
}

/// Option pour les bottom sheets
class BottomSheetOption<T> {
  const BottomSheetOption({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;
}
