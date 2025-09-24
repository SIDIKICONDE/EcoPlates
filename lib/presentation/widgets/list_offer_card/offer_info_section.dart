import 'package:flutter/material.dart';

/// Widget pour afficher les informations détaillées d'une offre
class OfferInfoSection extends StatelessWidget {
  const OfferInfoSection({
    required this.merchantName,
    required this.title,
    required this.priceText,
    required this.isFree,
    required this.pickupTime,
    required this.distance,
    super.key,
  });

  final String merchantName;
  final String title;
  final String priceText;
  final bool isFree;
  final String pickupTime;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom du restaurant
          Text(
            merchantName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              shadows: [
                Shadow(),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Titre de l'offre
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
              shadows: const [
                Shadow(
                  blurRadius: 2,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // Stats Row
          Row(
            children: [
              // Prix
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isFree
                      ? Colors.green.shade600
                      : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  priceText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Distance
              if (distance != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 10,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${distance!.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Horaire
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    pickupTime,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
