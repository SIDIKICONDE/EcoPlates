import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';

/// Badge pour indiquer qu'un restaurant est populaire
class PopularityBadge extends StatelessWidget {
  const PopularityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaleXS_SM_MD_LG,
        vertical: context.scaleXXS_XS_SM_MD,
      ),
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.snackbarWarning,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.xxl),
        boxShadow: [
          BoxShadow(
            color: EcoPlatesDesignTokens.colors.snackbarWarning.withValues(
              alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
            ),
            blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
            offset: EcoPlatesDesignTokens.elevation.standardOffset,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: EcoPlatesDesignTokens.size.indicator(context),
            color: Colors.white,
          ),
          SizedBox(width: context.scaleXXS_XS_SM_MD),
          Text(
            'POPULAIRE',
            style: TextStyle(
              color: Colors.white,
              fontSize: EcoPlatesDesignTokens.typography.hint(context),
              fontWeight: EcoPlatesDesignTokens.typography.bold,
            ),
          ),
        ],
      ),
    );
  }
}
