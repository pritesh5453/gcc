import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/profile/profile_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class UserService {
  Future<SimpleUser> fetchSimpleUser(String bearerToken) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.dashboardOverview,
        options: Options(headers: {'Authorization': 'Bearer $bearerToken'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final userJson = response.data['data']['user'];
        return SimpleUser.fromJson(userJson);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
