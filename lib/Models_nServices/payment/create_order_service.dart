import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gcc/Models_nServices/payment/create_order_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

Future<CreateOrderResponse> createOrder({
  required int coinId,
  required double inrAmount,
}) async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found.');
  }

  try {
    final response = await DioClient.dio.post(
      ApiEndpoints.createOrder,
      data: {
        "coin_id": coinId,
        "inr_amount": inrAmount,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    debugPrint("Create Order Response : ${response.data}");

    return CreateOrderResponse.fromJson(response.data);
  } on DioException catch (e) {
    debugPrint("Create Order Error : ${e.response?.data}");

    throw Exception(
      e.response?.data["message"] ??
          "Unable to create order.",
    );
  }
}