import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:dio/dio.dart';
import 'package:gcc/Models_nServices/refer_n_invite/refer_n_invite_model.dart';
import 'package:gcc/Models_nServices/refer_n_invite/refer_n_invite_svc.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:intl/intl.dart';

class ReferralGrowthScreen extends StatefulWidget {
  const ReferralGrowthScreen({super.key});

  @override
  State<ReferralGrowthScreen> createState() => _ReferralGrowthScreenState();
}

class _ReferralGrowthScreenState extends State<ReferralGrowthScreen> {
  late Future<InviteScreenResponse> _futureData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final token = AppPreference().getString(PreferencesKey.authToken);
    print('🔑 ReferralGrowthScreen - Token: "$token"');

    if (token.isEmpty) {
      _futureData = Future.error('Authentication token missing. Please login again.');
      return;
    }

    _futureData = InviteScreenService()
        .getInviteScreen(token.trim())
        .catchError((dynamic error) {
      print('❌ API Error: $error');
      if (error is DioException) {
        print('DioException type: ${error.type}');
        print('Status code: ${error.response?.statusCode}');
        print('Response data: ${error.response?.data}');
        print('Message: ${error.message}');
        throw error;
      } else {
        throw error;
      }
    });
  }

  Future<List<InviteIntroduction>> _loadInstructions() async {
    final token = AppPreference().getString(PreferencesKey.authToken);
    if (token.isEmpty) throw Exception('Authentication token missing');
    return InviteScreenService().getInviteIntroduction(token.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const CommonAppBar(
                title: 'Referral & Growth',
                subtitle: 'Grow your network, grow the planet',
                showHelp: true,
              ),
              Expanded(
                child: FutureBuilder<InviteScreenResponse>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      final error = snapshot.error;
                      String errorMsg = 'Something went wrong';

                      if (error is DioException) {
                        final statusCode = error.response?.statusCode;
                        final data = error.response?.data;
                        String serverMsg = '';
                        if (data is Map && data.containsKey('message')) {
                          serverMsg = data['message'] as String;
                        }
                        if (statusCode == 401) {
                          errorMsg = 'Session expired. Please login again.';
                        } else if (statusCode == 404) {
                          errorMsg = 'API endpoint not found.';
                        } else if (statusCode != null) {
                          errorMsg = 'Error $statusCode: ${serverMsg.isNotEmpty ? serverMsg : error.message}';
                        } else {
                          errorMsg = 'Network error: ${error.message}';
                        }
                      } else if (error is String) {
                        errorMsg = error;
                      } else {
                        errorMsg = error.toString();
                      }

                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 50, color: Colors.red),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                errorMsg,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _loadData());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!.data;
                      return _buildContent(data);
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(InviteScreenData data) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          children: [
            _buildInviteDetailsCard(data),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildRewardBoostCard(data)),
                const SizedBox(width: 15),
                Expanded(child: _buildNetworkImpactCard(data)),
              ],
            ),
            const SizedBox(height: 20),
            _buildMonthlyAverageCard(data),
            const SizedBox(height: 25),
            _buildInstructionsButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── Invite Details Card ──────────────────────────────────────────────
  Widget _buildInviteDetailsCard(InviteScreenData data) {
    final volume = data.contributionVolume;
    final volumeStr = _formatCurrency(volume);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.green.shade50,
                    child: const Icon(
                      Icons.person_add,
                      size: 45,
                      color: Colors.green,
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B6B2F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "Your Referral",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          data.referralCode,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: data.referralCode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Referral code copied!')),
                            );
                          },
                          child: const Icon(Icons.copy, color: Colors.green, size: 20),
                        ),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Total Invites: ",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          TextSpan(
                            text: '${data.totalInvites}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.currency_rupee,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Contribution Volume : ",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                volumeStr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF1B6B2F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Reward Boost Card ──────────────────────────────────────────────────
  Widget _buildRewardBoostCard(InviteScreenData data) {
    final multiplier = data.rewardBoost.multiplier;
    return _smallCardLayout(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rocket_launch, size: 18, color: Colors.green),
              SizedBox(width: 5),
              Text(
                "Reward Boost",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                multiplier,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Icon(Icons.trending_up, color: Colors.green.shade300),
              ),
            ],
          ),
          const Text(
            "Eco Reward Multiplier",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ─── Network Impact Card ────────────────────────────────────────────────
  Widget _buildNetworkImpactCard(InviteScreenData data) {
    return _smallCardLayout(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.groups, size: 18, color: Colors.green),
              SizedBox(width: 5),
              Text(
                "Your Network",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _networkRow(Icons.person_outline, "Total Referrals", '${data.network.totalReferrals}'),
          const SizedBox(height: 8),
          _networkRow(Icons.check_circle_outline, "Active Contrib.", '${data.network.activeContributors}'),
        ],
      ),
    );
  }

  // ─── Monthly Average Card ──────────────────────────────────────────────
  Widget _buildMonthlyAverageCard(InviteScreenData data) {
    final avg = data.monthlyAverage.currentMonthAvgAmount;
    final avgStr = _formatCurrency(avg);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                "This Month's Average",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              avgStr,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B6B2F),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              "Average contribution per user this month",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper Widgets ─────────────────────────────────────────────────────
  Widget _smallCardLayout(Widget child) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FFF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade50),
      ),
      child: child,
    );
  }

  Widget _networkRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.green),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // ─── Instructions Button ──────────────────────────────────────────────
  Widget _buildInstructionsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: () => _showInstructionsPopup(context),
        icon: const Icon(Icons.info_outline, color: Colors.green),
        label: const Text(
          "Instructions",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // ─── Dynamic Instructions Popup ──────────────────────────────────────
  void _showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 8,
          child: FutureBuilder<List<InviteIntroduction>>(
            future: _loadInstructions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading instructions...'),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                final fallback = _getStaticInstructions();
                return _buildPopupContent(context, fallback);
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                // ✅ FIX: Use correct generic type
                final sorted = List<InviteIntroduction>.from(snapshot.data!);
                sorted.sort((a, b) => a.sequence.compareTo(b.sequence));
                return _buildPopupContent(context, sorted);
              } else {
                return _buildPopupContent(context, _getStaticInstructions());
              }
            },
          ),
        );
      },
    );
  }

  List<InviteIntroduction> _getStaticInstructions() {
    return [
      InviteIntroduction(id: 1, sequence: 1, introduction: 'Share your unique referral code with friends.'),
      InviteIntroduction(id: 2, sequence: 2, introduction: 'Earn rewards when your referrals make their first contribution.'),
      InviteIntroduction(id: 3, sequence: 3, introduction: 'Unlock higher reward multipliers as your network grows.'),
      InviteIntroduction(id: 4, sequence: 4, introduction: 'Track your monthly average to stay on top.'),
      InviteIntroduction(id: 5, sequence: 5, introduction: 'For any queries, contact our support team.'),
    ];
  }

  Widget _buildPopupContent(BuildContext context, List<InviteIntroduction> instructions) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade700,
                  Colors.green.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
                SizedBox(width: 10),
                Text(
                  "Instructions",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...instructions.map((item) => _instructionStep(
                item.sequence.toString(),
                item.introduction,
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Got It",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Currency Formatter ──────────────────────────────────────────────
  String _formatCurrency(int amount) {
    if (amount == 0) return '₹0';
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)} L';
    } else {
      final formatter = NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    }
  }
}