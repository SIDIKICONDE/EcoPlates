import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/food_offer.dart';
import 'offer_card/offer_card.dart';

/// Widget d'exemple pour tester l'OfferCard avec navigation
class OfferCardExample extends StatelessWidget {
  const OfferCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Créer une offre de test
    final testOffer = FoodOffer(
      id: 'test-offer-1',
      merchantId: 'merchant-1',
      merchantName: 'Au Pain Doré',
      title: 'Panier surprise boulangerie',
      description: 'Assortiment de pains et viennoiseries fraîches du jour',
      images: ['https://example.com/bakery.jpg'],
      type: OfferType.boulangerie,
      category: FoodCategory.boulangerie,
      originalPrice: 15.00,
      discountedPrice: 5.00,
      quantity: 3,
      pickupStartTime: DateTime.now().add(const Duration(hours: 2)),
      pickupEndTime: DateTime.now().add(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: OfferStatus.available,
      location: Location(
        latitude: 48.8566,
        longitude: 2.3522,
        address: '123 Rue de la Paix',
        city: 'Paris',
        postalCode: '75001',
        additionalInfo: 'Entrée par la rue latérale',
      ),
      allergens: ['Gluten', 'Œufs'],
      isVegetarian: true,
      isVegan: false,
      isHalal: false,
      co2Saved: 750,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test OfferCard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Cliquez sur la carte pour naviguer vers la page de détail :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: OfferCard(
                offer: testOffer,
                onTap: () {
                  debugPrint('Navigation vers /offer/${testOffer.id}');
                  context.push('/offer/${testOffer.id}');
                },
                showDistance: true,
                distance: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/offer/${testOffer.id}'),
              child: const Text('Test navigation directe'),
            ),
          ],
        ),
      ),
    );
  }
}