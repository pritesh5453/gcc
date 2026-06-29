import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/transaction/transaction_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class TransactionService {
  final Dio _dio = DioClient.dio;

  // ─── Fetch Transactions ──────────────────────────────────────────────
  Future<TransactionResponse> getTransactions(
    String token, {
    int page = 1,
    int perPage = 10,
    String? type, // "buy" or "sell"
    String? status,
    int? coinId,
    String? startDate,
    String? endDate,
    String? search,
    String sort = 'desc',
  }) async {
    try {
      final queryParams = {
        'page': page,
        'per_page': perPage,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
        if (coinId != null) 'coin_id': coinId,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (search != null && search.isNotEmpty) 'search': search,
        'sort': sort,
      };

      final response = await _dio.get(
        ApiEndpoints.transactions,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return TransactionResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to fetch transactions: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  // ─── Get Next Page ──────────────────────────────────────────────────
  Future<TransactionResponse> getNextPage(
    String token,
    TransactionResponse currentResponse,
  ) async {
    final nextPage = currentResponse.data.pagination.currentPage + 1;
    if (nextPage > currentResponse.data.pagination.lastPage) {
      throw Exception('No more pages available');
    }
    return getTransactions(token, page: nextPage);
  }

  // ─── Get Previous Page ──────────────────────────────────────────────
  Future<TransactionResponse> getPreviousPage(
    String token,
    TransactionResponse currentResponse,
  ) async {
    final prevPage = currentResponse.data.pagination.currentPage - 1;
    if (prevPage < 1) {
      throw Exception('Already on first page');
    }
    return getTransactions(token, page: prevPage);
  }
}