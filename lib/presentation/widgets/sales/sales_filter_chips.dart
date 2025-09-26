import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/sale.dart';
import '../../providers/sales_provider.dart';

/// Valeurs du menu statut
enum _StatusMenuCmd { all }

/// Chips de filtrage pour les ventes
class SalesFilterChips extends ConsumerWidget {
  const SalesFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(salesFilterProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Filtre par période
          PopupMenuButton<SalesPeriodFilter>(
            offset: const Offset(0, 40),
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filters.period.label),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
              backgroundColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
            itemBuilder: (context) => SalesPeriodFilter.values.map((period) {
              return PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    if (filters.period == period)
                      Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.primary,
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(period.label),
                  ],
                ),
              );
            }).toList(),
            onSelected: (period) {
              ref.read(salesFilterProvider.notifier).state = filters.copyWith(
                period: period,
              );
            },
          ),

          const SizedBox(width: 8),

          // Filtre par statut
          PopupMenuButton<Object>(
            offset: const Offset(0, 40),
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filters.status?.label ?? 'Tous les statuts'),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
              backgroundColor: filters.status != null
                  ? Color(
                      int.parse(
                        filters.status!.colorHex.replaceAll('#', '0xFF'),
                      ),
                    ).withValues(alpha: 0.2)
                  : theme.colorScheme.surfaceContainerHighest,
              labelStyle: TextStyle(
                color: filters.status != null
                    ? Color(
                        int.parse(
                          filters.status!.colorHex.replaceAll('#', '0xFF'),
                        ),
                      )
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            itemBuilder: (context) {
              final items = <PopupMenuEntry<Object>>[
                const PopupMenuItem<Object>(
                  value: _StatusMenuCmd.all,
                  child: Text('Tous les statuts'),
                ),
                const PopupMenuDivider(),
                ...SaleStatus.values.map((status) {
                  return PopupMenuItem<Object>(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                status.colorHex.replaceAll('#', '0xFF'),
                              ),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(status.label),
                      ],
                    ),
                  );
                }),
              ];

              return items;
            },
            onSelected: (value) {
              if (value is _StatusMenuCmd && value == _StatusMenuCmd.all) {
                ref.read(salesFilterProvider.notifier).state = filters.copyWith(
                  status: null,
                );
              } else if (value is SaleStatus) {
                ref.read(salesFilterProvider.notifier).state = filters.copyWith(
                  status: value,
                );
              }
            },
          ),

          const SizedBox(width: 8),

          // Recherche
          SizedBox(
            width: 200,
            height: 32,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (value) {
                ref.read(salesFilterProvider.notifier).state = filters.copyWith(
                  searchQuery: value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
