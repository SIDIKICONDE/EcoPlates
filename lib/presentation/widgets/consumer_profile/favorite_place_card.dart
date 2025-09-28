import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import 'favorites_models.dart';

/// Carte affichant un lieu favori
class FavoritePlaceCard extends StatelessWidget {
  const FavoritePlaceCard({
    required this.place, super.key,
  });

  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: context.responsiveValue(
        mobile: 140,
        tablet: 160,
        desktop: 180,
      ),
      padding: EdgeInsets.all(
        context.responsiveValue(
          mobile: 10,
          tablet: 12,
          desktop: 14,
        ),
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            mobile: 10,
            tablet: 12,
            desktop: 14,
          ),
        ),
        border: Border.all(
          color: colors.primaryContainer,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.store,
                color: colors.primary,
                size: context.responsiveValue(
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.favorite,
                color: colors.error,
                size: context.responsiveValue(
                  mobile: 14,
                  tablet: 16,
                  desktop: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: 6,
              tablet: 8,
              desktop: 10,
            ),
          ),
          Text(
            place.name,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: context.responsiveValue(
              mobile: 3,
              tablet: 4,
              desktop: 5,
            ),
          ),
          Text(
            place.address,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: context.responsiveValue(
                  mobile: 12,
                  tablet: 14,
                  desktop: 16,
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  mobile: 2,
                  tablet: 2,
                  desktop: 3,
                ),
              ),
              Text(
                place.rating.toString(),
                style: textTheme.labelSmall,
              ),
              const Spacer(),
              Text(
                '${place.visitCount} visites',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
