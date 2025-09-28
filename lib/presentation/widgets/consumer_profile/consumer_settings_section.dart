import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/responsive/context_responsive_extensions.dart';

/// Section des paramètres et options du profil consommateur
class ConsumerSettingsSection extends StatelessWidget {
  const ConsumerSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(context.scaleMD_LG_XL_XXL),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.lg),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(
              alpha: EcoPlatesDesignTokens.opacity.verySubtle,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              Icon(
                Icons.settings,
                color: colors.primary,
                size: context.scaleIconStandard,
              ),
              SizedBox(width: context.scaleSM_MD_LG_XL),
              Text(
                'Paramètres & Préférences',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Liste des options
          _buildSettingsTile(
            context,
            'Notifications',
            'Gérer vos préférences de notification',
            Icons.notifications,
            onTap: () => _showNotificationSettings(context),
          ),

          Divider(height: context.scaleLG_XL_XXL_XXXL),

          _buildSettingsTile(
            context,
            'Localisation',
            'Définir votre zone de livraison préférée',
            Icons.location_on,
            onTap: () => _showLocationSettings(context),
          ),

          Divider(height: context.scaleLG_XL_XXL_XXXL),

          _buildSettingsTile(
            context,
            'Préférences alimentaires',
            'Allergies, régimes spéciaux, restrictions',
            Icons.restaurant_menu,
            onTap: () => _showDietaryPreferences(context),
          ),

          Divider(height: context.scaleLG_XL_XXL_XXXL),

          _buildSettingsTile(
            context,
            'Paiement',
            'Gérer vos moyens de paiement',
            Icons.payment,
            onTap: () => _showPaymentSettings(context),
          ),

          Divider(height: context.scaleLG_XL_XXL_XXXL),

          _buildSettingsTile(
            context,
            'Confidentialité',
            'Contrôler vos données personnelles',
            Icons.privacy_tip,
            onTap: () => _showPrivacySettings(context),
          ),

          Divider(height: context.scaleLG_XL_XXL_XXXL),

          _buildSettingsTile(
            context,
            'Aide & Support',
            'FAQ, contact, signaler un problème',
            Icons.help,
            onTap: () => _showHelpSupport(context),
          ),

          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Actions supplémentaires
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportData(context),
                  icon: const Icon(Icons.download),
                  label: const Text('Exporter mes données'),
                ),
              ),
              SizedBox(width: context.scaleMD_LG_XL_XXL),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteAccount(context),
                  icon: Icon(Icons.delete_forever, color: colors.error),
                  label: Text(
                    'Supprimer le compte',
                    style: TextStyle(color: colors.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.scaleXS_SM_MD_LG,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.scaleSM_MD_LG_XL),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.sm,
                ),
              ),
              child: Icon(
                icon,
                color: colors.primary,
                size: context.scaleIconStandard,
              ),
            ),

            SizedBox(width: context.scaleMD_LG_XL_XXL),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: context.scaleXXS_XS_SM_MD),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: colors.onSurface.withValues(
                alpha: EcoPlatesDesignTokens.opacity.disabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(EcoPlatesDesignTokens.radius.xl),
          ),
        ),
        builder: _buildNotificationBottomSheet,
      ),
    );
  }

  Widget _buildNotificationBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(context.scaleLG_XL_XXL_XXXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicateur
          Container(
            width: context.scaleLG_XL_XXL_XXXL,
            height: DesignConstants.four,
            margin: EdgeInsets.only(
              bottom: context.scaleLG_XL_XXL_XXXL,
            ),
            decoration: BoxDecoration(
              color: colors.outline.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              borderRadius: BorderRadius.circular(DesignConstants.two),
            ),
          ),

          Text(
            'Notifications',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: context.scaleLG_XL_XXL_XXXL),

          // Options de notification
          _buildNotificationSwitch('Nouvelles offres près de vous', true),
          _buildNotificationSwitch('Confirmations de commande', true),
          _buildNotificationSwitch('Rappels de récupération', true),
          _buildNotificationSwitch('Récompenses et niveaux', false),
          _buildNotificationSwitch('Conseils écologiques', false),

          SizedBox(height: context.scaleLG_XL_XXL_XXXL),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // TODO: Implémenter la sauvegarde des préférences
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showLocationSettings(BuildContext context) {
    _showComingSoon(context, 'Paramètres de localisation');
  }

  void _showDietaryPreferences(BuildContext context) {
    _showComingSoon(context, 'Préférences alimentaires');
  }

  void _showPaymentSettings(BuildContext context) {
    _showComingSoon(context, 'Paramètres de paiement');
  }

  void _showPrivacySettings(BuildContext context) {
    _showComingSoon(context, 'Paramètres de confidentialité');
  }

  void _showHelpSupport(BuildContext context) {
    _showComingSoon(context, 'Aide & Support');
  }

  void _exportData(BuildContext context) {
    unawaited(
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exporter mes données'),
          content: const Text(
            'Voulez-vous recevoir un export de toutes vos données par email ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Export des données demandé. Vous recevrez un email sous 24h.',
                    ),
                  ),
                );
              },
              child: const Text('Confirmer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    unawaited(
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Supprimer le compte'),
          content: const Text(
            'Cette action est irréversible. Toutes vos données seront définitivement supprimées.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implémenter la suppression de compte
                _showComingSoon(context, 'Suppression de compte');
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Fonctionnalité à venir'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
