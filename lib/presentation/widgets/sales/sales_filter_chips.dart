import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive.dart';
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
                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                  Icon(
                    Icons.arrow_drop_down,
                    size: context.scaleIconStandard,
                  ),
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
                        size: context.scaleIconStandard,
                        color: theme.colorScheme.primary,
                      )
                    else
                      SizedBox(width: context.scaleIconStandard),
                    SizedBox(width: context.scaleSM_MD_LG_XL),
                    Text(
                      period.label,
                      style: TextStyle(
                        fontSize: EcoPlatesDesignTokens.typography.modalContent(
                          context,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onSelected: (period) {
              ref.read(salesFilterProvider.notifier).updatePeriod(period);
            },
          ),

          SizedBox(width: context.scaleSM_MD_LG_XL),

          // Filtre par statut
          PopupMenuButton<Object>(
            offset: const Offset(0, 40),
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filters.status?.label ?? 'Tous les statuts'),
                  SizedBox(width: context.scaleXXS_XS_SM_MD),
                  Icon(
                    Icons.arrow_drop_down,
                    size: context.scaleIconStandard,
                  ),
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
                PopupMenuItem<Object>(
                  value: _StatusMenuCmd.all,
                  child: Text(
                    'Tous les statuts',
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.modalContent(
                        context,
                      ),
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                ...SaleStatus.values.map((status) {
                  return PopupMenuItem<Object>(
                    value: status,
                    child: Row(
                      children: [
                        Container(
                          width: context.scaleXXS_XS_SM_MD,
                          height: context.scaleXXS_XS_SM_MD,
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                status.colorHex.replaceAll('#', '0xFF'),
                              ),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: context.scaleSM_MD_LG_XL),
                        Text(
                          status.label,
                          style: TextStyle(
                            fontSize: EcoPlatesDesignTokens.typography
                                .modalContent(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ];

              return items;
            },
            onSelected: (value) {
              if (value is _StatusMenuCmd && value == _StatusMenuCmd.all) {
                ref.read(salesFilterProvider.notifier).updateStatus(null);
              } else if (value is SaleStatus) {
                ref.read(salesFilterProvider.notifier).updateStatus(value);
              }
            },
          ),

          SizedBox(width: context.scaleSM_MD_LG_XL),

          // Recherche
          SizedBox(
            width: context.applyPattern([
              180.0, // mobile
              220.0, // tablet
              250.0, // desktop
              280.0, // desktop large
            ]),
            height: context.scaleButtonHeight,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: context.scaleIconStandard,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    EcoPlatesDesignTokens.radius.xxl,
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: EcoPlatesDesignTokens.typography.text(context),
              ),
              onChanged: (value) {
                ref.read(salesFilterProvider.notifier).updateSearchQuery(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
