import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

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
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: DeepColorTokens.primary),
          SizedBox(width: 12.0),
          Text('Options de lecture vidéo'),
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
            SizedBox(height: 16.0),
            _buildOption(
              context,
              icon: Icons.picture_in_picture_alt_rounded,
              title: 'Picture-in-Picture système',
              description:
                  'Non disponible avec le lecteur Flutter. Utilisez le mode mini à la place.',
              available: false,
            ),
            SizedBox(height: 16.0),
            _buildOption(
              context,
              icon: Icons.notifications_active_rounded,
              title: 'Contrôles de notification',
              description:
                  'Contrôlez la lecture depuis la barre de notification (bientôt disponible).',
              available: false,
            ),
            SizedBox(height: 24.0),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: DeepColorTokens.primaryContainer.withValues(
                  alpha: 0.15,
                ),
                border: Border.all(
                  color: DeepColorTokens.primary.withValues(
                    alpha: 0.2,
                  ),
                ),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Astuce : Utilisez le mode mini pour garder la vidéo visible tout en naviguant !',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: DeepColorTokens.neutral0,
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
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: available
                ? DeepColorTokens.success.withValues(alpha: 0.2)
                : DeepColorTokens.neutral600.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: available
                ? DeepColorTokens.success
                : DeepColorTokens.neutral600,
            size: 16.0 * 1.2,
          ),
        ),
        SizedBox(width: 12.0),
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
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  if (available)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: DeepColorTokens.success,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.0),
              Text(
                description,
                style: TextStyle(
                  color: DeepColorTokens.neutral600,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
