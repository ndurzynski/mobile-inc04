import 'package:flutter/material.dart';

void main() {
  runApp(const ViralContentApp());
}

// ============================================================
// APP
// ============================================================

class ViralContentApp extends StatefulWidget {
  const ViralContentApp({super.key});

  @override
  State<ViralContentApp> createState() => _ViralContentAppState();
}

class _ViralContentAppState extends State<ViralContentApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viral Content Studio',

      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),

      home: ViralStudioScreen(
        isDark: isDarkMode,

        // Theme switcher
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

// ============================================================
// STATEFUL SCREEN
// ============================================================

class ViralStudioScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ViralStudioScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ViralStudioScreen> createState() => _ViralStudioScreenState();
}

class _ViralStudioScreenState extends State<ViralStudioScreen> {
  // Required state variables from assignment
  int likes = 0;
  int comments = 0;
  int shares = 0;
  int saves = 0;
  int streak = 0;
  bool isTrending = false;

  // Calculate total engagement points
  int get totalEngagement {
    return likes + (comments * 2) + (shares * 3) + (saves * 2);
  }

  // ==========================================================
  // PERFORM ACTION
  // ==========================================================

  void _addEngagement(String type) {
    setState(() {
      if (type == "Like") {
        likes++;
      } else if (type == "Comment") {
        comments++;
      } else if (type == "Share") {
        shares++;
      } else if (type == "Save") {
        saves++;
      }

      // Increase streak
      streak++;

      // Unlock Trending at 20 points
      if (totalEngagement >= 20) {
        isTrending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Background changes when Trending is unlocked
    final backgroundColor = isTrending
        ? Colors.orange.shade100
        : (widget.isDark ? const Color(0xFF1E1F29) : const Color(0xFFF4F4F4));

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        title: const Text(
          "VIRAL CONTENT STUDIO",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          // CHECKPOINT #5
          // Light / Dark theme switcher
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==================================================
            // CHECKPOINT #1
            // StatelessWidget #1
            // ==================================================

            const StudioTitle(),

            const SizedBox(height: 20),

            // ==================================================
            // TRENDING MESSAGE
            // ==================================================
            if (isTrending) const TrendingBanner(),

            const SizedBox(height: 15),

            // ==================================================
            // POST CARD
            // ==================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: widget.isDark ? const Color(0xFF282A36) : Colors.white,

                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                children: [
                  const Icon(
                    Icons.video_library,
                    size: 70,
                    color: Colors.purple,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "My New Viral Post 🎬",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Trying to reach 20 engagement points!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CHECKPOINT #2
            // Custom StatefulWidget
            // ==================================================
            EngagementMeter(score: totalEngagement, isTrending: isTrending),

            const SizedBox(height: 20),

            // ==================================================
            // CHECKPOINT #1
            // StatelessWidget #2
            // ==================================================
            MetricsBadge(
              likes: likes,
              comments: comments,
              shares: shares,
              saves: saves,
              streak: streak,
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CHECKPOINT #3 + #6
            // Interactive buttons + GestureDetector
            // ==================================================
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,

              children: [
                EngagementButton(
                  icon: Icons.favorite,
                  label: "LIKE +1",
                  color: Colors.red,
                  onPressed: () {
                    _addEngagement("Like");
                  },
                ),

                EngagementButton(
                  icon: Icons.comment,
                  label: "COMMENT +2",
                  color: Colors.blue,
                  onPressed: () {
                    _addEngagement("Comment");
                  },
                ),

                EngagementButton(
                  icon: Icons.share,
                  label: "SHARE +3",
                  color: Colors.green,
                  onPressed: () {
                    _addEngagement("Share");
                  },
                ),

                EngagementButton(
                  icon: Icons.bookmark,
                  label: "SAVE +2",
                  color: Colors.orange,
                  onPressed: () {
                    _addEngagement("Save");
                  },
                ),
              ],
            ),

            const SizedBox(height: 25),

            Text(
              "Engagement Points: $totalEngagement / 20",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            // Reset button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  likes = 0;
                  comments = 0;
                  shares = 0;
                  saves = 0;
                  streak = 0;
                  isTrending = false;
                });
              },

              icon: const Icon(Icons.refresh),
              label: const Text("RESET"),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CHECKPOINT #1 — STATELESS WIDGET #1
// ============================================================

class StudioTitle extends StatelessWidget {
  const StudioTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("📱", style: TextStyle(fontSize: 40)),

        Text(
          "Viral Content Studio",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        Text("Make your post go viral!", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// ============================================================
// CHECKPOINT #1 — STATELESS WIDGET #2
// ============================================================

class MetricsBadge extends StatelessWidget {
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final int streak;

  const MetricsBadge({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.saves,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const Text(
              "POST METRICS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                Text("❤️ $likes"),
                Text("💬 $comments"),
                Text("🔄 $shares"),
                Text("🔖 $saves"),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "🔥 Streak: $streak",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CHECKPOINT #2 — CUSTOM STATEFUL WIDGET
// ============================================================

class EngagementMeter extends StatefulWidget {
  final int score;
  final bool isTrending;

  const EngagementMeter({
    super.key,
    required this.score,
    required this.isTrending,
  });

  @override
  State<EngagementMeter> createState() => _EngagementMeterState();
}

class _EngagementMeterState extends State<EngagementMeter> {
  @override
  Widget build(BuildContext context) {
    double progress = widget.score / 20;

    if (progress > 1) {
      progress = 1;
    }

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 15,

          color: widget.isTrending ? Colors.orange : Colors.purple,

          backgroundColor: Colors.grey.shade300,
        ),

        const SizedBox(height: 8),

        Text(
          "${(progress * 100).toInt()}% to Trending",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================
// CHECKPOINT #3 + #6
// BUTTON WITH GESTUREDETECTOR
// ============================================================

class EngagementButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const EngagementButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<EngagementButton> createState() => _EngagementButtonState();
}

class _EngagementButtonState extends State<EngagementButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // CHECKPOINT #6
      // GestureDetector gives tactile response.
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },

      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        // Perform the actual action
        widget.onPressed();
      },

      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        transform: Matrix4.identity()..scale(isPressed ? 0.92 : 1.0),

        decoration: BoxDecoration(
          color: widget.color.withOpacity(isPressed ? 0.7 : 1.0),

          borderRadius: BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isPressed ? 0.05 : 0.2),
              blurRadius: isPressed ? 2 : 8,
              offset: isPressed ? const Offset(1, 1) : const Offset(3, 3),
            ),
          ],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(widget.icon, color: Colors.white),

            const SizedBox(width: 6),

            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TRENDING BANNER
// ============================================================

class TrendingBanner extends StatelessWidget {
  const TrendingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(15),
      ),

      child: const Text(
        "🔥 TRENDING 🔥",
        textAlign: TextAlign.center,

        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
