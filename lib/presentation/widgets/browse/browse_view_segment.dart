import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/browse_view_provider.dart';

/// Segment de navigation pour basculer entre vue Liste et Carte
class BrowseViewSegment extends ConsumerWidget {
  const BrowseViewSegment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(browseViewModeProvider);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: BrowseViewMode.values.map((mode) {
          final isSelected = currentMode == mode;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(browseViewModeProvider.notifier).state = mode;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode == BrowseViewMode.list 
                          ? Icons.list_rounded 
                          : Icons.map_rounded,
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mode.label,
                      style: TextStyle(
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[600],
                        fontWeight: isSelected 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}