import 'package:flutter/material.dart';
import 'package:gcc/Models_nServices/earn_rewards/earn_model.dart';
import 'package:gcc/Models_nServices/earn_rewards/earn_svc.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/Screens/profile/my_impacts.dart';
import 'package:gcc/main.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

class EarnRewardsScreen extends StatefulWidget {
  const EarnRewardsScreen({super.key});

  @override
  State<EarnRewardsScreen> createState() => _EarnRewardsScreenState();
}

class _EarnRewardsScreenState extends State<EarnRewardsScreen> with RouteAware {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  final EarnRewardsService _rewardsService = EarnRewardsService();
  bool _isLoading = true;
  String? _errorMessage;
  int _rewardPointsBalance = 0;
  List<EarnRewardsActivity> _activities = [];

  int _selectedTab = 0;
  final List<String> _tabs = [
    'Daily Tasks',
    'One Time Tasks',
    'Challenges',
    'Achievements',
  ];

  // Reward statuses from new API
  bool _isDailyLoginClaimed = false;
  bool _isBuyRewardClaimed = false;
  bool _isReferralRewardClaimed = false;
  bool _isTrackImpactClaimed =
      false; // kept for compatibility, but use _trackImpactStatus

  // New: track impact status (0=not tracked, 1=eligible, 2=claimed)
  int _trackImpactStatus = 0;

  bool _isClaiming = false;
  bool _isProcessingImpact = false; // for both Track and Claim actions

  @override
  void initState() {
    super.initState();
    _fetchRewardsData();
    _fetchRewardStatuses(); // uses new consolidated API
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchRewardStatuses();
    _fetchRewardsData();
  }

  Future<void> _fetchRewardsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        setState(() {
          _errorMessage = 'User not authenticated. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final response = await _rewardsService.getEarnRewards(token: token);
      if (response != null && response.success) {
        setState(() {
          _rewardPointsBalance = response.data.rewardPointsBalance;
          _activities = response.data.activities;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response?.message ?? 'Failed to load rewards data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Fetches all statuses from consolidated API
  Future<void> _fetchRewardStatuses() async {
    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) return;

      final summary = await _rewardsService.getRewardStatusSummary(
        token: token,
      );
      if (summary != null && summary.status) {
        setState(() {
          _isDailyLoginClaimed = summary.data.dailyLoginStatus == 1;
          _isBuyRewardClaimed = summary.data.buyRewardStatus == 1;
          _isReferralRewardClaimed = summary.data.referralRewardStatus == 1;
          // Store the raw status for impact
          _trackImpactStatus = summary.data.trackYourImpactStatus;
          _isTrackImpactClaimed =
              (_trackImpactStatus == 2); // backward compatible
          _rewardPointsBalance = summary.data.totalRewardPoints;
        });
      }
    } catch (e) {
      debugPrint('Error fetching reward statuses: $e');
    }
  }

  // ---------- Impact Flow ----------
  // Step 1: Track → call track API, navigate to impact screen
  Future<void> _trackImpact() async {
    if (_trackImpactStatus != 0) return; // only if not tracked
    setState(() => _isProcessingImpact = true);
    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        _showSnackBar('Please login again');
        return;
      }

      final response = await _rewardsService.trackImpact(token: token);
      if (response != null && response.success) {
        // Navigate to impact screen
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyImpactScreen()),
        );
        // Refresh statuses after returning (didPopNext will also handle this)
        await _fetchRewardStatuses();
        await _fetchRewardsData();
        _showSnackBar('Impact tracked! You can now claim your reward.');
      } else {
        _showSnackBar(response?.message ?? 'Failed to track impact');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => _isProcessingImpact = false);
    }
  }

  // Step 2: Claim → call claim API, no navigation
  Future<void> _claimImpact() async {
    if (_trackImpactStatus != 1) return; // only if eligible
    setState(() => _isProcessingImpact = true);
    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        _showSnackBar('Please login again');
        return;
      }

      final response = await _rewardsService.claimTrackImpact(token: token);
      if (response != null && response.success) {
        // Refresh statuses (the button will become "Claimed")
        await _fetchRewardStatuses();
        await _fetchRewardsData();
        _showSnackBar('Reward claimed! +${response.claimedPoints} points');
      } else {
        // If already claimed, refresh status anyway
        await _fetchRewardStatuses();
        _showSnackBar(response?.message ?? 'Claim failed');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => _isProcessingImpact = false);
    }
  }
  // ---------------------------------

  Future<void> _claimDailyLoginReward() async {
    setState(() => _isClaiming = true);
    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        _showSnackBar('Please login again');
        return;
      }

      final response = await _rewardsService.claimLoginReward(token: token);
      if (response != null && response.success) {
        await _fetchRewardStatuses(); // refresh all statuses and balance
        await _fetchRewardsData(); // refresh activities (optional)
        _updateDailyLoginActivityPoints(response.claimedPoints);
        _showSnackBar(
          'Daily login reward claimed! +${response.claimedPoints} points',
        );
      } else {
        _showSnackBar(response?.message ?? 'Claim failed');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() => _isClaiming = false);
    }
  }

  void _updateDailyLoginActivityPoints(int newPoints) {
    final index = _activities.indexWhere(
      (a) => a.activityName.toLowerCase().contains('daily login'),
    );
    if (index != -1) {
      setState(() {
        _activities[index] = EarnRewardsActivity(
          activityName: _activities[index].activityName,
          points: newPoints,
        );
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: primaryGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? _buildErrorWidget()
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: _buildBalanceCard(),
                            ),
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Column(
                                children: [
                                  _buildTasksSection(),
                                  const SizedBox(height: 14),
                                  _buildAchievementsSection(),
                                  const SizedBox(height: 14),
                                  _buildBottomBannerCard(),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchRewardsData();
                _fetchRewardStatuses();
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Earn Rewards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Complete actions and earn Eco-Rewards',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Eco-Rewards Balance',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _rewardPointsBalance.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Points',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 90,
                height: 80,
                child: Stack(
                  children: const [
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Text('🎁', style: TextStyle(fontSize: 55)),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 10,
                      child: Text('🪙', style: TextStyle(fontSize: 22)),
                    ),
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Text(
                        '✦',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 10,
                      child: Text(
                        '✦',
                        style: TextStyle(fontSize: 8, color: Color(0xFF4CAF50)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌿', style: TextStyle(fontSize: 13)),
                SizedBox(width: 6),
                Text(
                  'Keep earning points and unlock exciting rewards!',
                  style: TextStyle(
                    fontSize: 11,
                    color: primaryGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    if (_activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No tasks available at the moment.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                'Activities',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Resets daily',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(height: 16),
          ...List.generate(
            _activities.length,
            (i) => _buildActivityRow(_activities[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(EarnRewardsActivity activity) {
    IconData iconData;
    String actionText;
    String actionType;
    double progress = 0.0;
    String progressLabel = '';

    final name = activity.activityName.toLowerCase();

    if (name.contains('buy')) {
      iconData = Icons.shopping_bag_outlined;
      if (_isBuyRewardClaimed) {
        actionText = 'Claim';
        actionType = 'claimed';
      } else {
        actionText = 'Claim';
        actionType = 'go';
      }
    } else if (name.contains('login')) {
      iconData = Icons.calendar_today_outlined;
      if (_isDailyLoginClaimed) {
        actionText = 'Claimed';
        actionType = 'claimed';
      } else {
        actionText = 'Claim';
        actionType = 'claim';
      }
    } else if (name.contains('invite')) {
      iconData = Icons.group_add_outlined;
      if (_isReferralRewardClaimed) {
        actionText = 'Invite';
        actionType = 'claimed';
      } else {
        actionText = 'Invite';
        actionType = 'go';
      }
    } else if (name.contains('share')) {
      iconData = Icons.share_outlined;
      actionText = '';
      actionType = 'progress';
      progress = 0.0;
      progressLabel = '0/1';
    } else if (name.contains('impact')) {
      iconData = Icons.eco_outlined;
      // Determine button based on _trackImpactStatus
      if (_trackImpactStatus == 2) {
        actionText = 'Claimed';
        actionType = 'claimed';
      } else if (_trackImpactStatus == 1) {
        actionText = 'Claim';
        actionType = 'impact_claim';
      } else {
        // status == 0
        actionText = 'Track';
        actionType = 'impact_track';
      }
    } else if (name.contains('video') || name.contains('eco')) {
      iconData = Icons.play_circle_outline;
      actionText = 'Watch';
      actionType = 'go';
    } else {
      iconData = Icons.star_outline;
      actionText = 'Earn';
      actionType = 'go';
    }

    final isClaimButton = actionType == 'claim';
    final isButtonEnabled =
        isClaimButton ? !_isDailyLoginClaimed && !_isClaiming : true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, color: primaryGreen, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.activityName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '+${activity.points} points',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBBE5C8)),
            ),
            child: Row(
              children: [
                Text(
                  '+${activity.points}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.check_circle, color: primaryGreen, size: 12),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (actionType == 'claim')
            SizedBox(
              width: 70,
              height: 34,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _claimDailyLoginReward : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isClaiming
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Claim',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            )
          else if (actionType == 'impact_track')
            SizedBox(
              width: 70,
              height: 34,
              child: ElevatedButton(
                onPressed: _isProcessingImpact ? null : _trackImpact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isProcessingImpact
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Track',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            )
          else if (actionType == 'impact_claim')
            SizedBox(
              width: 70,
              height: 34,
              child: ElevatedButton(
                onPressed: _isProcessingImpact ? null : _claimImpact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isProcessingImpact
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Claim',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            )
          else if (actionType == 'claimed')
            Container(
              width: 70,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else if (actionType == 'go')
            SizedBox(
              width: 70,
              height: 34,
              child: OutlinedButton(
                onPressed: () {
                  if (name.contains('buy')) {
                    // Navigate to buy section
                  } else if (name.contains('invite')) {
                    // Navigate to invite friends
                  } else if (name.contains('video')) {
                    // Play video
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryGreen,
                  side: const BorderSide(color: primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else if (actionType == 'progress')
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        progressLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      color: primaryGreen,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements = [
      {
        'emoji': '🛡️',
        'title': 'Green Beginner',
        'sub': 'Complete 5 tasks',
        'progress': 3 / 5,
        'progressLabel': '3/5',
      },
      {
        'emoji': '🌳',
        'title': 'Tree Supporter',
        'sub': 'Support 10 Trees',
        'progress': 7 / 10,
        'progressLabel': '7/10',
      },
      {
        'emoji': '🌍',
        'title': 'Eco Champ',
        'sub': 'Earn 2000 Points',
        'progress': _rewardPointsBalance / 2000,
        'progressLabel': '${_rewardPointsBalance}/2,000',
      },
    ];

    return Column(
      children: [
        Row(
          children: const [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children:
              achievements.map((a) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Text(
                          a['emoji'] as String,
                          style: const TextStyle(fontSize: 36),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a['title'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          a['sub'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: a['progress'] as double,
                            backgroundColor: Colors.grey[200],
                            color: primaryGreen,
                            minHeight: 5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            a['progressLabel'] as String,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBannerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Row(
        children: [
          const Text('🪴', style: TextStyle(fontSize: 38)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More actions, more impact!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Every action you take brings us closer\nto a greener planet.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Row(
              children: [
                Text(
                  'Explore Rewards',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
