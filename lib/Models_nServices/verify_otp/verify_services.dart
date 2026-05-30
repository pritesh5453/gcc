import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/verify_otp/verify_model.dart';
import 'package:gcc/Models_nServices/verify_otp/verify_services.dart' as ApiEndpoints;
import 'package:gcc/api/dio_client.dart';

Future<VerifyOtpModel> verifyOtp({
  required String sessionId,
  required String otp,
}) async {
  try {
    Response response = await DioClient.dio.post(
      ApiEndpoints.verifyOtp as String,
      data: {
        "session_id": sessionId,
        "otp": otp,
      },
    );

    return VerifyOtpModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
      e.response?.data["message"] ?? "OTP Verification Failed",
    );
  }
}