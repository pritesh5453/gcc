import 'package:flutter/material.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart';

class ReferralGrowthScreen extends StatelessWidget {
  const ReferralGrowthScreen({super.key});

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
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        _buildInviteDetailsCard(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildRewardBoostCard()),
                            const SizedBox(width: 15),
                            Expanded(child: _buildNetworkImpactCard()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildMonthlyAverageCard(),
                        const SizedBox(height: 25),
                        _buildInstructionsButton(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Invite Details Card ──────────────────────────────────────────────────
  Widget _buildInviteDetailsCard() {
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
                    const Row(
                      children: [
                        Text(
                          "GCC123",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.copy, color: Colors.green, size: 20),
                      ],
                    ),
                    const Text.rich(
                      TextSpan(
                        text: "Total Invites: ",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        children: [
                          TextSpan(
                            text: "12",
                            style: TextStyle(
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
              const Text(
                "₹1.8 Cr",
                style: TextStyle(
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
  Widget _buildRewardBoostCard() {
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
              const Text(
                "1.25x",
                style: TextStyle(
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
  Widget _buildNetworkImpactCard() {
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
          _networkRow(Icons.person_outline, "Total Referrals", "12"),
          const SizedBox(height: 8),
          _networkRow(Icons.check_circle_outline, "Active Contrib.", "8"),
        ],
      ),
    );
  }

  // ─── Monthly Average Card ──────────────────────────────────────────────
  Widget _buildMonthlyAverageCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                "Monthly Average",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statColumn("Monthly Average", "₹15,000"),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade200,
              ),
              _statColumn("This Month", "₹18,200"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B6B2F),
          ),
        ),
      ],
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

  // ─── Instructions Button ──────────────────────────────────────────────────
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

  // ─── Enhanced Instruction Popup ──────────────────────────────────────────
  void _showInstructionsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 8,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header with gradient background ──
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
                      Icon(Icons.lightbulb_outline,
                          color: Colors.white, size: 28),
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

                // ── Instruction Steps ──
                _instructionStep("1", "Share your unique referral code with friends."),
                _instructionStep("2", "Earn rewards when your referrals make their first contribution."),
                _instructionStep("3", "Unlock higher reward multipliers as your network grows."),
                _instructionStep("4", "Track your monthly average to stay on top."),
                _instructionStep("5", "For any queries, contact our support team."),

                const SizedBox(height: 24),

                // ── Close Button ──
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
          ),
        );
      },
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
}