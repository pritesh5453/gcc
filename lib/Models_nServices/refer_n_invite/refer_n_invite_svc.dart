import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/refer_n_invite/refer_n_invite_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class InviteScreenService {
  final Dio _dio;

  InviteScreenService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<InviteScreenResponse> getInviteScreen(String token) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.inviteScreen, // <-- Replace with your actual endpoint constant
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return InviteScreenResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch invite screen: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // ─── Fetch Invite Introduction ──────────────────────────────────────────

Future<List<InviteIntroduction>> getInviteIntroduction(String token) async {
  try {
    final response = await _dio.get(
      ApiEndpoints.inviteIntroduction,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      // API returns { success, message, data: [ ... ] }
      final data = response.data as Map<String, dynamic>;
      final list = (data['data'] as List)
          .map((e) => InviteIntroduction.fromJson(e as Map<String, dynamic>))
          .toList();
      return list;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Failed to fetch introduction: ${response.statusCode}',
      );
    }
  } on DioException catch (e) {
    rethrow;
  }
}
}


