import 'package:flutter/material.dart';

import '../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget affiché quand il n'y a aucun favori
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.favorite_border,
            size: 48.0,
            color: DeepColorTokens.neutral500,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Aucun favori pour le moment',
            style: textTheme.titleMedium?.copyWith(
              color: DeepColorTokens.neutral900,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Explorez nos restaurants et ajoutez vos plats préférés !',
            style: textTheme.bodySmall?.copyWith(
              color: DeepColorTokens.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
