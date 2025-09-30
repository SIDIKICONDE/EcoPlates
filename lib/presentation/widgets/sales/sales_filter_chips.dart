import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/responsive_utils.dart';
import '../../../core/themes/tokens/deep_color_tokens.dart';
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
                  SizedBox(width: context.horizontalSpacing / 3),
                  Icon(
                    Icons.arrow_drop_down,
                    size: ResponsiveUtils.getIconSize(context, baseSize: 20),
                  ),
                ],
              ),
              backgroundColor: DeepColorTokens.primaryContainer.withValues(
                alpha: 0.3,
              ),
              labelStyle: TextStyle(
                color: DeepColorTokens.primaryDark,
                fontWeight: FontWeight.w500,
              ),
              surfaceTintColor: Colors.transparent,
              side: BorderSide.none,
            ),
            itemBuilder: (context) => SalesPeriodFilter.values.map((period) {
              return PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    if (filters.period == period)
                      Icon(
                        Icons.check,
                        size: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 20,
                        ),
                        color: DeepColorTokens.primary,
                      )
                    else
                      SizedBox(
                        width: ResponsiveUtils.getIconSize(
                          context,
                          baseSize: 20,
                        ),
                      ),
                    SizedBox(width: context.horizontalSpacing / 2),
                    Text(
                      period.label,
                      style: TextStyle(
                        fontSize: FontSizes.bodyMedium.getSize(context),
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

          SizedBox(width: context.horizontalSpacing / 2),

          // Filtre par statut
          PopupMenuButton<Object>(
            offset: const Offset(0, 40),
            child: Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filters.status?.label ?? 'Tous les statuts'),
                  SizedBox(width: context.horizontalSpacing / 3),
                  Icon(
                    Icons.arrow_drop_down,
                    size: ResponsiveUtils.getIconSize(context, baseSize: 20),
                  ),
                ],
              ),
              backgroundColor: filters.status != null
                  ? Color(
                      int.parse(
                        filters.status!.colorHex.replaceAll('#', '0xFF'),
                      ),
                    ).withValues(alpha: 0.2)
                  : DeepColorTokens.neutral100,
              labelStyle: TextStyle(
                color: filters.status != null
                    ? Color(
                        int.parse(
                          filters.status!.colorHex.replaceAll('#', '0xFF'),
                        ),
                      )
                    : DeepColorTokens.neutral700,
                fontWeight: FontWeight.w500,
              ),
              surfaceTintColor: Colors.transparent,
              side: BorderSide.none,
            ),
            itemBuilder: (context) {
              final items = <PopupMenuEntry<Object>>[
                PopupMenuItem<Object>(
                  value: _StatusMenuCmd.all,
                  child: const Text(
                    'Tous les statuts',
                    style: TextStyle(
                      fontSize: 16.0,
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
                          width: ResponsiveUtils.getIconSize(
                            context,
                            baseSize: 8,
                          ),
                          height: ResponsiveUtils.getIconSize(
                            context,
                            baseSize: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              int.parse(
                                status.colorHex.replaceAll('#', '0xFF'),
                              ),
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: context.horizontalSpacing / 2),
                        Text(
                          status.label,
                          style: TextStyle(
                            fontSize: FontSizes.bodyMedium.getSize(context),
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

          SizedBox(width: context.horizontalSpacing / 2),

          // Recherche
          SizedBox(
            width: ResponsiveUtils.getResponsiveImageSize(
              context,
              baseSize: Size(200, 200),
            ).width,
            height: context.buttonHeight,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(
                  fontSize: FontSizes.bodyMedium.getSize(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: ResponsiveUtils.getIconSize(context, baseSize: 20),
                ),
                filled: true,
                fillColor: DeepColorTokens.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.borderRadius),
                ),
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
