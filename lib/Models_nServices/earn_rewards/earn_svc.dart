import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/earn_rewards/earn_model.dart';
import 'package:gcc/api/api_endpoints.dart';
import 'package:gcc/api/dio_client.dart';

class EarnRewardsService {
  // Fetch all earn rewards activities and balance
  Future<EarnRewardsResponse?> getEarnRewards({required String token}) async {
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

  // New consolidated status API – gives daily login, buy, referral, track impact, total points
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

  // Claim daily login reward
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

  // ---------- NEW: Track Your Impact (first step) ----------
  Future<TrackYourImpactResponse?> trackImpact({required String token}) async {
    try {
      final response = await DioClient.dio.post(
        ApiEndpoints.trackImpact, // make sure this constant exists
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

  // ---------- Claim Track Your Impact (second step) ----------
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
}
