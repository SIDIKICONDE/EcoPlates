import 'package:flutter/material.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/merchant_profile.dart';

/// Widget pour afficher les actions supplémentaires du profil marchand
class ProfileAdditionalActions extends StatelessWidget {
  const ProfileAdditionalActions({
    required this.profile,
    required this.onEditProfile,
    super.key,
  });

  final MerchantProfile profile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _buildActionTile(
            context: context,
            icon: Icons.edit,
            title: 'Modifier le profil',
            subtitle: 'Mettre à jour vos informations',
            onTap: onEditProfile,
          ),
          const Divider(),
          _buildActionTile(
            context: context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Gérer les préférences',
            onTap: () => _showComingSoonSnackBar(
              context,
              'Paramètres de notifications à venir',
            ),
          ),
          const Divider(),
          _buildActionTile(
            context: context,
            icon: Icons.security,
            title: 'Sécurité',
            subtitle: 'Mot de passe et confidentialité',
            onTap: () => _showComingSoonSnackBar(
              context,
              'Paramètres de sécurité à venir',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: DeepColorTokens.primary,
      ),
      title: Text(
        title,
        style: TextStyle(color: colors.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: colors.onSurfaceVariant),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colors.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
