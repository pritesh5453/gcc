import 'package:dio/dio.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/Models_nServices/Buy_transaction/buy_transaction_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<BuyTransactionResponse> sellGCCUnits({
  required int coinId,
  required double coinAmount,
}) async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  try {
    final payload = {'coin_id': coinId, 'coin_amount': coinAmount};

    Response response = await DioClient.dio.post(
      ApiEndpoints.sellTrading,
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return BuyTransactionResponse.fromJson(response.data);
  } on DioException catch (e) {
    String errorMessage = 'Failed to complete exchange. Please try again.';

    if (e.response != null) {
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
