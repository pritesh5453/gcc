import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/payment/verify_payment_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

Future<VerifyPaymentResponse> verifyPayment({
  required int coinId,
  required double inrAmount,
  required double coinAmount,
  required String paymentId,
  required String orderId,
  required String signature,
}) async {
  final token =
      AppPreference().getString(PreferencesKey.authToken).isNotEmpty
          ? AppPreference().getString(PreferencesKey.authToken)
          : AppPreference().getString('token');

  try {
    final response = await DioClient.dio.post(
      ApiEndpoints.verifyPayment,
      data: {
        "coin_id": coinId,
        "inr_amount": inrAmount,
        "coin_amount": coinAmount,
        "razorpay_payment_id": paymentId,
        "razorpay_order_id": orderId,
        "razorpay_signature": signature,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    print("========== VERIFY PAYMENT SUCCESS ==========");
    print("Status Code : ${response.statusCode}");
    print("Headers     : ${response.headers}");
    print("Response    : ${response.data}");
    print("===========================================");

    return VerifyPaymentResponse.fromJson(response.data);

  } on DioException catch (e) {

    print("========== VERIFY PAYMENT ERROR ==========");
    print("Status Code : ${e.response?.statusCode}");
    print("Headers     : ${e.response?.headers}");
    print("Response    : ${e.response?.data}");
    print("Request     : ${e.requestOptions.data}");
    print("=========================================");

    rethrow;
  }
}