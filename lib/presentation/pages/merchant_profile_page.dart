import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/merchant_enums.dart';
import '../../core/responsive/design_tokens.dart';
import '../../data/services/merchant_profile_service.dart';
import '../../domain/entities/merchant_profile.dart';
import '../widgets/profilemerchant/merchant_contact_info.dart';
import '../widgets/profilemerchant/merchant_opening_hours.dart';
import '../widgets/profilemerchant/merchant_profile_form.dart';
import '../widgets/profilemerchant/merchant_profile_header.dart';

/// Page de profil du marchand
///
/// Affiche et permet de modifier les informations du profil marchand :
/// - Informations personnelles
/// - Informations de la boutique
/// - Préférences de notification
/// - Paramètres de sécurité
class MerchantProfilePage extends ConsumerWidget {
  const MerchantProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(merchantProfileProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: colors.surface,
        elevation: 0,
        actions: [
          // Bouton de rafraîchissement
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              unawaited(ref.read(merchantProfileProvider.notifier).refresh());
            },
          ),
        ],
      ),
      body: profileAsyncValue.when<Widget>(
        data: (MerchantProfile? profile) => profile != null
            ? _buildProfileContent(context, ref, profile)
            : _buildEmptyProfile(context, ref),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) =>
            _buildErrorView(context, ref, error),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    MerchantProfile profile,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(merchantProfileProvider.notifier).refresh();
      },
      child: ListView(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.dialogGap(context),
        ),
        children: [
          // En-tête du profil
          MerchantProfileHeader(
            profile: profile,
            onEditPhoto: () => _showPhotoOptions(context, ref),
            onEditProfile: () => _showEditForm(context, profile),
          ),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),

          // Informations de contact
          MerchantContactInfo(profile: profile),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),

          // Horaires d'ouverture
          MerchantOpeningHours(profile: profile),
          SizedBox(height: EcoPlatesDesignTokens.spacing.interfaceGap(context)),

          // Actions supplémentaires
          _buildAdditionalActions(context, ref, profile),
          SizedBox(
            height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyProfile(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.sectionSpacing(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: EcoPlatesDesignTokens.layout.emptyStateIconSize,
              color: colors.onSurfaceVariant.withValues(
                alpha: EcoPlatesDesignTokens.opacity.emptyStateIconOpacity,
              ),
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            Text(
              'Aucun profil trouvé',
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            Text(
              'Créez votre profil pour commencer',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            ElevatedButton.icon(
              onPressed: () => _createNewProfile(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Créer mon profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: EcoPlatesDesignTokens.spacing.sectionSpacing(
                    context,
                  ),
                  vertical: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    WidgetRef ref,
    Object error,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          EcoPlatesDesignTokens.spacing.sectionSpacing(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: EcoPlatesDesignTokens.layout.errorViewIconSize,
              color: colors.error,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
            ),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            ElevatedButton.icon(
              onPressed: () {
                unawaited(ref.read(merchantProfileProvider.notifier).refresh());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalActions(
    BuildContext context,
    WidgetRef ref,
    MerchantProfile profile,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(EcoPlatesDesignTokens.spacing.dialogGap(context)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(
          EcoPlatesDesignTokens.radius.lg,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: EcoPlatesDesignTokens.layout.actionCardShadowOpacity,
            ),
            blurRadius: EcoPlatesDesignTokens.layout.actionCardShadowBlurRadius,
            offset: EcoPlatesDesignTokens.layout.actionCardShadowOffset,
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
              color: colors.primary,
            ),
            title: Text(
              'Modifier le profil',
              style: TextStyle(color: colors.onSurface),
            ),
            subtitle: Text(
              'Mettre à jour vos informations',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colors.onSurfaceVariant,
            ),
            onTap: () => _showEditForm(context, profile),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: colors.primary,
            ),
            title: Text(
              'Notifications',
              style: TextStyle(color: colors.onSurface),
            ),
            subtitle: Text(
              'Gérer les préférences',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colors.onSurfaceVariant,
            ),
            onTap: () {
              // TODO: Naviguer vers les paramètres de notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paramètres de notifications à venir'),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.security,
              color: colors.primary,
            ),
            title: Text(
              'Sécurité',
              style: TextStyle(color: colors.onSurface),
            ),
            subtitle: Text(
              'Mot de passe et confidentialité',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: colors.onSurfaceVariant,
            ),
            onTap: () {
              // TODO: Naviguer vers les paramètres de sécurité
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paramètres de sécurité à venir'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showEditForm(BuildContext context, MerchantProfile profile) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize:
            EcoPlatesDesignTokens.layout.profileEditModalInitialSize,
        minChildSize: EcoPlatesDesignTokens.layout.profileEditModalMinSize,
        maxChildSize: EcoPlatesDesignTokens.layout.profileEditModalMaxSize,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                EcoPlatesDesignTokens.radius.xl,
              ),
            ),
          ),
          child: Column(
            children: [
              // Poignée
              Container(
                margin: EdgeInsets.only(
                  top: EcoPlatesDesignTokens.spacing.interfaceGap(context),
                ),
                width: EcoPlatesDesignTokens.layout.modalHandleWidth,
                height: EcoPlatesDesignTokens.layout.modalHandleHeight,
                decoration: BoxDecoration(
                  color:
                      Theme.of(
                        context,
                      ).colorScheme.outline.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                      ),
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
              ),
              // Titre
              Padding(
                padding: EdgeInsets.all(
                  EcoPlatesDesignTokens.spacing.dialogGap(context),
                ),
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
              Divider(height: EcoPlatesDesignTokens.dividerHeight),
              // Formulaire
              Expanded(
                child: MerchantProfileForm(
                  profile: profile,
                  onSaved: () {
                    // Le formulaire gère déjà la fermeture
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EcoPlatesDesignTokens.radius.xl),
          ),
        ),
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: colors.primary,
                ),
                title: Text(
                  'Prendre une photo',
                  style: TextStyle(color: colors.onSurface),
                ),
                onTap: () {
                  context.pop();
                  unawaited(_pickImage(context, ref, ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: colors.primary,
                ),
                title: Text(
                  'Choisir depuis la galerie',
                  style: TextStyle(color: colors.onSurface),
                ),
                onTap: () {
                  context.pop();
                  unawaited(_pickImage(context, ref, ImageSource.gallery));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: colors.error),
                title: Text(
                  'Supprimer la photo',
                  style: TextStyle(color: colors.error),
                ),
                onTap: () async {
                  context.pop();
                  try {
                    await ref
                        .read(merchantProfileProvider.notifier)
                        .deleteLogo();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo supprimée'),
                        ),
                      );
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur: $e'),
                          backgroundColor: colors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: source,
        maxWidth: EcoPlatesDesignTokens.layout.imageMaxWidth,
        maxHeight: EcoPlatesDesignTokens.layout.imageMaxHeight,
        imageQuality: EcoPlatesDesignTokens.layout.imageQuality,
      );

      if (image != null) {
        await ref.read(merchantProfileProvider.notifier).uploadLogo(image.path);
        if (context.mounted) {
          final theme = Theme.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Photo mise à jour',
                style: TextStyle(color: theme.colorScheme.onPrimary),
              ),
              backgroundColor: theme.colorScheme.primary,
            ),
          );
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur: $e',
              style: TextStyle(color: theme.colorScheme.onError),
            ),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
  }

  void _createNewProfile(BuildContext context, WidgetRef ref) {
    // Créer un profil vide avec des valeurs par défaut
    final newProfile = MerchantProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      category: MerchantCategory.other,
      createdAt: DateTime.now(),
    );

    _showEditForm(context, newProfile);
  }
}
