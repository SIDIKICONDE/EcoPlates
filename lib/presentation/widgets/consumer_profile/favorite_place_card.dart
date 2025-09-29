import 'package:flutter/material.dart';

import 'favorites_models.dart';

/// Carte affichant un lieu favori
class FavoritePlaceCard extends StatelessWidget {
  const FavoritePlaceCard({
    required this.place,
    super.key,
  });

  final FavoritePlace place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: 140.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.0),
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
                size: 16.0,
              ),
              const Spacer(),
              Icon(
                Icons.favorite,
                color: colors.error,
                size: 14.0,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            place.name,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3.0),
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
                color: const Color(0xFFFFC107),
                size: 12.0,
              ),
              const SizedBox(width: 2.0),
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
