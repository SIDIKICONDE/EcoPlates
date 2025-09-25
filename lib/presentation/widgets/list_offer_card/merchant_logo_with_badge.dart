import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          // Logo du restaurant qui remplit le conteneur
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: brandsAsync.when(
                  data: (brands) => _buildMerchantLogo(brands, theme),
                  loading: () => CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                  error: (error, stack) => Text(
                    merchantName[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Badge quantité disponible
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: availableQuantity <= 3 ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$availableQuantity',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le logo en utilisant les données du brand_provider
  Widget _buildMerchantLogo(List<Brand> brands, ThemeData theme) {
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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      );
    }

    // Afficher le logo de la marque
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CachedNetworkImage(
        imageUrl: foundBrand.logoUrl,
        fit: BoxFit.contain,
        memCacheWidth: 88, // Cache optimisé pour la taille d'affichage
        memCacheHeight: 88,
        maxWidthDiskCache: 176, // Cache disque optimisé
        maxHeightDiskCache: 176,
        placeholder: (context, url) => Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.primaryColor.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          // Debug: Error loading logo ${foundBrand?.name}: $error (URL: $url)

          // Essayer une URL alternative si disponible
          if (foundBrand != null && _hasAlternativeUrl(foundBrand)) {
            return CachedNetworkImage(
              imageUrl: _getAlternativeUrl(foundBrand),
              fit: BoxFit.contain,
              memCacheWidth: 88,
              memCacheHeight: 88,
              errorWidget: (context, url, error) => _buildFallbackLogo(theme),
            );
          }

          return _buildFallbackLogo(theme);
        },
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
  Widget _buildFallbackLogo(ThemeData theme) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        merchantName[0].toUpperCase(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
