import 'package:flutter/material.dart';
import '../../../core/responsive/design_tokens.dart';

/// Bouton favori animé avec effet de transition
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.isFavorite, super.key, this.onTap});
  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.scaleXXS_XS_SM_MD),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: EcoPlatesDesignTokens.colors.overlayBlack.withValues(
                alpha: EcoPlatesDesignTokens.opacity.subtle,
              ),
              blurRadius: EcoPlatesDesignTokens.elevation.smallBlur,
              offset: EcoPlatesDesignTokens.elevation.standardOffset,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: EcoPlatesDesignTokens.animation.normal,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavorite),
            color: isFavorite
                ? EcoPlatesDesignTokens.colors.snackbarError
                : Theme.of(context).colorScheme.onSurface.withValues(
                    alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                  ),
            size: EcoPlatesDesignTokens.size.indicator(context),
          ),
        ),
      ),
    );
  }
}
