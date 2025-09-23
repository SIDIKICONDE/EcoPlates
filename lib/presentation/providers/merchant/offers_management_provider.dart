import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/food_offer.dart';
import '../../../domain/usecases/merchant/manage_offers_usecase.dart';
import '../../../data/repositories/merchant_repository.dart';
import '../../../data/repositories/food_offer_repository.dart';
import '../../../core/error/failures.dart';

// Repository providers (à implémenter dans les repos concrets)
final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  throw UnimplementedError('MerchantRepository provider needs implementation');
});

/// Provider pour le use case de gestion des offres
final manageOffersUseCaseProvider = Provider<ManageOffersUseCase>((ref) {
  final merchantRepository = ref.watch(merchantRepositoryProvider);
  final offerRepository = ref.watch(foodOfferRepositoryProvider);
  
  return ManageOffersUseCase(
    merchantRepository: merchantRepository,
    offerRepository: offerRepository,
  );
});

/// ID du commerçant actuellement connecté
final currentMerchantIdProvider = StateProvider<String?>((ref) => null);

/// Provider pour créer une offre
final createOfferProvider = FutureProvider.family<Either<Failure, FoodOffer>, CreateOfferRequest>(
  (ref, request) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.createOffer(
      merchantId: merchantId,
      request: request,
    );
  },
);

/// Provider pour mettre à jour une offre
final updateOfferProvider = FutureProvider.family<Either<Failure, FoodOffer>, ({String offerId, UpdateOfferRequest request})>(
  (ref, params) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.updateOffer(
      merchantId: merchantId,
      offerId: params.offerId,
      request: params.request,
    );
  },
);

/// Provider pour supprimer une offre
final deleteOfferProvider = FutureProvider.family<Either<Failure, void>, ({String offerId, String? reason})>(
  (ref, params) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.deleteOffer(
      merchantId: merchantId,
      offerId: params.offerId,
      reason: params.reason,
    );
  },
);

/// Provider pour dupliquer une offre
final duplicateOfferProvider = FutureProvider.family<Either<Failure, FoodOffer>, ({String offerId, DateTime? startTime, DateTime? endTime})>(
  (ref, params) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.duplicateOffer(
      merchantId: merchantId,
      offerId: params.offerId,
      newPickupStartTime: params.startTime,
      newPickupEndTime: params.endTime,
    );
  },
);

/// État des offres du commerçant
enum OffersViewFilter {
  all,
  active,
  draft,
  expired,
  today,
}

/// État des filtres pour la liste des offres
class OffersFilters {
  final String searchQuery;
  final OffersViewFilter statusFilter;

  const OffersFilters({
    this.searchQuery = '',
    this.statusFilter = OffersViewFilter.all,
  });

  OffersFilters copyWith({
    String? searchQuery,
    OffersViewFilter? statusFilter,
  }) {
    return OffersFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }
}

/// StateNotifier pour gérer les filtres des offres
class OffersFiltersNotifier extends StateNotifier<OffersFilters> {
  OffersFiltersNotifier() : super(const OffersFilters());

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateStatus(OffersViewFilter? status) {
    state = state.copyWith(statusFilter: status ?? OffersViewFilter.all);
  }

  void reset() {
    state = const OffersFilters();
  }
}

/// Provider pour filtrer les offres
final offersFiltersProvider = StateNotifierProvider<OffersFiltersNotifier, OffersFilters>((ref) {
  return OffersFiltersNotifier();
});

/// Provider pour filtrer les offres (ancien nom pour compatibilité)
final offersFilterProvider = StateProvider<OffersViewFilter>((ref) {
  return ref.watch(offersFiltersProvider).statusFilter;
});

/// Provider pour les offres du commerçant
final merchantOffersProvider = FutureProvider<Either<Failure, List<FoodOffer>>>((ref) async {
  final useCase = ref.watch(manageOffersUseCaseProvider);
  final merchantId = ref.watch(currentMerchantIdProvider);
  final filters = ref.watch(offersFiltersProvider);

  if (merchantId == null) {
    return Left(AuthenticationFailure('Non authentifié'));
  }

  OfferStatus? status;
  DateTime? startDate;
  DateTime? endDate;

  final now = DateTime.now();

  switch (filters.statusFilter) {
    case OffersViewFilter.active:
      status = OfferStatus.available;
      break;
    case OffersViewFilter.draft:
      status = OfferStatus.draft;
      break;
    case OffersViewFilter.expired:
      status = OfferStatus.expired;
      break;
    case OffersViewFilter.today:
      startDate = DateTime(now.year, now.month, now.day);
      endDate = startDate.add(const Duration(days: 1));
      break;
    case OffersViewFilter.all:
      // Pas de filtre
      break;
  }

  final result = await useCase.getMerchantOffers(
    merchantId: merchantId,
    status: status,
    startDate: startDate,
    endDate: endDate,
  );

  // Appliquer le filtre de recherche côté client
  return result.fold(
    (failure) => Left(failure),
    (offers) {
      if (filters.searchQuery.isEmpty) {
        return Right(offers);
      }

      final query = filters.searchQuery.toLowerCase();
      final filteredOffers = offers.where((offer) {
        return offer.title.toLowerCase().contains(query) ||
               offer.description.toLowerCase().contains(query);
      }).toList();

      return Right(filteredOffers);
    },
  );
});

/// Provider pour une offre spécifique
final offerByIdProvider = FutureProvider.family<Either<Failure, FoodOffer>, String>(
  (ref, offerId) async {
    final repository = ref.watch(foodOfferRepositoryProvider);
    return await repository.getOffer(offerId);
  },
);

/// Provider pour les statistiques d'une offre
final offerStatsProvider = FutureProvider.family<Either<Failure, OfferStats>, String>(
  (ref, offerId) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    return await useCase.getOfferStats(offerId);
  },
);

/// Provider pour activer/désactiver une offre
final toggleOfferStatusProvider = FutureProvider.family<Either<Failure, FoodOffer>, ({String offerId, bool activate})>(
  (ref, params) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.toggleOfferStatus(
      merchantId: merchantId,
      offerId: params.offerId,
      activate: params.activate,
    );
  },
);

/// Provider pour mettre à jour le stock
final updateOfferStockProvider = FutureProvider.family<Either<Failure, FoodOffer>, ({String offerId, int quantity})>(
  (ref, params) async {
    final useCase = ref.watch(manageOffersUseCaseProvider);
    final merchantId = ref.watch(currentMerchantIdProvider);
    
    if (merchantId == null) {
      return Left(AuthenticationFailure('Non authentifié'));
    }
    
    return await useCase.updateOfferStock(
      merchantId: merchantId,
      offerId: params.offerId,
      newQuantity: params.quantity,
    );
  },
);

/// StateNotifier pour gérer l'état de création d'offre
class OfferCreationState {
  final bool isLoading;
  final bool isSuccess;
  final Failure? error;
  final FoodOffer? createdOffer;
  
  const OfferCreationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.createdOffer,
  });
  
  OfferCreationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    Failure? error,
    FoodOffer? createdOffer,
  }) {
    return OfferCreationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      createdOffer: createdOffer ?? this.createdOffer,
    );
  }
}

class OfferCreationNotifier extends StateNotifier<OfferCreationState> {
  final ManageOffersUseCase _useCase;
  final String? _merchantId;
  
  OfferCreationNotifier(this._useCase, this._merchantId) : super(const OfferCreationState());
  
  Future<void> createOffer(CreateOfferRequest request) async {
    if (_merchantId == null) {
      state = state.copyWith(
        error: AuthenticationFailure('Non authentifié'),
        isLoading: false,
      );
      return;
    }
    
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _useCase.createOffer(
      merchantId: _merchantId,
      request: request,
    );
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure,
        isSuccess: false,
      ),
      (offer) => state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        createdOffer: offer,
      ),
    );
  }
  
  void reset() {
    state = const OfferCreationState();
  }
}

/// Provider pour l'état de création d'offre
final offerCreationProvider = StateNotifierProvider<OfferCreationNotifier, OfferCreationState>((ref) {
  final useCase = ref.watch(manageOffersUseCaseProvider);
  final merchantId = ref.watch(currentMerchantIdProvider);
  
  return OfferCreationNotifier(useCase, merchantId);
});

/// Provider pour les offres actives aujourd'hui
final todayActiveOffersProvider = FutureProvider<Either<Failure, List<FoodOffer>>>((ref) async {
  final offersResult = await ref.watch(merchantOffersProvider.future);
  
  return offersResult.fold(
    (failure) => Left(failure),
    (offers) {
      final now = DateTime.now();
      final todayOffers = offers.where((offer) {
        return offer.status == OfferStatus.available &&
               offer.pickupStartTime.day == now.day &&
               offer.pickupStartTime.month == now.month &&
               offer.pickupStartTime.year == now.year;
      }).toList();
      
      return Right(todayOffers);
    },
  );
});

/// Provider pour compter les offres par statut
final offersCountByStatusProvider = Provider<Map<OfferStatus, int>>((ref) {
  final offersAsync = ref.watch(merchantOffersProvider);
  
  return offersAsync.maybeWhen(
    data: (result) => result.fold(
      (_) => {},
      (offers) {
        final counts = <OfferStatus, int>{};
        for (final status in OfferStatus.values) {
          counts[status] = offers.where((o) => o.status == status).length;
        }
        return counts;
      },
    ),
    orElse: () => {},
  );
});

/// Provider pour les offres qui expirent bientôt
final expiringOffersProvider = Provider<List<FoodOffer>>((ref) {
  final offersAsync = ref.watch(merchantOffersProvider);
  
  return offersAsync.maybeWhen(
    data: (result) => result.fold(
      (_) => [],
      (offers) {
        final now = DateTime.now();
        final in24Hours = now.add(const Duration(hours: 24));
        
        return offers.where((offer) {
          return offer.status == OfferStatus.available &&
                 offer.pickupEndTime.isAfter(now) &&
                 offer.pickupEndTime.isBefore(in24Hours);
        }).toList()..sort((a, b) => a.pickupEndTime.compareTo(b.pickupEndTime));
      },
    ),
    orElse: () => [],
  );
});