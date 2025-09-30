import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/sort_options.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../providers/sort_provider.dart';

/// Modal de tri pour les offres alimentaires
class SortModal extends ConsumerWidget {
  const SortModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Text(
            'Trier par',
            style: TextStyle(
              color: DeepColorTokens.neutral800,
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),

          // Options de tri dans un ListView
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: SortOption.values.map((option) {
                final isSelected = currentSort == option;

                return ListTile(
                  leading: Icon(
                    option.icon,
                    color: isSelected
                        ? DeepColorTokens.primary
                        : DeepColorTokens.neutral600,
                    size: 24.0,
                  ),
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? DeepColorTokens.primary
                          : DeepColorTokens.neutral800,
                      fontSize: 14.0,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: DeepColorTokens.primary,
                          size: 20.0,
                        )
                      : null,
                  onTap: () {
                    ref.read(sortOptionProvider.notifier).setSortOption(option);
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  dense: true,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
