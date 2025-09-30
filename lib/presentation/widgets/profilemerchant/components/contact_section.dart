import 'package:flutter/material.dart';
import '../../../../core/responsive/responsive.dart';
import '../../../../core/themes/tokens/deep_color_tokens.dart';

/// Widget générique pour une section de contact
/// Évite la répétition de code entre adresse, téléphone et email
class ContactSection extends StatelessWidget {
  const ContactSection({
    required this.icon,
    required this.title,
    required this.value,
    required this.actionIcon,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final IconData icon;
  final String title;
  final String value;
  final IconData actionIcon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(context.borderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalSpacing,
          vertical: context.responsive(
            mobile: 8.0,
            tablet: 10.0,
            desktop: 12.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveIcon(
              icon,
              color: DeepColorTokens.primary,
              size: 20.0,
            ),
            const HorizontalGap(multiplier: 0.75),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    title,
                    style: const TextStyle(
                      color: DeepColorTokens.neutral500,
                    ),
                    fontSize: FontSizes.label,
                  ),
                  ResponsiveText(
                    value,
                    style: const TextStyle(
                      color: DeepColorTokens.neutral1000,
                    ),
                    fontSize: FontSizes.bodyMedium,
                  ),
                ],
              ),
            ),
            ResponsiveIcon(
              actionIcon,
              color: DeepColorTokens.success,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
