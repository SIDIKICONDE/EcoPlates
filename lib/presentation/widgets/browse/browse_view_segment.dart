import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/browse_view_provider.dart';
import '../sort_section.dart';

/// Segment de navigation pour basculer entre vue Liste et Carte
class BrowseViewSegment extends ConsumerWidget {
  const BrowseViewSegment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(browseViewModeProvider);
    
    return Column(
      children: [
        Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!.withValues(alpha: 0.5),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: BrowseViewMode.values.asMap().entries.map((entry) {
          final index = entry.key;
          final mode = entry.value;
          final isSelected = currentMode == mode;
          final isFirst = index == 0;
          final isLast = index == BrowseViewMode.values.length - 1;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(browseViewModeProvider.notifier).setMode(mode);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: isFirst ? const Radius.circular(14) : Radius.zero,
                      bottomLeft: isFirst ? const Radius.circular(14) : Radius.zero,
                      topRight: isLast ? const Radius.circular(14) : Radius.zero,
                      bottomRight: isLast ? const Radius.circular(14) : Radius.zero,
                    ),
                    gradient: isSelected ? null : LinearGradient(
                      colors: [Colors.white.withValues(alpha: 0.8), Colors.white.withValues(alpha: 0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      mode == BrowseViewMode.list 
                          ? Icons.view_list_rounded 
                          : Icons.map_rounded,
                      color: isSelected 
                          ? Colors.white 
                          : Colors.grey[600],
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mode.label,
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white 
                            : Colors.grey[700],
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.w500,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
          ),
        ),
        
        // Sous-section de tri
        const SortSection(),
      ],
    );
  }
}
