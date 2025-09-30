import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/themes/tokens/deep_color_tokens.dart';
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
            icon: Icon(Icons.settings, color: DeepColorTokens.primary),
            onPressed: () => _showSettings(context, ref),
          ),
        ],
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: profileAsyncValue.when(
        data: (user) => Padding(
          padding: EdgeInsets.all(
            16,
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
                height: 16,
              ),

              // Statistiques écologiques
              const ConsumerEcoStats(),
              SizedBox(
                height: 16,
              ),

              // Section activité récente
              const ConsumerActivitySection(),
              SizedBox(
                height: 16,
              ),

              // Section lieux favoris
              const ConsumerFavoritesSection(),
              SizedBox(
                height: 16,
              ),

              // Section paramètres
              const ConsumerSettingsSection(),
              SizedBox(
                height: 16,
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
                size: 16,
              ),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              Text(
                'Impossible de charger votre profil',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
                ),
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
        duration: Duration(seconds: 2),
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
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Indicateur de glissement
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16),
              // TODO: Formulaire d'édition
              Expanded(
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
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(
              'Photo de profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
