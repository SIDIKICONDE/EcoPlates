import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';

/// Provider pour ApiClient avec une configuration simple
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.ecoplates.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  return ApiClient(dio: dio);
});