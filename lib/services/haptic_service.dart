import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../models/breathing_pattern.dart';

class HapticService {
  static bool _hasCustomVibrations = false;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      final hasVibrator = await Vibration.hasVibrator();
      final hasCustom = await Vibration.hasCustomVibrationsSupport();
      _hasCustomVibrations = (hasVibrator == true) && (hasCustom == true);
      _initialized = true;
    } catch (_) {
      _hasCustomVibrations = false;
      _initialized = true;
    }
  }

  static Future<void> triggerPhaseTransition(BreathPhase phase) async {
    if (!_initialized) await init();

    try {
      switch (phase.type) {
        case BreathPhaseType.inhale:
          // Micro-tick ramp-up for Realme P2 Pro X-axis linear motor
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 40, 80, 50, 100, 60, 120, 80],
              intensities: [0, 64, 0, 128, 0, 192, 0, 255],
            );
          } else {
            await HapticFeedback.mediumImpact();
          }
          break;

        case BreathPhaseType.holdIn:
          // Rhythmic heartbeat bump
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 50, 100, 70],
              intensities: [0, 180, 0, 220],
            );
          } else {
            await HapticFeedback.heavyImpact();
          }
          break;

        case BreathPhaseType.exhale:
          // Smooth descending hum
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 120, 80, 80, 120, 40],
              intensities: [0, 220, 0, 140, 0, 70],
            );
          } else {
            await HapticFeedback.lightImpact();
          }
          break;

        case BreathPhaseType.holdOut:
          // Pure stillness - micro gentle click to acknowledge stillness
          await HapticFeedback.selectionClick();
          break;
      }
    } catch (_) {
      // Fallback to standard platform haptic feedback
      HapticFeedback.selectionClick();
    }
  }

  static Future<void> triggerTap() async {
    HapticFeedback.lightImpact();
  }
}
