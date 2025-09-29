import 'package:flutter/material.dart';

/// Widget affiché quand il n'y a aucun favori
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 48.0,
            color: colors.onSurface.withValues(
              alpha: 0.3,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Aucun favori pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface.withValues(
                alpha: 0.9,
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Explorez nos restaurants et ajoutez vos plats préférés !',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(
                alpha: 0.5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
