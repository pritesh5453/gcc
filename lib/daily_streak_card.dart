import 'package:flutter/material.dart';




class DailyStreakCard extends StatelessWidget {
  const DailyStreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8), // warm cream background
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE8B0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left Section ──────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row: fire + text
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fire emoji
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🔥', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Action Streak',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          'Complete 1 action today & earn 50 Eco-Rewards',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Streak dots + Start Now button
                Row(
                  children: [
                    // Dot 1 — active (green filled)
                    _StreakDot(number: 1, isActive: true),
                    _StreakLine(),
                    _StreakDot(number: 2, isActive: false),
                    _StreakLine(),
                    _StreakDot(number: 3, isActive: false),
                    _StreakLine(),
                    _StreakDot(number: 4, isActive: false),
                    _StreakLine(),
                    _StreakDot(number: 5, isActive: false),
                    const SizedBox(width: 12),

                    // Start Now Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6F0DC),
                        foregroundColor: const Color(0xFF1B6B2F),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Start Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ── Right Section — Gift Box ──────────────────
          _GiftBox(),
        ],
      ),
    );
  }
}

// ── Streak Dot ────────────────────────────────────────────────────────────────
class _StreakDot extends StatelessWidget {
  final int number;
  final bool isActive;

  const _StreakDot({required this.number, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1B6B2F) : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? const Color(0xFF1B6B2F) : const Color(0xFFCCCCCC),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF999999),
          ),
        ),
      ),
    );
  }
}

// ── Connecting line between dots ──────────────────────────────────────────────
class _StreakLine extends StatelessWidget {
  const _StreakLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 1.5,
      color: const Color(0xFFCCCCCC),
    );
  }
}

// ── Gift Box Illustration ─────────────────────────────────────────────────────
class _GiftBox extends StatelessWidget {
  const _GiftBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkle top-right
          const Positioned(
            top: 0,
            right: 0,
            child: Text('✦', style: TextStyle(fontSize: 10, color: Color(0xFFFFCC00))),
          ),
          // Sparkle bottom-left
          const Positioned(
            bottom: 2,
            left: 0,
            child: Text('✦', style: TextStyle(fontSize: 8, color: Color(0xFF4CAF50))),
          ),
          // Gift emoji
          const Center(
            child: Text('🎁', style: TextStyle(fontSize: 46)),
          ),
        ],
      ),
    );
  }
}
