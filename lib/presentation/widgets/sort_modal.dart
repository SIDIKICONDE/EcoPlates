import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/sort_options.dart';
import '../providers/sort_provider.dart';

/// Modal de tri pour les offres alimentaires
class SortModal extends ConsumerWidget {
  const SortModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(sortOptionProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Text(
            'Trier par',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          
          // Options de tri dans un ListView
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: SortOption.values.map((option) {
            final isSelected = currentSort == option;
            
            return ListTile(
              leading: Icon(
                option.icon,
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                size: 18,
              ),
              title: Text(
                option.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
                  fontSize: 14,
                ),
              ),
              trailing: isSelected 
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    )
                  : null,
              onTap: () {
                ref.read(sortOptionProvider.notifier).state = option;
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
