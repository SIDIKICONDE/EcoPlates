import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/responsive/design_tokens.dart';
import '../../../core/services/image_cache_service.dart';
import '../../../core/widgets/eco_cached_image.dart';
import '../../../domain/entities/brand.dart';
import '../../providers/brand_provider.dart';

/// Widget pour afficher le logo du restaurant avec badge de quantité disponible
class MerchantLogoWithBadge extends ConsumerWidget {
  const MerchantLogoWithBadge({
    required this.merchantName,
    required this.availableQuantity,
    super.key,
  });

  final String merchantName;
  final int availableQuantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final brandsAsync = ref.watch(brandsProvider);

    return Container(
      width: EcoPlatesDesignTokens.size.modalIcon(context),
      height: EcoPlatesDesignTokens.size.modalIcon(context),
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
          alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
        border: Border.all(
          color: EcoPlatesDesignTokens.colors.textPrimary.withValues(
            alpha: EcoPlatesDesignTokens.opacity.subtle,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Logo du restaurant qui remplit le conteneur
          ClipRRect(
            borderRadius: BorderRadius.circular(
              EcoPlatesDesignTokens.radius.sm,
            ),
            child: Container(
              width: EcoPlatesDesignTokens.size.modalIcon(context),
              height: EcoPlatesDesignTokens.size.modalIcon(context),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.verySubtle,
                ),
              ),
              child: Center(
                child: brandsAsync.when(
                  data: (brands) => _buildMerchantLogo(brands, theme, context),
                  loading: () => CircularProgressIndicator(
                    strokeWidth: EcoPlatesDesignTokens
                        .layout
                        .loadingIndicatorStrokeWidth,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary.withValues(
                        alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                      ),
                    ),
                  ),
                  error: (error, stack) => Text(
                    merchantName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: EcoPlatesDesignTokens.typography.titleSize(
                        context,
                      ),
                      fontWeight: EcoPlatesDesignTokens.typography.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Badge quantité disponible
          Positioned(
            top: -context.scaleXXS_XS_SM_MD / 2,
            right: -context.scaleXXS_XS_SM_MD / 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.scaleXXS_XS_SM_MD,
                vertical: context.scaleXXS_XS_SM_MD / 2,
              ),
              decoration: BoxDecoration(
                color: availableQuantity <= 3
                    ? EcoPlatesDesignTokens.colors.snackbarWarning
                    : EcoPlatesDesignTokens.colors.snackbarSuccess,
                borderRadius: BorderRadius.circular(
                  EcoPlatesDesignTokens.radius.md,
                ),
                border: Border.all(
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                  width: EcoPlatesDesignTokens.layout.cardBorderWidth,
                ),
              ),
              child: Text(
                '$availableQuantity',
                style: TextStyle(
                  fontSize: EcoPlatesDesignTokens.typography.hint(context),
                  fontWeight: EcoPlatesDesignTokens.typography.bold,
                  color: EcoPlatesDesignTokens.colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le logo en utilisant les données du brand_provider
  Widget _buildMerchantLogo(
    List<Brand> brands,
    ThemeData theme,
    BuildContext context,
  ) {
    final merchantNameLower = merchantName.toLowerCase().trim();

    // Chercher la marque correspondante avec une logique plus précise
    Brand? foundBrand;

    // 1. Recherche de correspondance exacte
    for (final brand in brands) {
      if (brand.name.toLowerCase() == merchantNameLower) {
        foundBrand = brand;
        break;
      }
    }

    // 2. Si pas trouvé, recherche si le marchand contient le nom de la marque
    // (ex: "Carrefour Market" contient "Carrefour")
    if (foundBrand == null) {
      for (final brand in brands) {
        final brandNameLower = brand.name.toLowerCase();
        if (merchantNameLower.contains(brandNameLower) &&
            (merchantNameLower.length - brandNameLower.length) < 10) {
          // Évite les faux positifs trop longs
          foundBrand = brand;
          break;
        }
      }
    }

    // 3. Recherche approximative pour les cas spéciaux (marques avec espaces ou caractères spéciaux)
    if (foundBrand == null) {
      for (final brand in brands) {
        final brandNameLower = brand.name.toLowerCase();
        // Gère les cas comme "McDonald's" vs "Mc Donald's"
        final normalizedMerchant = merchantNameLower
            .replaceAll("'", '')
            .replaceAll(' ', '');
        final normalizedBrand = brandNameLower
            .replaceAll("'", '')
            .replaceAll(' ', '');
        if (normalizedMerchant == normalizedBrand ||
            normalizedMerchant.contains(normalizedBrand) ||
            normalizedBrand.contains(normalizedMerchant)) {
          foundBrand = brand;
          break;
        }
      }
    }

    // Si aucune marque trouvée, afficher la première lettre
    if (foundBrand == null) {
      return Text(
        merchantName[0].toUpperCase(),
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
          fontWeight: EcoPlatesDesignTokens.typography.bold,
          color: theme.colorScheme.primary,
        ),
      );
    }

    // Afficher le logo de la marque
    return Container(
      width: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
      height: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
      decoration: BoxDecoration(
        color: EcoPlatesDesignTokens.colors.textPrimary,
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: EcoCachedImage(
        imageUrl: foundBrand.logoUrl,
        width: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
        height: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
        fit: BoxFit.contain,
        size: ImageSize.thumbnail,
        placeholder: Container(
          width: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
          height: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
          alignment: Alignment.center,
          child: SizedBox(
            width: EcoPlatesDesignTokens.size.indicator(context),
            height: EcoPlatesDesignTokens.size.indicator(context),
            child: CircularProgressIndicator(
              strokeWidth:
                  EcoPlatesDesignTokens.layout.loadingIndicatorStrokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary.withValues(
                  alpha: EcoPlatesDesignTokens.opacity.almostOpaque,
                ),
              ),
            ),
          ),
        ),
        errorWidget: Builder(
          builder: (context) {
            // Essayer une URL alternative si disponible
            if (foundBrand != null && _hasAlternativeUrl(foundBrand)) {
              return EcoCachedImage(
                imageUrl: _getAlternativeUrl(foundBrand),
                width: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
                height: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
                fit: BoxFit.contain,
                size: ImageSize.thumbnail,
                errorWidget: _buildFallbackLogo(theme, context),
              );
            }
            return _buildFallbackLogo(theme, context);
          },
        ),
      ),
    );
  }

  /// Vérifie si une URL alternative est disponible pour cette marque
  bool _hasAlternativeUrl(Brand brand) {
    // Pour l'instant, pas d'URLs alternatives, mais on peut étendre cela plus tard
    return false;
  }

  /// Retourne une URL alternative pour la marque (réservé pour extension future)
  String _getAlternativeUrl(Brand brand) {
    // Placeholder pour extension future
    return brand.logoUrl;
  }

  /// Construit le logo de fallback (première lettre du marchand)
  Widget _buildFallbackLogo(ThemeData theme, BuildContext context) {
    return Container(
      width: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
      height: EcoPlatesDesignTokens.size.modalIcon(context) * 0.73,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(
          alpha: EcoPlatesDesignTokens.opacity.verySubtle,
        ),
        borderRadius: BorderRadius.circular(EcoPlatesDesignTokens.radius.sm),
      ),
      child: Text(
        merchantName[0].toUpperCase(),
        style: TextStyle(
          fontSize: EcoPlatesDesignTokens.typography.titleSize(context),
          fontWeight: EcoPlatesDesignTokens.typography.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
