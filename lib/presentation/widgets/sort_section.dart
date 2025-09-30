import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
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
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Text(
            'Trier par : ',
            style: TextStyle(
              color: DeepColorTokens.neutral600,
              fontSize: 14.0,
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
                    color: DeepColorTokens.primary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.0),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.0,
                  color: DeepColorTokens.primary,
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
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: DeepColorTokens.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
          ),
          child: const SortModal(),
        ),
      ),
    );
  }
}
