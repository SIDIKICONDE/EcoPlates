import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/food_offer.dart';

/// Section dédiée à l'adresse de récupération
class OfferAddressSection extends StatelessWidget {
  final FoodOffer offer;

  const OfferAddressSection({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Adresse principale avec icône simple
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.location.address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${offer.location.postalCode} ${offer.location.city}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        // Navigation vers le profil du marchand
                        final merchantId = offer.merchantId;
                        debugPrint('🔗 Navigation vers profil marchand: $merchantId');
                        
                        try {
                          context.push('/merchant-profile/$merchantId');
                        } catch (e) {
                          debugPrint('❌ Erreur navigation: $e');
                          // Fallback: afficher un message ou naviguer vers une page d'erreur
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Impossible d\'ouvrir le profil du marchand'),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Plus d\'informations sur le marchand',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}