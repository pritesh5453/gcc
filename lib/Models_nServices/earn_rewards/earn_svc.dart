import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/earn_rewards/claim_buy/claim_buy_model.dart';
import 'package:gcc/Models_nServices/earn_rewards/earn_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class EarnRewardsService {
  // ─── Get Earn Rewards ──────────────────────────────────────────────────
  Future<EarnRewardsResponse?> getEarnRewards({required String token}) async {
     print("🔑 Token being sent: $token"); // 👈 Add thi
    try {
      final Response response = await DioClient.dio.get(
        ApiEndpoints.earnRewards,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return EarnRewardsResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Earn Rewards API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // ─── Reward Status Summary ─────────────────────────────────────────────
  Future<RewardStatusSummaryResponse?> getRewardStatusSummary({
    required String token,
  }) async {
    try {
      final Response response = await DioClient.dio.get(
        ApiEndpoints.rewardStatusSummary,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return RewardStatusSummaryResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Reward Status Summary API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // ─── Claim Daily Login Reward ──────────────────────────────────────────
  Future<ClaimLoginRewardResponse?> claimLoginReward({
    required String token,
  }) async {
    try {
      final Response response = await DioClient.dio.post(
        ApiEndpoints.claimLoginReward,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 200) {
        return ClaimLoginRewardResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Claim Login Reward API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // ─── Track Your Impact (first step) ───────────────────────────────────
  Future<TrackYourImpactResponse?> trackImpact({required String token}) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoints.trackImpact,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return TrackYourImpactResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Track Impact API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // ─── Claim Track Your Impact (second step) ────────────────────────────
  Future<TrackImpactResponse?> claimTrackImpact({required String token}) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoints.claimTrackImpact,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return TrackImpactResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("Claim Track Impact API Error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }

  // ─── NEW: Claim Buy Reward ─────────────────────────────────────────────
  Future<ClaimBuyRewardResponse> claimBuyReward({required String token}) async {
      print("🔑 Token being sent: $token"); // 👈 Add thi
    try {
      final response = await DioClient.dio.post(
        ApiEndpoints.claimBuyReward, 
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return ClaimBuyRewardResponse.fromJson(response.data);
      } else {
        // If not 200, throw an exception so the caller can handle it
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to claim buy reward: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print("Claim Buy Reward API Error: ${e.response?.data}");
      rethrow; // Re-throw so the screen can handle it
    } catch (e) {
      print("Unexpected Error: $e");
      rethrow;
    }
  }
}