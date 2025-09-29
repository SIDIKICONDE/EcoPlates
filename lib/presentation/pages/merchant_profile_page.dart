import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/merchant_enums.dart';
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
        padding: const EdgeInsets.all(16.0),
        children: [
          // En-tête du profil
          MerchantProfileHeader(
            profile: profile,
            onEditPhoto: () => _showPhotoOptions(context, ref),
            onEditProfile: () => _showEditForm(context, profile),
          ),
          SizedBox(height: 16.0),

          // Informations de contact
          MerchantContactInfo(profile: profile),
          SizedBox(height: 16.0),

          // Horaires d'ouverture
          MerchantOpeningHours(profile: profile),
          SizedBox(height: 16.0),

          // Actions supplémentaires
          _buildAdditionalActions(context, ref, profile),
          SizedBox(
            height: 16.0,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Aucun profil trouvé',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Créez votre profil pour commencer',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () => _createNewProfile(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Créer mon profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.0,
              color: colors.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colors.outline.withOpacity(0.1),
          width: 1.0,
        ),
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
                  ).colorScheme.onSurfaceVariant.withOpacity(0.3),
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

  void _showPhotoOptions(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: colors.surface,
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
        maxWidth: 1024.0,
        maxHeight: 1024.0,
        imageQuality: 85,
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
