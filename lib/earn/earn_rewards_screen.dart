import 'package:flutter/material.dart';



class EarnRewardsScreen extends StatefulWidget {
  const EarnRewardsScreen({super.key});

  @override
  State<EarnRewardsScreen> createState() => _EarnRewardsScreenState();
}

class _EarnRewardsScreenState extends State<EarnRewardsScreen> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  int _selectedTab = 0;

  final List<String> _tabs = ['Daily Tasks', 'One Time Tasks', 'Challenges', 'Achievements'];

  final List<Map<String, dynamic>> _dailyTasks = [
    {
      'icon': Icons.calendar_today_outlined,
      'title': 'Daily Login',
      'sub': 'Login to the app',
      'points': '+10',
      'action': 'Claim',
      'actionType': 'claim',
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'title': 'Buy GCC Units',
      'sub': 'Purchase any GCC Units',
      'points': '+50',
      'action': 'Go',
      'actionType': 'go',
    },
    {
      'icon': Icons.group_add_outlined,
      'title': 'Invite a Friend',
      'sub': 'Invite and your friend joins',
      'points': '+100',
      'action': '',
      'actionType': 'progress',
      'progress': 0.0,
      'progressLabel': '0/1',
    },
    {
      'icon': Icons.eco_outlined,
      'title': 'Track Your Impact',
      'sub': 'Check your impact today',
      'points': '+20',
      'action': 'Go',
      'actionType': 'go',
    },
    {
      'icon': Icons.share_outlined,
      'title': 'Share the App',
      'sub': 'Share with your friends',
      'points': '+20',
      'action': '',
      'actionType': 'progress',
      'progress': 0.0,
      'progressLabel': '0/1',
    },
    {
      'icon': Icons.play_circle_outline,
      'title': 'Watch Eco Video',
      'sub': 'Watch a short eco video',
      'points': '+15',
      'action': 'Watch',
      'actionType': 'go',
    },
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'emoji': '🛡️',
      'title': 'Green Beginner',
      'sub': 'Complete 5 tasks',
      'progress': 3 / 5,
      'progressLabel': '3/5',
      'color': Color(0xFF2E7D32),
    },
    {
      'emoji': '🌳',
      'title': 'Tree Supporter',
      'sub': 'Support 10 Trees',
      'progress': 7 / 10,
      'progressLabel': '7/10',
      'color': Color(0xFF388E3C),
    },
    {
      'emoji': '🌍',
      'title': 'Eco Champ',
      'sub': 'Earn 2000 Points',
      'progress': 1850 / 2000,
      'progressLabel': '1,850/2,000',
      'color': Color(0xFF1565C0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildBalanceCard(),
                    ),
                    const SizedBox(height: 14),
                    _buildTabBar(),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: [
                          _buildDailyTasksSection(),
                          const SizedBox(height: 14),
                          _buildStreakCard(),
                          const SizedBox(height: 20),
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

  // ── App Bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.black87, size: 26),
          const Expanded(
            child: Column(
              children: [
                Text('Earn Rewards',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Complete actions and earn Eco-Rewards',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Colors.black87, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Balance Card ──────────────────────────────────────────────────────────
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
              // Left — balance
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Eco-Rewards Balance',
                        style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('1,850',
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(width: 8),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                    const Text('Points',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              // Right — gift illustration
              SizedBox(
                width: 90,
                height: 80,
                child: Stack(
                  children: [
                    const Positioned(
                        right: 0, bottom: 0,
                        child: Text('🎁', style: TextStyle(fontSize: 55))),
                    const Positioned(
                        left: 0, bottom: 10,
                        child: Text('🪙', style: TextStyle(fontSize: 22))),
                    const Positioned(
                        top: 0, right: 10,
                        child: Text('✦', style: TextStyle(fontSize: 10, color: Color(0xFFFFD700)))),
                    const Positioned(
                        top: 8, left: 10,
                        child: Text('✦', style: TextStyle(fontSize: 8, color: Color(0xFF4CAF50)))),
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
                Text('Keep earning points and unlock exciting rewards!',
                    style: TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final selected = _selectedTab == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                margin: const EdgeInsets.only(right: 24),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? primaryGreen : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    color: selected ? primaryGreen : Colors.grey,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Daily Tasks Section ───────────────────────────────────────────────────
  Widget _buildDailyTasksSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Text('Daily Tasks',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Spacer(),
              const Icon(Icons.access_time_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              const Text('Resets in 14h 25m',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(height: 16),
          // Tasks
          ...List.generate(_dailyTasks.length, (i) {
            final task = _dailyTasks[i];
            return _TaskRow(task: task);
          }),
        ],
      ),
    );
  }

  // ── Streak Card ───────────────────────────────────────────────────────────
  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE8A0)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Daily Streak: 5 Days',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  'Complete daily tasks to maintain your streak!',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (i) {
                final active = i < 5;
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: active ? primaryGreen : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active ? primaryGreen : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Achievements Section ──────────────────────────────────────────────────
  Widget _buildAchievementsSection() {
    return Column(
      children: [
        Row(
          children: [
            const Text('Achievements',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Spacer(),
            const Text('View All',
                style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.w600)),
            const Icon(Icons.chevron_right, size: 16, color: primaryGreen),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: _achievements.map((a) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(a['emoji'] as String, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 6),
                    Text(a['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(a['sub'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 9, color: Colors.grey)),
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
                      child: Text(a['progressLabel'] as String,
                          style: const TextStyle(fontSize: 9, color: Colors.grey)),
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

  // ── Bottom Banner ─────────────────────────────────────────────────────────
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
                Text('More actions, more impact!',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 2),
                Text('Every action you take brings us closer\nto a greener planet.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            child: const Row(
              children: [
                Text('Explore Rewards',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, size: 16,color: Colors.white ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Nav Bar ────────────────────────────────────────────────────────
}

// ── Task Row Widget ───────────────────────────────────────────────────────────
class _TaskRow extends StatelessWidget {
  final Map<String, dynamic> task;
  static const Color primaryGreen = Color(0xFF1B6B2F);

  const _TaskRow({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(task['icon'] as IconData, color: primaryGreen, size: 20),
          ),
          const SizedBox(width: 10),
          // Title + sub
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'] as String,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(task['sub'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Points badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFBBE5C8)),
            ),
            child: Row(
              children: [
                Text(task['points'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryGreen)),
                const SizedBox(width: 2),
                const Icon(Icons.check_circle, color: primaryGreen, size: 12),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Action button or progress
          if (task['actionType'] == 'claim')
            SizedBox(
              width: 70,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Claim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            )
          else if (task['actionType'] == 'go')
            SizedBox(
              width: 60,
              height: 34,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryGreen,
                  side: const BorderSide(color: primaryGreen),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(task['action'] as String,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            )
          else if (task['actionType'] == 'progress')
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(task['progressLabel'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task['progress'] as double,
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
}
