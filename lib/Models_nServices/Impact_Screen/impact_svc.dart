import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/Impact_Screen/impact_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class ImpactSummaryService {
  Future<ImpactSummaryResponse> getImpactSummary(String token) async {
    try {
      final response = await DioClient.dio.get(
        ApiEndpoints.impactSummary,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return ImpactSummaryResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to fetch impact summary',
      );
    }
  }
}
