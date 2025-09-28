import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/design_tokens.dart';
import '../providers/consumer_profile_provider.dart';
import '../widgets/consumer_profile/consumer_activity_section.dart';
import '../widgets/consumer_profile/consumer_eco_stats.dart';
import '../widgets/consumer_profile/consumer_favorites_section.dart';
import '../widgets/consumer_profile/consumer_profile_header.dart';
import '../widgets/consumer_profile/consumer_settings_section.dart';

/// Page de profil du consommateur
///
/// Affiche et permet de gérer :
/// - Informations personnelles et photo de profil
/// - Statistiques écologiques (EcoScore, CO2 économisé, etc.)
/// - Historique d'activité et commandes
/// - Lieux favoris
/// - Paramètres de compte et notifications
/// - Niveaux de fidélité et récompenses
class ConsumerProfilePage extends ConsumerWidget {
  const ConsumerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsyncValue = ref.watch(consumerProfileProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: colors.primary),
            onPressed: () => _showSettings(context, ref),
          ),
        ],
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: profileAsyncValue.when(
        data: (user) => Padding(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.spacing.dialogGap(context),
          ),
          child: ListView(
            children: [
              // En-tête du profil avec photo et infos utilisateur
              ConsumerProfileHeader(
                user: user,
                onEditProfile: () => _editProfile(context, ref),
                onEditPhoto: () => _editPhoto(context, ref),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),

              // Statistiques écologiques
              const ConsumerEcoStats(),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),

              // Section activité récente
              const ConsumerActivitySection(),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),

              // Section lieux favoris
              const ConsumerFavoritesSection(),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.interfaceGap(context),
              ),

              // Section paramètres
              const ConsumerSettingsSection(),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: EcoPlatesDesignTokens.errorIconSize,
                color: colors.error,
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: EcoPlatesDesignTokens.spacing.microGap(context)),
              Text(
                'Impossible de charger votre profil',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.textSecondary,
                  ),
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.dialogGap(context),
              ),
              FilledButton.icon(
                onPressed: () =>
                    ref.read(consumerProfileProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings(BuildContext context, WidgetRef ref) {
    // TODO: Implémenter la navigation vers les paramètres détaillés
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Paramètres à venir'),
        duration: EcoPlatesDesignTokens.animation.normal,
      ),
    );
  }

  void _editProfile(BuildContext context, WidgetRef ref) {
    // TODO: Implémenter l'édition du profil
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: EcoPlatesDesignTokens.layout.modalHeightFactor(
          context,
        ),
        minChildSize:
            EcoPlatesDesignTokens.layout.modalHeightFactor(context) *
            EcoPlatesDesignTokens.layout.modalMinHeightFactor,
        maxChildSize:
            EcoPlatesDesignTokens.layout.modalHeightFactor(context) *
            EcoPlatesDesignTokens.layout.modalMaxHeightFactor,
        builder: (context, scrollController) => Padding(
          padding: EdgeInsets.all(
            EcoPlatesDesignTokens.spacing.sectionSpacing(context),
          ),
          child: Column(
            children: [
              // Indicateur de glissement
              Container(
                width: EcoPlatesDesignTokens.layout.modalHandleWidth,
                height: EcoPlatesDesignTokens.layout.modalHandleHeight,
                margin: EdgeInsets.only(
                  bottom: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xs,
                  ),
                ),
              ),
              Text(
                'Modifier le profil',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.modalTitle(
                    context,
                  ),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                ),
              ),
              SizedBox(
                height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
              ),
              // TODO: Formulaire d'édition
              const Expanded(
                child: Center(
                  child: Text("Formulaire d'édition à implémenter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editPhoto(BuildContext context, WidgetRef ref) {
    // TODO: Implémenter la sélection/édition de photo de profil
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            Text(
              'Photo de profil',
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.modalSubtitle(
                  context,
                ),
                fontWeight: EcoPlatesDesignTokens.typography.bold,
              ),
            ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Ouvrir la caméra
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Ouvrir la galerie
              },
            ),
            if (true) // TODO: Vérifier si l'utilisateur a déjà une photo
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
                  Navigator.pop(context);
                  // TODO: Supprimer la photo actuelle
                },
              ),
            SizedBox(
              height: EcoPlatesDesignTokens.spacing.sectionSpacing(context),
            ),
          ],
        ),
      ),
    );
  }
}
