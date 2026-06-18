import 'package:dio/dio.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/Trading_response/trading_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<TradingCoinsResponse> fetchTradingCoins() async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  try {
    Response response = await DioClient.dio.get(
      ApiEndpoints.tradingCoins,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return TradingCoinsResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Failed to load trading coins data',
    );
  }
}
