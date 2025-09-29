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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.0),

          // Titre de l'offre
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withValues(alpha: 0.9),
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: Offset(0.0, 1.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),

          // Stats Row
          Row(
            children: [
              // Prix
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: isFree ? Colors.green : Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  isFree ? 'GRATUIT' : priceText,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: isFree ? Colors.white : Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8.0),

              // Distance
              if (distance != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${distance!.toStringAsFixed(1)} km',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
              ],

              // Horaire
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12.0,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  SizedBox(width: 2.0),
                  Text(
                    pickupTime,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 14.0,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
