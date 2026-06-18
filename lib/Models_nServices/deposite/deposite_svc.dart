import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gcc/Models_nServices/deposite/deposite_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

Future<DepositResponse> submitDeposit({
  required double amount,
  required String utrNumber,
  required String paymentScreenshotPath,
}) async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  if (token.isEmpty) {
    throw Exception('Authorization token not found. Please login again.');
  }

  if (!File(paymentScreenshotPath).existsSync()) {
    throw Exception('Payment screenshot file not found.');
  }

  try {
    final formData = FormData.fromMap({
      'amount': amount.toString(),
      'utr_number': utrNumber,
      'payment_screenshot': await MultipartFile.fromFile(
        paymentScreenshotPath,
        filename:
            'payment_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
      ),
    });

    debugPrint('Deposit API URL: ${ApiEndpoints.paymentsDeposits}');
    debugPrint('Deposit Amount: $amount, UTR: $utrNumber');

    Response response = await DioClient.dio.post(
      ApiEndpoints.paymentsDeposits,
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    debugPrint('Deposit API Status: ${response.statusCode}');
    debugPrint('Deposit API Response: ${response.data}');

    return DepositResponse.fromJson(response.data);
  } on DioException catch (e) {
    String errorMessage = 'Failed to submit deposit. Please try again.';

    if (e.response != null) {
      debugPrint('Deposit API Error Status: ${e.response?.statusCode}');
      debugPrint('Deposit API Error Data: ${e.response?.data}');

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
