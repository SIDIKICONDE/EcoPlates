import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';

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
    return Text(
      merchantName,
      style: TextStyle(
        fontSize: compact
            ? 18.0
            : 20.0, // Tailles augmentées pour plus d'impact
        color: DeepColorTokens.primary,
        fontWeight: FontWeight.w600, // Valeur fixe
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
