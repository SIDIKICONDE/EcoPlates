import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget pour afficher le message lorsqu'aucune information de contact n'est disponible
class NoContactInfoMessage extends StatelessWidget {
  const NoContactInfoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing * 2,
          vertical: context.verticalSpacing * 2,
        ),
        child: const Column(
          children: [
            ResponsiveIcon(
              Icons.info_outline,
              color: DeepColorTokens.neutral500,
              size: 48.0,
            ),
            VerticalGap(),
            ResponsiveText(
              'Aucune information de contact disponible',
              style: TextStyle(
                color: DeepColorTokens.neutral500,
              ),
              fontSize: FontSizes.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
