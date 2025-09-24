import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/food_offer_repository_impl.dart';
import '../../domain/repositories/food_offer_repository.dart';

/// Provider pour ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Provider pour FoodOfferRepository
/// Utilise l'implémentation concrète FoodOfferRepositoryImpl
final foodOfferRepositoryProvider = Provider<FoodOfferRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FoodOfferRepositoryImpl(apiClient);
});