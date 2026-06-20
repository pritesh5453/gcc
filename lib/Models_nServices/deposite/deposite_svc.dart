import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gcc/Models_nServices/deposite/deposite_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<BuyCoinResponse> buyGCCUnits({
  required int coinId,
  required double inrAmount,
}) async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  try {
    final data = {'coin_id': coinId, 'inr_amount': inrAmount};

    debugPrint(
      'Buy API URL: ${ApiEndpoints.tradingCoins}?buy',
    ); // check endpoint
    debugPrint('Buy payload: $data');

    // Note: The endpoint might be /trading/buy, not /trading/coins.
    // We'll use the correct endpoint (define in ApiEndpoints later).
    // I'll add a new constant: static const String buyCoin = "$baseUrl/trading/buy";
    // For now, hardcode in this function, but better to add to ApiEndpoints.
    final response = await DioClient.dio.post(
      ApiEndpoints.buyCoin, // <-- we'll add this
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    debugPrint('Buy API Status: ${response.statusCode}');
    debugPrint('Buy API Response: ${response.data}');

    return BuyCoinResponse.fromJson(response.data);
  } on DioException catch (e) {
    String errorMessage = 'Failed to buy GCC units. Please try again.';

    if (e.response != null) {
      debugPrint('Buy API Error Status: ${e.response?.statusCode}');
      debugPrint('Buy API Error Data: ${e.response?.data}');

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        errorMessage = data['message']?.toString() ?? errorMessage;
      } else if (data != null) {
        errorMessage = data.toString();
      }
    } else {
      errorMessage = e.message ?? errorMessage;
    }

    throw Exception(errorMessage);
  }
}
