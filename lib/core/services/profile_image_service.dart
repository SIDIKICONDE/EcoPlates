import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Service pour gérer les images du profil marchand
class ProfileImageService {
  final ImagePicker _picker = ImagePicker();

  /// Sélectionne une image depuis la caméra
  Future<String?> pickFromCamera() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024.0,
        maxHeight: 1024.0,
        imageQuality: 85,
      );
      return image?.path;
    } on Exception {
      return null;
    }
  }

  /// Sélectionne une image depuis la galerie
  Future<String?> pickFromGallery() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024.0,
        maxHeight: 1024.0,
        imageQuality: 85,
      );
      return image?.path;
    } on Exception {
      return null;
    }
  }

  /// Affiche les options de sélection d'image
  Future<String?> showImagePickerOptions(BuildContext context) async {
    final completer = Completer<String?>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Prendre une photo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final path = await pickFromCamera();
                completer.complete(path);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Choisir depuis la galerie',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final path = await pickFromGallery();
                completer.complete(path);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Supprimer la photo',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.of(context).pop();
                completer.complete(null); // null signifie suppression
              },
            ),
          ],
        ),
      ),
    );

    return completer.future;
  }

  /// Affiche un snackbar de succès
  void showSuccessSnackBar(BuildContext context, String message) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  /// Affiche un snackbar d'erreur
  void showErrorSnackBar(BuildContext context, String error) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Erreur: $error',
          style: TextStyle(color: theme.colorScheme.onError),
        ),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}
