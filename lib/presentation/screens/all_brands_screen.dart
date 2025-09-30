import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../../core/themes/tokens/deep_color_tokens.dart';
import '../providers/brand_provider.dart';
import '../widgets/brand_card.dart';

/// Page affichant toutes les marques partenaires
class AllBrandsScreen extends ConsumerWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toutes les enseignes',
          style: TextStyle(
            fontSize: FontSizes.subtitleLarge.getSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        toolbarHeight: context.appBarHeight,
      ),
      body: brandsAsync.when(
        data: (brands) {
          final columns = ResponsiveUtils.getResponsiveColumns(
            context,
            tabletColumns: 2,
            desktopColumns: 3,
            desktopLargeColumns: 4,
          );

          return Container(
            margin: context.centerContentMargin,
            child: Padding(
              padding: context.responsivePadding,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: context.verticalSpacing,
                  crossAxisSpacing: context.horizontalSpacing,
                  childAspectRatio: ResponsiveUtils.getCardAspectRatio(context),
                ),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return BrandCard(
                    brand: brand,
                    onTap: () {
                      // Navigation vers la page détail de la marque
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${brand.name} - ${brand.formattedOffersCount}',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Container(
          margin: context.centerContentMargin,
          child: Padding(
            padding: context.responsivePadding,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: ResponsiveUtils.getIconSize(context),
                    color: DeepColorTokens.error,
                  ),
                  SizedBox(
                    height: context.verticalSpacing,
                  ),
                  Text(
                    'Erreur lors du chargement',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: FontSizes.titleMedium.getSize(context),
                    ),
                  ),
                  SizedBox(height: context.verticalSpacing),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      color: DeepColorTokens.neutral600,
                      fontSize: FontSizes.bodyMedium.getSize(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: context.verticalSpacing,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Forcer le rechargement
                      ref.invalidate(brandsProvider);
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: ResponsiveUtils.getIconSize(
                        context,
                        baseSize: 20.0,
                      ),
                    ),
                    label: Text(
                      'Réessayer',
                      style: TextStyle(
                        fontSize: FontSizes.buttonMedium.getSize(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
