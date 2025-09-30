import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive.dart';
import '../../data/services/merchant_profile_service.dart';
import '../../domain/entities/merchant_profile.dart';
import '../widgets/profilemerchant/components/empty_profile_view.dart';
import '../widgets/profilemerchant/components/error_profile_view.dart';
import '../widgets/profilemerchant/components/profile_additional_actions.dart';
import '../widgets/profilemerchant/merchant_contact_info.dart';
import '../widgets/profilemerchant/merchant_opening_hours.dart';
import '../widgets/profilemerchant/merchant_profile_header.dart';
import '../widgets/profilemerchant/mixins/profile_dialog_mixin.dart';

/// Page de profil du marchand
///
/// Affiche et permet de modifier les informations du profil marchand :
/// - Informations personnelles
/// - Informations de la boutique
/// - Préférences de notification
/// - Paramètres de sécurité
class MerchantProfilePage extends ConsumerStatefulWidget {
  const MerchantProfilePage({super.key});

  @override
  ConsumerState<MerchantProfilePage> createState() =>
      _MerchantProfilePageState();
}

class _MerchantProfilePageState extends ConsumerState<MerchantProfilePage>
    with ProfileDialogMixin<MerchantProfilePage> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () =>
                ref.read(merchantProfileProvider.notifier).refresh(),
          ),
        ],
      ),
      body: profileAsyncValue.when<Widget>(
        data: (MerchantProfile? profile) => profile != null
            ? _buildProfileContent(profile)
            : EmptyProfileView(onCreateProfile: _createNewProfile),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stack) =>
            ErrorProfileView(error: error, onRetry: _retryLoading),
      ),
    );
  }

  Widget _buildProfileContent(MerchantProfile profile) {
    return RefreshIndicator(
      onRefresh: () => ref.read(merchantProfileProvider.notifier).refresh(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final isDesktop = screenWidth > 1024; // Desktop
          final isTablet = screenWidth > 768 && screenWidth <= 1024; // Tablette

          if (isDesktop) {
            // Disposition professionnelle pour desktop : grille 3 colonnes
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header full width
                  MerchantProfileHeader(
                    profile: profile,
                    onEditPhoto: showPhotoOptions,
                    onEditProfile: () => showEditForm(profile),
                  ),
                  const SizedBox(height: 24.0),

                  // Grille principale : Contact | Horaires | Actions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Colonne 1 : Informations de contact (3/8)
                      Expanded(
                        flex: 3,
                        child: MerchantContactInfo(profile: profile),
                      ),
                      const SizedBox(width: 16.0),

                      // Colonne 2 : Horaires d'ouverture (3/8)
                      Expanded(
                        flex: 3,
                        child: MerchantOpeningHours(profile: profile),
                      ),
                      const SizedBox(width: 16.0),

                      // Colonne 3 : Actions supplémentaires (2/8)
                      Expanded(
                        flex: 2,
                        child: ProfileAdditionalActions(
                          profile: profile,
                          onEditProfile: () => showEditForm(profile),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (isTablet) {
            // Disposition tablette : 2 colonnes avec actions en bas
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header
                  MerchantProfileHeader(
                    profile: profile,
                    onEditPhoto: showPhotoOptions,
                    onEditProfile: () => showEditForm(profile),
                  ),
                  const SizedBox(height: 24.0),

                  // Deux colonnes : Contact et Horaires
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MerchantContactInfo(profile: profile),
                      ),
                      const SizedBox(width: 20.0),
                      Expanded(
                        child: MerchantOpeningHours(profile: profile),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Actions en bas
                  ProfileAdditionalActions(
                    profile: profile,
                    onEditProfile: () => showEditForm(profile),
                  ),
                ],
              ),
            );
          } else {
            // Disposition mobile : verticale
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Header
                MerchantProfileHeader(
                  profile: profile,
                  onEditPhoto: showPhotoOptions,
                  onEditProfile: () => showEditForm(profile),
                ),
                const VerticalGap(),

                // Contact
                MerchantContactInfo(profile: profile),
                const VerticalGap(),

                // Horaires
                MerchantOpeningHours(profile: profile),
                const VerticalGap(),

                // Actions
                ProfileAdditionalActions(
                  profile: profile,
                  onEditProfile: () => showEditForm(profile),
                ),
                const VerticalGap(),
              ],
            );
          }
        },
      ),
    );
  }

  void _createNewProfile() {
    final newProfile = createNewProfile();
    showEditForm(newProfile);
  }

  Future<void> _retryLoading() async {
    await ref.read(merchantProfileProvider.notifier).refresh();
  }
}
