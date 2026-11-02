import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'models/breathing_pattern.dart';
import 'services/haptic_service.dart';
import 'widgets/breathing_orb.dart';
import 'widgets/pattern_config_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge transparent navigation bar for AMOLED flagships
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await HapticService.init();

  runApp(const VibeBreathApp());
}

class VibeBreathApp extends StatelessWidget {
  const VibeBreathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibe Breath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000), // Pure AMOLED True Black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F2FE),
          secondary: Color(0xFF8E2DE2),
          surface: Color(0xFF000000),
        ),
      ),
      home: const BreathingSessionScreen(),
    );
  }
}

class BreathingSessionScreen extends StatefulWidget {
  const BreathingSessionScreen({super.key});

  @override
  State<BreathingSessionScreen> createState() => _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends State<BreathingSessionScreen>
    with SingleTickerProviderStateMixin {
  BreathingPattern _pattern = BreathingPattern.defaultPatterns.first;

  int _currentPhaseIndex = 0;
  int _secondsRemainingInPhase = 4;
  int _completedCycles = 0;
  bool _isPlaying = false;

  Timer? _tickerTimer;
  late AnimationController _phaseAnimController;

  BreathPhase get currentPhase => _pattern.phases[_currentPhaseIndex];

  @override
  void initState() {
    super.initState();
    _secondsRemainingInPhase = currentPhase.durationSeconds;

    _phaseAnimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: currentPhase.durationSeconds),
    );

    // Keep AMOLED screen on during meditation sessions
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _phaseAnimController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _togglePlayPause() {
    HapticService.triggerTap();
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _startTicking();
      _phaseAnimController.forward(from: _phaseAnimController.value);
    } else {
      _tickerTimer?.cancel();
      _phaseAnimController.stop();
    }
  }

  void _startTicking() {
    _tickerTimer?.cancel();
    HapticService.triggerPhaseTransition(currentPhase);

    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (_secondsRemainingInPhase > 1) {
          _secondsRemainingInPhase--;
        } else {
          _advanceToNextPhase();
        }
      });
    });
  }

  void _advanceToNextPhase() {
    int nextIndex = _currentPhaseIndex + 1;
    if (nextIndex >= _pattern.phases.length) {
      nextIndex = 0;
      _completedCycles++;
    }

    _currentPhaseIndex = nextIndex;
    _secondsRemainingInPhase = currentPhase.durationSeconds;

    _phaseAnimController.duration = Duration(seconds: currentPhase.durationSeconds);
    _phaseAnimController.forward(from: 0.0);

    // Fire tactile haptic sensation for new phase
    HapticService.triggerPhaseTransition(currentPhase);
  }

  void _selectPattern(BreathingPattern pattern) {
    setState(() {
      _pattern = pattern;
      _currentPhaseIndex = 0;
      _secondsRemainingInPhase = pattern.phases.first.durationSeconds;
      _completedCycles = 0;
      _isPlaying = false;
      _tickerTimer?.cancel();
      _phaseAnimController.reset();
    });
  }

  void _openConfigSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PatternConfigSheet(
        initialPattern: _pattern,
        onSelect: _selectPattern,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Pure AMOLED Black
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Session Header
              Column(
                children: [
                  GestureDetector(
                    onTap: _openConfigSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _pattern.title.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_drop_down, color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _pattern.subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),

              // Concentric Breathing Visualizer
              AnimatedBuilder(
                animation: _phaseAnimController,
                builder: (context, child) {
                  return BreathingOrb(
                    currentPhase: currentPhase,
                    animationProgress: _isPlaying ? _phaseAnimController.value : 0.0,
                    secondsRemaining: _secondsRemainingInPhase,
                  );
                },
              ),

              // Bottom Control Dock
              Column(
                children: [
                  // Haptic vibration feedback badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F2FE).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.vibration, color: Color(0xFF00F2FE), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          currentPhase.hapticDescription,
                          style: const TextStyle(
                            color: Color(0xFF00F2FE),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Frosted Floating Pill Dock
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12141C),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F2FE).withValues(alpha: 0.08),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cycle Counter
                        Text(
                          'Cycle ${_completedCycles + 1} / ${_pattern.defaultCycles}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Play / Pause Action Button
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00F2FE).withValues(alpha: 0.4),
                                  blurRadius: 16,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.black,
                              size: 32,
                            ),
                          ),
                        ),

                        // Configuration Quick Trigger
                        IconButton(
                          icon: const Icon(Icons.tune_rounded, color: Colors.white60),
                          onPressed: _openConfigSheet,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
