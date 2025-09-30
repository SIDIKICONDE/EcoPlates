import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/sale.dart';

/// Footer de la carte de vente avec le prix total et les économies
class SaleFooter extends StatelessWidget {
  const SaleFooter({required this.sale, super.key});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Total: ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: DeepColorTokens.neutral600,
              ),
            ),
            Text(
              '${sale.finalAmount.toStringAsFixed(2)}€',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: DeepColorTokens.primary,
              ),
            ),
          ],
        ),
        if (sale.discountAmount > 0)
          Text(
            'Économie: ${sale.discountAmount.toStringAsFixed(2)}€ (${sale.savingsPercentage.toStringAsFixed(0)}%)',
            style: const TextStyle(
              fontSize: 12.0,
              color: DeepColorTokens.success,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
