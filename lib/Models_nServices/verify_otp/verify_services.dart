import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/verify_otp/verify_model.dart';
import 'package:gcc/Baseurl/baseurl.dart';
import 'package:gcc/api/dio_client.dart';

Future<VerifyOtpModel> verifyOtp({
  required String sessionId,
  required String otp,
}) async {
  try {
    Response response = await DioClient.dio.post(
      ApiEndpoints.verifyOtp,
      data: {"session_id": sessionId, "otp": otp},
    );

    return VerifyOtpModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data["message"] ?? "OTP Verification Failed");
  }
}

Future<VerifyOtpModel> verifyLoginOtp({
  required String sessionId,
  required String otp,
}) async {
  try {
    Response response = await DioClient.dio.post(
      ApiEndpoints.verifyLoginOtp,
      data: {"session_id": sessionId, "otp": otp},
    );

    return VerifyOtpModel.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data["message"] ?? "OTP Verification Failed");
  }
}
