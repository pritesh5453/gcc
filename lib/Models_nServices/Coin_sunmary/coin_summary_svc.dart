import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/Coin_sunmary/coin_summary_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<CoinSummaryResponse> fetchCoinSummary() async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  try {
    debugPrint('Coin summary API URL: ${ApiEndpoints.coinSummary}');

    Response response = await DioClient.dio.get(
      ApiEndpoints.coinSummary,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    debugPrint('Coin summary API Status: ${response.statusCode}');
    debugPrint('Coin summary API Response: ${response.data}');

    return CoinSummaryResponse.fromJson(
      response.data is Map<String, dynamic>
          ? response.data
          : Map<String, dynamic>.from(response.data),
    );
  } on DioException catch (e) {
    String errorMessage = 'Failed to fetch coin summary. Please try again.';

    if (e.response != null) {
      debugPrint('Coin summary API Error Status: ${e.response?.statusCode}');
      debugPrint('Coin summary API Error Data: ${e.response?.data}');

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
