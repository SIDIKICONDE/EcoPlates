import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/responsive/responsive.dart';
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
          constraints: BoxConstraints(
            minHeight: EcoPlatesDesignTokens.layout.imageMinHeight,
          ),
          child: formState.images.isNotEmpty
              ? _buildImageTile(context, ref, formState.images.first, 0)
              : _buildAddImageButton(context, ref),
        ),

        // Indicateur de validation
        if (formState.images.isNotEmpty) ...[
          SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: EcoPlatesDesignTokens.size.indicator(context),
              ),
              SizedBox(width: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text(
                'Image ajoutée',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
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

    // Design tokens responsives
    final iconSize =
        EcoPlatesDesignTokens.size.icon(context) *
        EcoPlatesDesignTokens.size.largeIconMultiplier;
    final borderRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final spacing = EcoPlatesDesignTokens.spacing.interfaceGap(context);
    final textSize = EcoPlatesDesignTokens.typography.text(context);

    return InkWell(
      onTap: () => _showImageSourceDialog(context, ref),
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: EcoPlatesDesignTokens.layout.imageAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              width: EcoPlatesDesignTokens.layout.decorativeBorderWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
                ),
                size: iconSize,
              ),
              SizedBox(height: spacing),
              Text(
                'Votre image ici',
                style: TextStyle(
                  fontSize: textSize,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.textSecondary,
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

  Future<void> _showImageSourceDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // Design tokens responsives pour la modale
    final modalPadding = EcoPlatesDesignTokens.spacing.contentPadding(context);
    final titleSize = EcoPlatesDesignTokens.typography.modalTitle(context);

    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: modalPadding,
                child: Text(
                  'Sélectionner une photo',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  size: EcoPlatesDesignTokens.size.icon(context),
                ),
                title: Text(
                  'Prendre une photo',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                  ),
                ),
                contentPadding: modalPadding,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ref, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  size: EcoPlatesDesignTokens.size.icon(context),
                ),
                title: Text(
                  'Choisir depuis la galerie',
                  style: TextStyle(
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                  ),
                ),
                contentPadding: modalPadding,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ref, ImageSource.gallery);
                },
              ),
              SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
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
        maxWidth: EcoPlatesDesignTokens.layout.imageMaxWidth,
        maxHeight: EcoPlatesDesignTokens.layout.imageMaxHeight,
        imageQuality: EcoPlatesDesignTokens.layout.imageQuality,
      );

      if (image != null) {
        // TODO: Upload l'image vers le serveur et obtenir l'URL
        // Pour l'instant, on simule avec l'URI locale
        // Remplacer l'image existante par la nouvelle
        ref.read<OfferFormNotifier>(offerFormProvider.notifier).updateImages([
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

    // Design tokens responsives
    final borderRadius = EcoPlatesDesignTokens.radius.fieldRadius(context);
    final badgePadding = EcoPlatesDesignTokens.spacing
        .contentPadding(context)
        .copyWith(
          left: EcoPlatesDesignTokens.spacing.interfaceGap(context),
          right: EcoPlatesDesignTokens.spacing.interfaceGap(context),
        );
    final badgeTextSize = EcoPlatesDesignTokens.typography.hint(context);
    final closeIconSize = EcoPlatesDesignTokens.size.indicator(context);
    final logoSize =
        EcoPlatesDesignTokens.size.icon(context) *
        EcoPlatesDesignTokens.size.largeIconMultiplier;

    return Stack(
      children: [
        // Conteneur principal avec bordure
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - 1),
            child: AspectRatio(
              aspectRatio: EcoPlatesDesignTokens.layout.imageAspectRatio,
              child: Stack(
                children: [
                  // Image principale (gestion des fichiers locaux)
                  Positioned.fill(child: _buildImageWidget(context, imageUrl)),

                  // Bordure interne subtile (comme dans OfferCardImage)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: EcoPlatesDesignTokens.opacity.pressed,
                          ),
                          width: EcoPlatesDesignTokens.layout.subtleBorderWidth,
                        ),
                      ),
                    ),
                  ),

                  // Badge quantité (simulé)
                  if (formState.quantity > 0)
                    Positioned(
                      top: EcoPlatesDesignTokens.spacing.dialogGap(context),
                      left: EcoPlatesDesignTokens.spacing.dialogGap(context),
                      child: Container(
                        padding: badgePadding,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(
                            alpha: EcoPlatesDesignTokens.opacity.textSecondary,
                          ),
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
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
                      top: EcoPlatesDesignTokens.spacing.dialogGap(context),
                      right: EcoPlatesDesignTokens.spacing.dialogGap(context),
                      child: Container(
                        padding: badgePadding,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(
                            EcoPlatesDesignTokens.radius.sm,
                          ),
                        ),
                        child: Text(
                          '-${formState.discountPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: theme.colorScheme.onError,
                            fontSize: badgeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Logo du commerçant en bas à gauche (comme dans OfferCardImage)
                  Positioned(
                    bottom: EcoPlatesDesignTokens.spacing.dialogGap(context),
                    left: EcoPlatesDesignTokens.spacing.dialogGap(context),
                    child: _buildMerchantLogo(context, theme, logoSize),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bouton de suppression
        Positioned(
          top: EcoPlatesDesignTokens.spacing.microGap(context),
          right: EcoPlatesDesignTokens.spacing.microGap(context),
          child: InkWell(
            onTap: () => _removeImage(ref, index),
            child: Container(
              padding: EdgeInsets.all(
                EcoPlatesDesignTokens.spacing.microGap(context),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.veryOpaque,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: EcoPlatesDesignTokens.opacity.pressed,
                    ),
                    blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
                    offset: EcoPlatesDesignTokens.elevation.elevatedOffset,
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                size: closeIconSize,
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ),

        // Badge "Aperçu" pour indiquer que c'est un aperçu
        Positioned(
          top: EcoPlatesDesignTokens.spacing.microGap(context),
          left: EcoPlatesDesignTokens.spacing.microGap(context),
          child: Container(
            padding: badgePadding,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
              ),
              borderRadius: BorderRadius.circular(
                EcoPlatesDesignTokens.radius.sm,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  ),
                  blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
                  offset: EcoPlatesDesignTokens.elevation.standardOffset,
                ),
              ],
            ),
            child: Text(
              'Aperçu',
              style: TextStyle(
                fontSize: badgeTextSize,
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
    ref.read<OfferFormNotifier>(offerFormProvider.notifier).updateImages([]);
  }

  Widget _buildImageWidget(BuildContext context, String imageUrl) {
    final theme = Theme.of(context);

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
          return ColoredBox(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.image_not_supported,
              color: theme.colorScheme.onSurfaceVariant,
              size: EcoPlatesDesignTokens.layout.errorStateIconSize,
            ),
          );
        }
      } on Exception {
        // En cas d'erreur, afficher un placeholder
        return ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.image_not_supported,
            color: theme.colorScheme.onSurfaceVariant,
            size: EcoPlatesDesignTokens.layout.errorIconSize,
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
    final iconSize = EcoPlatesDesignTokens.size.icon(context);

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.largeBlur,
            offset: EcoPlatesDesignTokens.elevation.elevatedOffset,
          ),
        ],
      ),
      child: ClipOval(
        child: ColoredBox(
          color: theme.colorScheme.primary.withValues(
            alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
          ),
          child: Icon(
            Icons.store,
            color: theme.colorScheme.primary,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
