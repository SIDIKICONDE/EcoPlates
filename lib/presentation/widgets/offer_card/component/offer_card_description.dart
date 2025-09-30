import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget spécialisé pour afficher la description de l'offre
/// Gère le tronquage intelligent selon le mode compact
class OfferCardDescription extends StatelessWidget {
  const OfferCardDescription({
    required this.description,
    this.compact = false,
    super.key,
  });

  final String description;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final truncatedDescription = compact
        ? (description.length > 35
              ? '${description.substring(0, 35)}...'
              : description)
        : (description.length > 20
              ? '${description.substring(0, 20)}...'
              : description);

    return Text(
      truncatedDescription,
      style: TextStyle(
        fontSize: compact
            ? 12.0
            : 14.0, // Tailles augmentées pour meilleure lisibilité
        color: DeepColorTokens.neutral800.withValues(alpha: 0.8),
      ),
      maxLines: compact ? 1 : 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
