import 'package:flutter/material.dart';

/// Widget spécialisé pour afficher le nom du commerçant
/// Gère les versions normale et compacte avec responsivité
/// Le logo est maintenant affiché sur l'image dans OfferCardImage
class OfferCardMerchantName extends StatelessWidget {
  const OfferCardMerchantName({
    required this.merchantName,
    this.compact = false,
    super.key,
  });

  final String merchantName;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      merchantName,
      style: TextStyle(
        fontSize: compact
            ? 18.0
            : 20.0, // Tailles augmentées pour plus d'impact
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600, // Valeur fixe
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
