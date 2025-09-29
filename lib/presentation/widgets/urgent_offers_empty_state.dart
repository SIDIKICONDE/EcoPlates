import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/responsive/responsive_utils.dart';
import '../providers/offers_catalog_provider.dart';

/// État vide pour les offres urgentes
class UrgentOffersEmptyState extends ConsumerWidget {
  const UrgentOffersEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: context.responsivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: ResponsiveUtils.getIconSize(context, baseSize: 64.0),
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: context.verticalSpacing),
            Text(
              'Tout a été sauvé ! 🎉',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: FontSizes.titleMedium.getSize(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.verticalSpacing / 2),
            Text(
              'Aucune offre urgente en ce moment.\nRevenez plus tard pour sauver de la nourriture !',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: FontSizes.bodyLarge.getSize(context),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.verticalSpacing * 2),
            ElevatedButton.icon(
              onPressed: () async {
                await ref.read(offersRefreshProvider.notifier).refreshIfStale();
              },
              icon: Icon(
                Icons.refresh,
                size: ResponsiveUtils.getIconSize(context),
              ),
              label: Text(
                'Actualiser',
                style: TextStyle(
                  fontSize: FontSizes.buttonMedium.getSize(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
