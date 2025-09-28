import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/responsive/design_tokens.dart';
import '../providers/sort_provider.dart';
import '../widgets/sort_modal.dart';

/// Sous-section pour afficher et modifier l'option de tri
class SortSection extends ConsumerWidget {
  const SortSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.scaleMD_LG_XL_XXL,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      child: Row(
        children: [
          Text(
            'Trier par : ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: EcoPlatesDesignTokens.typography.text(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () => _showSortModal(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentSort.label,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: EcoPlatesDesignTokens.typography.text(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: context.scaleXXS_XS_SM_MD / 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: EcoPlatesDesignTokens.size.icon(context) / 1.2,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSortModal(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height *
                EcoPlatesDesignTokens.layout.modalMaxHeightFactor,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(EcoPlatesDesignTokens.radius.lg),
            ),
          ),
          child: const SortModal(),
        ),
      ),
    );
  }
}
