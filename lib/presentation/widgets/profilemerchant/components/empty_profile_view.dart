import 'package:flutter/material.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher l'état vide du profil marchand
class EmptyProfileView extends StatelessWidget {
  const EmptyProfileView({
    required this.onCreateProfile,
    super.key,
  });

  final VoidCallback onCreateProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
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
              onPressed: onCreateProfile,
              icon: const Icon(Icons.add),
              label: const Text('Créer mon profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: DeepColorTokens.primary,
                foregroundColor: DeepColorTokens.neutral0,
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
}
