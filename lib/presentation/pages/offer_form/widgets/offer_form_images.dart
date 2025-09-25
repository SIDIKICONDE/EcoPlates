import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/eco_cached_image.dart';
import '../../../providers/offer_form_provider.dart';

/// Section de gestion des images du formulaire d'offre
class OfferFormImages extends ConsumerWidget {
  const OfferFormImages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Affichage de l'image unique
        Container(
          constraints: const BoxConstraints(minHeight: 120),
          child: formState.images.isNotEmpty
              ? _buildImageTile(context, ref, formState.images.first, 0)
              : _buildAddImageButton(context, ref),
        ),

        // Indicateur de validation
        if (formState.images.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Image ajoutée',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAddImageButton(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showImageSourceDialog(context, ref),
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9, // Même ratio que les vraies images
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              style: BorderStyle.solid,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Votre image ici',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sélectionner une photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ref, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ref, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // TODO: Upload l'image vers le serveur et obtenir l'URL
        // Pour l'instant, on simule avec l'URI locale
        // Remplacer l'image existante par la nouvelle
        ref.read(offerFormProvider.notifier).updateImages([image.path]);
      }
    } catch (e) {
      // Gestion d'erreur à implémenter
      debugPrint("Erreur lors de la sélection d'image: $e");
    }
  }

  Widget _buildImageTile(
    BuildContext context,
    WidgetRef ref,
    String imageUrl,
    int index,
  ) {
    final theme = Theme.of(context);
    final formState = ref.watch(offerFormProvider);

    return Stack(
      children: [
        // Conteneur principal avec bordure
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Même ratio que OfferCardImage
              child: Stack(
                children: [
                  // Image principale (gestion des fichiers locaux)
                  Positioned.fill(child: _buildImageWidget(imageUrl)),

                  // Bordure interne subtile (comme dans OfferCardImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.25,
                        ),
                      ),
                    ),
                  ),

                  // Badge quantité (simulé)
                  if (formState.quantity > 0)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${formState.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Badge réduction (si applicable)
                  if (formState.originalPrice > formState.discountedPrice)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '-${formState.discountPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: theme.colorScheme.onError,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Logo du commerçant en bas à gauche (comme dans OfferCardImage)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: _buildMerchantLogo(theme),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bouton de suppression
        Positioned(
          top: 8,
          right: 8,
          child: InkWell(
            onTap: () => _removeImage(ref, index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ),

        // Badge "Aperçu" pour indiquer que c'est un aperçu
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Aperçu',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _removeImage(WidgetRef ref, int index) {
    // Supprimer toutes les images (puisqu'il n'y en a qu'une)
    ref.read(offerFormProvider.notifier).updateImages([]);
  }

  Widget _buildImageWidget(String imageUrl) {
    // Vérifier si c'est un chemin de fichier local (commence par / ou contient file://)
    final isLocalFile =
        imageUrl.startsWith('/') ||
        imageUrl.startsWith('file://') ||
        imageUrl.contains('/storage/') ||
        imageUrl.contains('/data/');

    if (isLocalFile) {
      // Pour les fichiers locaux, utiliser Image.file avec gestion d'erreur
      try {
        final file = File(imageUrl.replaceFirst('file://', ''));
        if (file.existsSync()) {
          return Image.file(file, fit: BoxFit.cover);
        } else {
          // Fichier n'existe pas
          return Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: 40,
            ),
          );
        }
      } catch (e) {
        // En cas d'erreur, afficher un placeholder
        return Container(
          color: Colors.grey[200],
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 40,
          ),
        );
      }
    } else {
      // Pour les URLs réseau, utiliser EcoCachedImage
      return EcoCachedImage(imageUrl: imageUrl, fit: BoxFit.cover);
    }
  }

  /// Construit le logo du commerçant pour l'aperçu
  Widget _buildMerchantLogo(ThemeData theme) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.store, color: theme.colorScheme.primary, size: 28),
        ),
      ),
    );
  }
}
