import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/edit_profile/edit_profile_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class KycService {
  static Future<ProfileUpdateResponse> updateProfile({
    required String bearerToken,
    required Map<String, dynamic> profileData,
  }) async {
    final response = await DioClient.dio.post(
      ApiEndpoints.updateProfile,
      data: profileData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      ),
    );
    return ProfileUpdateResponse.fromJson(response.data);
  }
}
