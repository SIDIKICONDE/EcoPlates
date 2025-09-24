import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/merchant_repository.dart';
import '../../data/repositories/merchant_repository_data_impl.dart';
import '../../data/repositories/food_offer_repository.dart';
import '../../data/repositories/food_offer_repository_impl.dart';
import '../../core/network/api_client.dart';
import '../../core/providers/api_client_provider.dart';

/// Provider pour MerchantRepository
final merchantRepositoryProvider = Provider<MerchantRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DataMerchantRepositoryImpl(apiClient);
});

/// Provider pour FoodOfferRepository
final foodOfferRepositoryProvider = Provider<FoodOfferRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FoodOfferRepositoryImpl(apiClient);
});