import 'package:flutter/material.dart';

import '../../../../core/constants/categories.dart';
import '../../../../domain/entities/sale.dart';

/// Liste des articles d'une vente
class SaleItemsList extends StatelessWidget {
  const SaleItemsList({required this.items, super.key});

  final List<SaleItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                children: [
                  Icon(
                    Categories.iconOf(item.category),
                    size: 16.0,
                    color: Categories.colorOf(item.category),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.offerTitle}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${item.totalPrice.toStringAsFixed(2)}€',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
