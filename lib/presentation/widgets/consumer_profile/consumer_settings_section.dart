import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Section des paramètres et options du profil consommateur
class ConsumerSettingsSection extends StatelessWidget {
  const ConsumerSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DeepColorTokens.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: DeepColorTokens.shadowLight,
            blurRadius: 8.0,
            offset: Offset(0, 1),
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
                color: DeepColorTokens.primary,
                size: 24.0,
              ),
              SizedBox(width: 12.0),
              Text(
                'Paramètres & Préférences',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 24.0),

          // Liste des options
          _buildSettingsTile(
            context,
            'Notifications',
            'Gérer vos préférences de notification',
            Icons.notifications,
            onTap: () => _showNotificationSettings(context),
          ),

          Divider(height: 24.0),

          _buildSettingsTile(
            context,
            'Localisation',
            'Définir votre zone de livraison préférée',
            Icons.location_on,
            onTap: () => _showLocationSettings(context),
          ),

          Divider(height: 24.0),

          _buildSettingsTile(
            context,
            'Préférences alimentaires',
            'Allergies, régimes spéciaux, restrictions',
            Icons.restaurant_menu,
            onTap: () => _showDietaryPreferences(context),
          ),

          Divider(height: 24.0),

          _buildSettingsTile(
            context,
            'Paiement',
            'Gérer vos moyens de paiement',
            Icons.payment,
            onTap: () => _showPaymentSettings(context),
          ),

          Divider(height: 24.0),

          _buildSettingsTile(
            context,
            'Confidentialité',
            'Contrôler vos données personnelles',
            Icons.privacy_tip,
            onTap: () => _showPrivacySettings(context),
          ),

          Divider(height: 24.0),

          _buildSettingsTile(
            context,
            'Aide & Support',
            'FAQ, contact, signaler un problème',
            Icons.help,
            onTap: () => _showHelpSupport(context),
          ),

          SizedBox(height: 24.0),

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
              SizedBox(width: 16.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteAccount(context),
                  icon: Icon(
                    Icons.delete_forever,
                    color: DeepColorTokens.error,
                  ),
                  label: Text(
                    'Supprimer le compte',
                    style: TextStyle(color: DeepColorTokens.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: DeepColorTokens.error),
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
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.primary.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
              child: Icon(
                icon,
                color: DeepColorTokens.primary,
                size: 24.0,
              ),
            ),

            SizedBox(width: 16.0),

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
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: DeepColorTokens.neutral900.withValues(
                        alpha: 0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: DeepColorTokens.neutral600.withValues(
                alpha: 0.5,
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
            top: Radius.circular(20.0),
          ),
        ),
        builder: _buildNotificationBottomSheet,
      ),
    );
  }

  Widget _buildNotificationBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicateur
          Container(
            width: 24.0,
            height: 4.0,
            margin: EdgeInsets.only(
              bottom: 24.0,
            ),
            decoration: BoxDecoration(
              color: DeepColorTokens.neutral400.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          Text(
            'Notifications',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 24.0),

          // Options de notification
          _buildNotificationSwitch('Nouvelles offres près de vous', true),
          _buildNotificationSwitch('Confirmations de commande', true),
          _buildNotificationSwitch('Rappels de récupération', true),
          _buildNotificationSwitch('Récompenses et niveaux', false),
          _buildNotificationSwitch('Conseils écologiques', false),

          SizedBox(height: 24.0),
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
                backgroundColor: DeepColorTokens.error,
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
