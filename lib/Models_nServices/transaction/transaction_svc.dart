// lib/Models_nServices/transaction/transaction_svc.dart
import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/transaction/transaction_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class TransactionService {
  Future<TransactionResponseModel?> getTransactions({
    required String token,
    int page = 1,
    int perPage = 10,
    String? type,
    String? status,
    int? coinId,
    String? startDate,
    String? endDate,
    String? search,
    String sort = 'desc',
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        'sort': sort,
      };
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (coinId != null) queryParams['coin_id'] = coinId;
      if (startDate != null && startDate.isNotEmpty)
        queryParams['start_date'] = startDate;
      if (endDate != null && endDate.isNotEmpty)
        queryParams['end_date'] = endDate;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await DioClient.dio.get(
        ApiEndpoints.transactions,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return TransactionResponseModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Transaction API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }
}
