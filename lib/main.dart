import 'package:flutter/material.dart';

void main() {
  runApp(const TactileDeckApp());
}

class TactileDeckApp extends StatefulWidget {
  const TactileDeckApp({super.key});

  @override
  State<TactileDeckApp> createState() => _TactileDeckAppState();
}

class _TactileDeckAppState extends State<TactileDeckApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber-Tactile Control Studio',
      debugShowCheckedModeBanner: false,

      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),

      home: ControlDeckScreen(
        isDark: isDarkMode,
        onToggleTheme: () => setState(() {
          isDarkMode = !isDarkMode;
        }),
      ),
    );
  }
}

class ControlDeckScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const ControlDeckScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ControlDeckScreen> createState() => _ControlDeckScreenState();
}

class _ControlDeckScreenState extends State<ControlDeckScreen> {
  int totalTaps = 0;
  double powerLevel = 65.0;
  String systemStatus = "READY";

  // BUG #1 FIX:
  // Removed the shared "isPressed" variable from here.
  //
  // Before:
  // bool isPressed = false;
  //
  // This was wrong because all 4 buttons used the same variable.
  // Now each button has its own isPressed variable below.

  void _triggerAction(String actionName) {
    setState(() {
      totalTaps++;
      systemStatus = "$actionName ACTIVATED";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenBg = widget.isDark
        ? const Color(0xFF1E1F29)
        : const Color(0xFFE0E5EC);

    final cardBg = widget.isDark ? const Color(0xFF282A36) : Colors.white;

    return Scaffold(
      backgroundColor: screenBg,

      appBar: AppBar(
        title: const Text(
          "TACTILE CONTROL STUDIO",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Column(
                    children: [
                      const Text(
                        "TOTAL TAPS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "$totalTaps",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey.withOpacity(0.3),
                  ),

                  Column(
                    children: [
                      const Text(
                        "ENERGY LEVEL",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${powerLevel.toInt()}%",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "STATUS: $systemStatus",
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.tealAccent : Colors.teal.shade700,
              ),
            ),

            const SizedBox(height: 28),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,

              children: [
                TactileButton(
                  icon: Icons.flash_on,
                  label: "TURBO",
                  accentColor: Colors.amber,
                  isDark: widget.isDark,

                  // BUG #1 FIX:
                  // Removed:
                  // isPressed: isPressed
                  //
                  // The button now manages its own pressed state.
                  onTapUp: () {
                    _triggerAction("TURBO BOOST");
                  },
                ),

                TactileButton(
                  icon: Icons.shield,
                  label: "SHIELD",
                  accentColor: Colors.tealAccent,
                  isDark: widget.isDark,

                  onTapUp: () {
                    _triggerAction("DEFENSE SHIELD");
                  },
                ),

                TactileButton(
                  icon: Icons.wifi_tethering,
                  label: "RADAR",
                  accentColor: Colors.purpleAccent,
                  isDark: widget.isDark,

                  onTapUp: () {
                    _triggerAction("PULSE RADAR");
                  },
                ),

                TactileButton(
                  icon: Icons.rocket_launch,
                  label: "LAUNCH",
                  accentColor: Colors.redAccent,
                  isDark: widget.isDark,

                  onTapUp: () {
                    _triggerAction("THRUSTER LAUNCH");
                  },
                ),
              ],
            ),

            const SizedBox(height: 36),

            Text(
              "Power Calibration: ${powerLevel.toInt()}%",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),

            Slider(
              value: powerLevel,
              min: 0,
              max: 100,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey.withOpacity(0.3),

              // BUG #2 FIX:
              //
              // BEFORE:
              // onChanged: (newVal) => powerLevel = newVal,
              //
              // The value changed but Flutter did not rebuild
              // the screen.
              //
              // FIX:
              // Use setState() so Flutter rebuilds the UI.
              onChanged: (newVal) {
                setState(() {
                  powerLevel = newVal;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TACTILE BUTTON
// ============================================================
//
// BUG #1 FIX:
// Changed TactileButton from StatelessWidget to StatefulWidget.
//
// Before:
// class TactileButton extends StatelessWidget
//
// Now:
// class TactileButton extends StatefulWidget
//
// This allows every button to have its own isPressed state.

class TactileButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final bool isDark;

  // This callback only tells the parent that the button
  // was released.
  final VoidCallback onTapUp;

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onTapUp,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

// ============================================================
// EACH BUTTON HAS ITS OWN STATE
// ============================================================

class _TactileButtonState extends State<TactileButton> {
  // BUG #1 FIX:
  //
  // isPressed is now inside the individual button.
  //
  // Turbo has its own isPressed.
  // Shield has its own isPressed.
  // Radar has its own isPressed.
  // Launch has its own isPressed.
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);

    final darkShadow = widget.isDark ? Colors.black87 : const Color(0xFFA3B1C6);

    final lightShadow = widget.isDark ? const Color(0xFF2F3244) : Colors.white;

    return GestureDetector(
      // ========================================================
      // BUG #4 FIX — onTapDown
      // ========================================================
      //
      // BEFORE:
      //
      // onTapDown: (_) {
      //   onTapDown();
      //   onTapUp();
      // }
      //
      // The old code called onTapUp immediately.
      //
      // FIX:
      // Only make the button pressed here.

      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },

      // ========================================================
      // BUG #4 FIX — onTapUp
      // ========================================================
      //
      // Release the button when the finger comes up.
      // Then tell the parent to perform the action.
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });

        widget.onTapUp();
      },

      // If the user moves the finger away from the button,
      // make sure it goes back to normal.
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,

        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),

          // ====================================================
          // BUG #3 FIX — Shadow
          // ====================================================
          //
          // BEFORE:
          //
          // Offset(8, 8)
          // Offset(-8, -8)
          //
          // These shadows were too large.
          //
          // FIX:
          // Use smaller offsets: 2, 2.
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.7),

                    // BUG #3 FIX
                    offset: const Offset(2, 2),

                    blurRadius: 4,
                  ),

                  BoxShadow(
                    color: lightShadow.withOpacity(0.9),

                    // BUG #3 FIX
                    offset: const Offset(-2, -2),

                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: darkShadow.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),

                  BoxShadow(
                    color: lightShadow.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(
              widget.icon,

              // Smaller icon when button is pressed.
              size: isPressed ? 40 : 46,

              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark ? Colors.white70 : Colors.black87),
            ),

            const SizedBox(height: 8),

            Text(
              widget.label,

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,

                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
