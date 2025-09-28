import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/responsive/design_tokens.dart';

/// Dialogue d'aide pour expliquer les options vidéo
class VideoHelpDialog extends StatelessWidget {
  const VideoHelpDialog({super.key});

  static void show(BuildContext context) {
    unawaited(
      showDialog<Widget>(
        context: context,
        builder: (context) => const VideoHelpDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.help_outline, color: theme.colorScheme.primary),
          SizedBox(width: context.scaleXS_SM_MD_LG),
          const Text('Options de lecture vidéo'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOption(
              context,
              icon: Icons.close_fullscreen_rounded,
              title: 'Mode Mini',
              description:
                  "Réduit la vidéo en petit format pour continuer à naviguer dans l'app.",
              available: true,
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
            _buildOption(
              context,
              icon: Icons.picture_in_picture_alt_rounded,
              title: 'Picture-in-Picture système',
              description:
                  'Non disponible avec le lecteur Flutter. Utilisez le mode mini à la place.',
              available: false,
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL),
            _buildOption(
              context,
              icon: Icons.notifications_active_rounded,
              title: 'Contrôles de notification',
              description:
                  'Contrôlez la lecture depuis la barre de notification (bientôt disponible).',
              available: false,
            ),
            SizedBox(height: context.scaleMD_LG_XL_XXL * 1.5),
            Container(
              padding: EdgeInsets.all(context.scaleXS_SM_MD_LG),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.subtle,
                ),
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.sm,
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.subtle,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: theme.colorScheme.primary,
                    size: EcoPlatesDesignTokens.size.icon(context),
                  ),
                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                  Expanded(
                    child: Text(
                      'Astuce : Utilisez le mode mini pour garder la vidéo visible tout en naviguant !',
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.hint(
                          context,
                        ),
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('COMPRIS'),
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required bool available,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
          decoration: BoxDecoration(
            color: available
                ? Colors.green.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  )
                : Colors.grey.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.veryTransparent,
                  ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: available ? Colors.green : Colors.grey,
            size: EcoPlatesDesignTokens.size.icon(context) * 1.2,
          ),
        ),
        SizedBox(width: context.scaleXS_SM_MD_LG),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                    ),
                  ),
                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                  if (available)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scaleXXS_XS_SM_MD,
                        vertical: context.scaleXXS_XS_SM_MD / 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          EcoPlatesDesignTokens.radius.sm,
                        ),
                      ),
                      child: Text(
                        'Disponible',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              EcoPlatesDesignTokens.typography.hint(context) -
                              2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: context.scaleXXS_XS_SM_MD / 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: EcoPlatesDesignTokens.typography.text(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
