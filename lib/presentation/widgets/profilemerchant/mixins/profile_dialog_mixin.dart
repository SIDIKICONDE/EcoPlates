import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/enums/merchant_enums.dart';
import '../../../../core/services/profile_image_service.dart';
import '../../../../data/services/merchant_profile_service.dart';
import '../../../../domain/entities/merchant_profile.dart';
import '../merchant_profile_form.dart';

/// Mixin pour gérer les dialogues du profil marchand
mixin ProfileDialogMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final ProfileImageService _imageService = ProfileImageService();

  /// Affiche le formulaire d'édition du profil
  void showEditForm(MerchantProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              // Indicateur de glissement
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              // Titre
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Modifier le profil',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),
              // Formulaire
              Expanded(
                child: MerchantProfileForm(
                  profile: profile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche les options de sélection d'image
  Future<void> showPhotoOptions() async {
    try {
      final imagePath = await _imageService.showImagePickerOptions(context);

      if (imagePath != null) {
        // Upload de l'image
        await ref.read(merchantProfileProvider.notifier).uploadLogo(imagePath);
        if (context.mounted) {
          _imageService.showSuccessSnackBar(context, 'Photo mise à jour');
        }
      } else if (imagePath == null) {
        // Suppression de l'image (null explicite pour suppression)
        await ref.read(merchantProfileProvider.notifier).deleteLogo();
        if (context.mounted) {
          _imageService.showSuccessSnackBar(context, 'Photo supprimée');
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        _imageService.showErrorSnackBar(context, e.toString());
      }
    }
  }

  /// Crée un nouveau profil vide
  MerchantProfile createNewProfile() {
    return MerchantProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      category: MerchantCategory.other,
      createdAt: DateTime.now(),
    );
  }
}
