import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
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
          margin: EdgeInsets.symmetric(
            horizontal: context.scaleMD_LG_XL_XXL,
          ),
          padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: EcoPlatesDesignTokens.opacity.semiTransparent,
            ),
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.xl,
            ),
            border: Border.all(
              color: Colors.grey[300]!.withValues(
                alpha: EcoPlatesDesignTokens.opacity.disabled,
              ),
              width: DesignConstants.zeroPointFive,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                ),
                blurRadius: EcoPlatesDesignTokens.elevation.mediumBlur,
                offset: EcoPlatesDesignTokens.elevation.standardOffset,
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
                    height: EcoPlatesDesignTokens.size.buttonHeight(context),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scaleXXS_XS_SM_MD,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topLeft: isFirst
                            ? Radius.circular(EcoPlatesDesignTokens.radius.lg)
                            : Radius.zero,
                        bottomLeft: isFirst
                            ? Radius.circular(EcoPlatesDesignTokens.radius.lg)
                            : Radius.zero,
                        topRight: isLast
                            ? Radius.circular(EcoPlatesDesignTokens.radius.lg)
                            : Radius.zero,
                        bottomRight: isLast
                            ? Radius.circular(EcoPlatesDesignTokens.radius.lg)
                            : Radius.zero,
                      ),
                      gradient: isSelected
                          ? null
                          : LinearGradient(
                              colors: [
                                Colors.white.withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .gradientPrimary,
                                ),
                                Colors.white.withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .veryTransparent,
                                ),
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
                                ).colorScheme.onSurface.withValues(
                                  alpha: EcoPlatesDesignTokens
                                      .opacity
                                      .almostOpaque,
                                ),
                          size: context.scaleIconStandard,
                        ),
                        SizedBox(width: context.scaleXXS_XS_SM_MD),
                        Text(
                          mode.label,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withValues(
                                    alpha: EcoPlatesDesignTokens
                                        .opacity
                                        .gradientPrimary,
                                  ),
                            fontWeight: isSelected
                                ? EcoPlatesDesignTokens.typography.semiBold
                                : EcoPlatesDesignTokens.typography.medium,
                            fontSize: EcoPlatesDesignTokens.typography
                                .modalTitle(context),
                            letterSpacing: DesignConstants.zeroPointFive / 2.5,
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
