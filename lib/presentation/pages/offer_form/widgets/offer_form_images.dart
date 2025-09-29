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
          constraints: BoxConstraints(minHeight: 200.0),
          child: formState.images.isNotEmpty
              ? _buildImageTile(context, ref, formState.images.first, 0)
              : _buildAddImageButton(context, ref),
        ),

        // Indicateur de validation
        if (formState.images.isNotEmpty) ...[
          SizedBox(height: 12.0),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Text(
                'Image ajoutée',
                style: TextStyle(
                  fontSize: 14.0,
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

    // Valeurs en dur
    const borderRadius = 12.0;
    const iconSize = 48.0;
    const spacing = 12.0;
    const textSize = 16.0;

    return InkWell(
      onTap: () => _showImageSourceDialog(context, ref),
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
              width: 2.0,
              style: BorderStyle.solid,
            ),
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: theme.colorScheme.primary,
                size: iconSize,
              ),
              SizedBox(height: spacing),
              Text(
                'Ajouter une image',
                style: TextStyle(
                  fontSize: textSize,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'Votre image ici',
                style: TextStyle(
                  fontSize: 12.0,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Valeurs en dur pour la modale
    const titleSize = 18.0;

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sélectionner une photo',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 24.0),
                title: Text(
                  'Prendre une photo',
                  style: TextStyle(fontSize: 16.0),
                ),
                contentPadding: EdgeInsets.all(16.0),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ref, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, size: 24.0),
                title: Text(
                  'Choisir depuis la galerie',
                  style: TextStyle(fontSize: 16.0),
                ),
                contentPadding: EdgeInsets.all(16.0),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ref, ImageSource.gallery);
                },
              ),
              SizedBox(height: 16.0),
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
        maxWidth: 1920.0,
        maxHeight: 1080.0,
        imageQuality: 85,
      );

      if (image != null) {
        // TODO: Upload l'image vers le serveur et obtenir l'URL
        // Pour l'instant, on simule avec l'URI locale
        // Remplacer l'image existante par la nouvelle
        ref.read(offerFormProvider.notifier).updateImages([
          image.path,
        ]);
      }
    } on Exception catch (e) {
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

    // Valeurs en dur
    const borderRadius = 12.0;
    const badgeTextSize = 12.0;
    const closeIconSize = 20.0;
    const logoSize = 40.0;

    return Card(
      elevation: 2.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  // Image principale
                  Positioned.fill(child: _buildImageWidget(context, imageUrl)),

                  // Bordure interne subtile
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Badge quantité (si applicable)
                  if (formState.quantity > 0)
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          '${formState.quantity}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: badgeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Badge réduction (si applicable)
                  if (formState.originalPrice > formState.discountedPrice)
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          '-${((formState.originalPrice - formState.discountedPrice) / formState.originalPrice * 100).round()}%',
                          style: TextStyle(
                            color: theme.colorScheme.onError,
                            fontSize: badgeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Logo du commerçant en bas à gauche
                  Positioned(
                    bottom: 8.0,
                    left: 8.0,
                    child: _buildMerchantLogo(context, theme, logoSize),
                  ),
                ],
              ),
            ),

            // Bouton de suppression
            Positioned(
              top: 8.0,
              right: 8.0,
              child: InkWell(
                onTap: () => _removeImage(ref, index),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.0,
                        offset: Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onError,
                    size: closeIconSize,
                  ),
                ),
              ),
            ),

            // Badge "Aperçu" pour indiquer que c'est un aperçu
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2.0,
                      offset: Offset(0, 1.0),
                    ),
                  ],
                ),
                child: Text(
                  'Aperçu',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeImage(WidgetRef ref, int index) {
    // Supprimer toutes les images (puisqu'il n'y en a qu'une)
    ref.read(offerFormProvider.notifier).updateImages([]);
  }

  Widget _buildImageWidget(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);

    // Vérifier si c'est un chemin de fichier local
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
          return ColoredBox(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported,
              color: theme.colorScheme.onSurfaceVariant,
              size: 48.0,
            ),
          );
        }
      } catch (e) {
        // Erreur lors du chargement du fichier local
        return ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image,
            color: theme.colorScheme.onSurfaceVariant,
            size: 48.0,
          ),
        );
      }
    } else {
      // Pour les URLs réseau, utiliser EcoCachedImage
      return EcoCachedImage(imageUrl: imageUrl);
    }
  }

  /// Construit le logo du commerçant pour l'aperçu
  Widget _buildMerchantLogo(
    BuildContext context,
    ThemeData theme,
    double logoSize,
  ) {
    const iconSize = 20.0;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Icon(
        Icons.store,
        color: theme.colorScheme.primary,
        size: iconSize,
      ),
    );
  }
}
