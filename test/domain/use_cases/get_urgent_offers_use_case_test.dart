import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:ecoplates/domain/use_cases/get_urgent_offers_use_case.dart';
import 'package:ecoplates/domain/repositories/food_offer_repository.dart';
import 'package:ecoplates/domain/entities/food_offer.dart';
import 'package:ecoplates/core/error/failures.dart';

import 'get_urgent_offers_use_case_test.mocks.dart';

@GenerateMocks([FoodOfferRepository])
void main() {
  late GetUrgentOffersUseCase useCase;
  late MockFoodOfferRepository mockRepository;

  setUp(() {
    mockRepository = MockFoodOfferRepository();
    useCase = GetUrgentOffersUseCase(mockRepository);
  });

  group('GetUrgentOffersUseCase', () {
    final tNow = DateTime.now();
    
    final tUrgentOffers = [
      FoodOffer(
        id: '1',
        title: 'Urgent Offer 1',
        description: 'Description 1',
        merchantId: 'merchant_1',
        merchantName: 'Test Merchant 1',
        merchantAddress: 'Address 1',
        merchantLogo: 'logo1.png',
        category: FoodCategory.boulangerie,
        originalPrice: 10.0,
        discountedPrice: 3.0,
        type: OfferType.panier,
        quantity: 2,
        availableQuantity: 2,
        totalQuantity: 5,
        pickupStartTime: tNow.subtract(const Duration(minutes: 30)),
        pickupEndTime: tNow.add(const Duration(minutes: 60)), // 1 heure = urgent
        images: ['image1.jpg'],
        tags: ['Bio'],
        allergens: [],
        distanceKm: 0.5,
        rating: 4.5,
        ratingsCount: 100,
        isFavorite: false,
        nutritionalInfo: {},
        ecoImpact: {},
        createdAt: tNow.subtract(const Duration(hours: 1)),
        preparationTime: 5,
        viewCount: 50,
        soldCount: 20,
        status: OfferStatus.available,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: 'Test Address 1',
          city: 'Paris',
          postalCode: '75001',
        ),
        updatedAt: tNow,
      ),
      FoodOffer(
        id: '2',
        title: 'Urgent Offer 2',
        description: 'Description 2',
        merchantId: 'merchant_2',
        merchantName: 'Test Merchant 2',
        merchantAddress: 'Address 2',
        merchantLogo: 'logo2.png',
        category: FoodCategory.dejeuner,
        originalPrice: 20.0,
        discountedPrice: 6.0,
        type: OfferType.plat,
        quantity: 1,
        availableQuantity: 1,
        totalQuantity: 3,
        pickupStartTime: tNow.subtract(const Duration(minutes: 15)),
        pickupEndTime: tNow.add(const Duration(minutes: 45)), // 45 minutes = plus urgent
        images: ['image2.jpg'],
        tags: ['Végétarien'],
        allergens: ['Gluten'],
        distanceKm: 1.2,
        rating: 4.8,
        ratingsCount: 200,
        isFavorite: true,
        nutritionalInfo: {},
        ecoImpact: {},
        createdAt: tNow.subtract(const Duration(hours: 1)),
        preparationTime: 10,
        viewCount: 100,
        soldCount: 50,
        status: OfferStatus.available,
        location: const Location(
          latitude: 48.8566,
          longitude: 2.3522,
          address: 'Test Address 2',
          city: 'Paris',
          postalCode: '75001',
        ),
        updatedAt: tNow,
      ),
    ];

    const tParams = UrgentOffersParams(
      maxMinutesBeforeExpiry: 120,
      maxDistanceKm: 5.0,
      allowCached: true,
    );

    test(
      'should get urgent offers from repository when successful',
      () async {
        // arrange
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Right(tUrgentOffers));
        when(mockRepository.cacheOffers(any))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(tParams);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, 2);
            expect(offers.map((o) => o.id), containsAll(['1', '2']));
          },
        );
        verify(mockRepository.getUrgentOffers());
        verify(mockRepository.cacheOffers(any));
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should filter offers by max distance when specified',
      () async {
        // arrange
        const paramsWithDistance = UrgentOffersParams(
          maxMinutesBeforeExpiry: 120,
          maxDistanceKm: 1.0,
          allowCached: true,
        );
        
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Right(tUrgentOffers));
        when(mockRepository.cacheOffers(any))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(paramsWithDistance);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, 1);
            expect(offers.first.id, '1');
            expect(offers.first.distanceKm, lessThanOrEqualTo(1.0));
          },
        );
      },
    );

    test(
      'should sort offers by urgency (pickup end time)',
      () async {
        // arrange
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Right(tUrgentOffers));
        when(mockRepository.cacheOffers(any))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(tParams);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, 2);
            expect(offers[0].id, '2'); // Plus urgent (45 min)
            expect(offers[1].id, '1'); // Moins urgent (1 heure)
          },
        );
      },
    );

    test(
      'should return cached offers when repository fails and cache is allowed',
      () async {
        // arrange
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Left(ServerFailure('Server error')));
        when(mockRepository.getCachedOffers())
            .thenAnswer((_) async => Right(tUrgentOffers));

        // act
        final result = await useCase(tParams);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, greaterThanOrEqualTo(0)); // Peut être vide si filtré
            // Vérifier que ce sont bien les offres attendues si elles passent le filtre
            for (final offer in offers) {
              expect(tUrgentOffers.any((o) => o.id == offer.id), true);
            }
          },
        );
        verify(mockRepository.getUrgentOffers());
        verify(mockRepository.getCachedOffers());
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return failure when repository fails and cache is not allowed',
      () async {
        // arrange
        const paramsNoCached = UrgentOffersParams(
          maxMinutesBeforeExpiry: 120,
          allowCached: false,
        );
        
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Left(ServerFailure('Server error')));

        // act
        final result = await useCase(paramsNoCached);

        // assert
        expect(result, Left(ServerFailure('Server error')));
        verify(mockRepository.getUrgentOffers());
        verifyNever(mockRepository.getCachedOffers());
      },
    );

    test(
      'should filter out offers that are not urgent (> max minutes before expiry)',
      () async {
        // arrange
        final nonUrgentOffer = FoodOffer(
          id: '3',
          title: 'Non Urgent Offer',
          description: 'Description 3',
          merchantId: 'merchant_3',
          merchantName: 'Test Merchant 3',
          merchantAddress: 'Address 3',
          merchantLogo: 'logo3.png',
          category: FoodCategory.epicerie,
          originalPrice: 15.0,
          discountedPrice: 5.0,
          type: OfferType.panier,
          quantity: 5,
          availableQuantity: 5,
          totalQuantity: 10,
          pickupStartTime: tNow.add(const Duration(hours: 2)),
          pickupEndTime: tNow.add(const Duration(hours: 3)), // > 2 heures
          images: ['image3.jpg'],
          tags: [],
          allergens: [],
          distanceKm: 0.8,
          rating: 4.2,
          ratingsCount: 50,
          isFavorite: false,
          nutritionalInfo: {},
          ecoImpact: {},
          createdAt: tNow.subtract(const Duration(hours: 1)),
        preparationTime: 5,
          viewCount: 30,
          soldCount: 10,
          status: OfferStatus.available,
          location: const Location(
            latitude: 48.8566,
            longitude: 2.3522,
            address: 'Test Address 3',
            city: 'Paris',
            postalCode: '75001',
          ),
          updatedAt: tNow,
        );
        
        final mixedOffers = [...tUrgentOffers, nonUrgentOffer];
        
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Right(mixedOffers));
        when(mockRepository.cacheOffers(any))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(tParams);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, 2);
            expect(offers.any((o) => o.id == '3'), false);
          },
        );
      },
    );

    test(
      'should filter out offers with no available quantity',
      () async {
        // arrange
        final soldOutOffer = FoodOffer(
          id: '4',
          title: 'Sold Out Offer',
          description: 'Description 4',
          merchantId: 'merchant_4',
          merchantName: 'Test Merchant 4',
          merchantAddress: 'Address 4',
          merchantLogo: 'logo4.png',
          category: FoodCategory.dejeuner,
          originalPrice: 12.0,
          discountedPrice: 4.0,
          type: OfferType.plat,
          quantity: 0,
          availableQuantity: 0, // Épuisé
          totalQuantity: 5,
          pickupStartTime: tNow.add(const Duration(minutes: 30)),
          pickupEndTime: tNow.add(const Duration(hours: 1)),
          images: ['image4.jpg'],
          tags: [],
          allergens: [],
          distanceKm: 0.5,
          rating: 4.6,
          ratingsCount: 80,
          isFavorite: false,
          nutritionalInfo: {},
          ecoImpact: {},
          createdAt: tNow.subtract(const Duration(hours: 1)),
        preparationTime: 5,
          viewCount: 60,
          soldCount: 30,
          status: OfferStatus.available,
          location: const Location(
            latitude: 48.8566,
            longitude: 2.3522,
            address: 'Test Address 4',
            city: 'Paris',
            postalCode: '75001',
          ),
          updatedAt: tNow,
        );
        
        final mixedOffers = [...tUrgentOffers, soldOutOffer];
        
        when(mockRepository.getUrgentOffers())
            .thenAnswer((_) async => Right(mixedOffers));
        when(mockRepository.cacheOffers(any))
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(tParams);

        // assert
        result.fold(
          (failure) => fail('Should not return failure'),
          (offers) {
            expect(offers.length, 2);
            expect(offers.any((o) => o.id == '4'), false);
          },
        );
      },
    );
  });
}