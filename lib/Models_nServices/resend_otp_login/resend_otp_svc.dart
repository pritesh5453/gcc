import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/resend_otp_login/resend_otp_model.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/api/api_endpoints.dart';

class ResendOtpService {
  final Dio _dio = DioClient.dio;

  Future<ResendOtpResponse> resendOtp(String sessionId) async {
    try {
      final request = ResendOtpRequest(sessionId: sessionId);
      final response = await _dio.post(
        ApiEndpoints.resendOtp, // e.g., '/login/resend-otp'
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ResendOtpResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}
