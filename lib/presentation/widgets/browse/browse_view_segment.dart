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
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            border: Border.all(
              color: Colors.grey[300]!.withValues(alpha: 0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: BrowseViewMode.values.map((mode) {
              final index = BrowseViewMode.values.indexOf(mode);
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
                    height: 44.0,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: isFirst
                            ? const Radius.circular(8.0)
                            : Radius.zero,
                        bottomLeft: isFirst
                            ? const Radius.circular(8.0)
                            : Radius.zero,
                        topRight: isLast
                            ? const Radius.circular(8.0)
                            : Radius.zero,
                        bottomRight: isLast
                            ? const Radius.circular(8.0)
                            : Radius.zero,
                      ),
                      gradient: isSelected
                          ? null
                          : LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.8),
                                Colors.white.withValues(alpha: 0.4),
                              ],
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
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                          size: 20.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          mode.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(alpha: 0.8),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            fontSize: 14.0,
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
