import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sort_provider.dart';
import '../widgets/sort_modal.dart';

/// Sous-section pour afficher et modifier l'option de tri
class SortSection extends ConsumerWidget {
  const SortSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Trier par : ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const SortModal(),
      ),
    );
  }
}
