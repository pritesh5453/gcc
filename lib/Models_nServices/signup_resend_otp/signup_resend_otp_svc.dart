// This service matches the model of login resend otp so doesnt need seperate model.

import 'package:dio/dio.dart';
import 'package:gcc/api/dio_client.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/Models_nServices/resend_otp_login/resend_otp_model.dart'; // reuse model

class ResendOtpSignupService {
  final Dio _dio = DioClient.dio;

  Future<ResendOtpResponse> resendOtpSignup(String sessionId) async {
    try {
      final request = {'session_id': sessionId};

      print('Signup Resend URL: ${ApiEndpoints.resendOtpSignup}');
      print('Request body: $request');

      final response = await _dio.post(
        ApiEndpoints.resendOtpSignup,
        data: request,
      );

      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        return ResendOtpResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError: ${e.message}');
      print('Response: ${e.response?.data}');
      throw Exception(
        'Resend failed: ${e.message} - ${e.response?.data ?? ''}',
      );
    }
  }
}
