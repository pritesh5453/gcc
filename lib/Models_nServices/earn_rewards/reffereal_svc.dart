import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/earn_rewards/claim_reffereal.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class ReferralService {
  final Dio _dio = DioClient.dio;

  /// Claim referral reward
  /// Returns [ClaimReferralResponse] with status, message, points balance, claimed points, and trees awarded.
  Future<ClaimReferralResponse> claimReferral({required String token}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.claimReferral,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ClaimReferralResponse.fromJson(response.data);
    } on DioException catch (e) {
      String errorMsg = 'Something went wrong';
      if (e.response != null && e.response?.data != null) {
        try {
          final data = e.response?.data;
          if (data is Map<String, dynamic>) {
            errorMsg = data['message']?.toString() ?? errorMsg;
          }
        } catch (_) {}
      }
      throw Exception(errorMsg);
    }
  }
}