import 'package:flutter/material.dart';

import '../../../../core/themes/tokens/deep_color_tokens.dart';
import '../../../../domain/entities/sale.dart';

/// En-tête personnalisé de la carte de vente avec informations complètes
class SaleHeader extends StatelessWidget {
  const SaleHeader({required this.sale, super.key});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = Color(
      int.parse(sale.status.colorHex.replaceAll('#', '0xFF')),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Première ligne : ID commande + Statut
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ID Commande avec icône
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 16.0,
                  color: DeepColorTokens.primary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '#${sale.id}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: DeepColorTokens.primary,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            // Statut avec design amélioré
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.0,
                    height: 6.0,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 3.0),
                  Text(
                    sale.status.label,
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 6.0),

        // Deuxième ligne : Client + heure
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nom du client avec icône
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14.0,
                    color: DeepColorTokens.neutral700,
                  ),
                  const SizedBox(width: 3.0),
                  Expanded(
                    child: Text(
                      sale.customerName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: DeepColorTokens.neutral900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Heure avec design compact
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: DeepColorTokens.neutral100,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12.0,
                    color: DeepColorTokens.neutral600,
                  ),
                  const SizedBox(width: 2.0),
                  Text(
                    _formatTime(sale.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DeepColorTokens.neutral600,
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Ligne d'informations supplémentaires si nécessaire
        if (sale.items.length > 1) ...[
          const SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.inventory_2,
                size: 12.0,
                color: DeepColorTokens.neutral500,
              ),
              const SizedBox(width: 2.0),
              Text(
                '${sale.items.length} articles',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DeepColorTokens.neutral500,
                  fontSize: 10.0,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
