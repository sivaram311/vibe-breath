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
      switch (phase.hapticType) {
        case HapticPatternType.rampUp:
          // Micro-tick ramp-up for Inhale (Puraka)
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 40, 80, 50, 100, 60, 120, 80],
              intensities: [0, 64, 0, 128, 0, 192, 0, 255],
            );
          } else {
            await HapticFeedback.mediumImpact();
          }
          break;

        case HapticPatternType.heartbeat:
          // Rhythmic heartbeat bump for Hold (Antar Kumbhaka)
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 60, 100, 80],
              intensities: [0, 190, 0, 240],
            );
          } else {
            await HapticFeedback.heavyImpact();
          }
          break;

        case HapticPatternType.rampDown:
          // Smooth descending hum for Exhale (Rechaka)
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 120, 80, 80, 120, 40],
              intensities: [0, 240, 0, 150, 0, 70],
            );
          } else {
            await HapticFeedback.lightImpact();
          }
          break;

        case HapticPatternType.stillness:
          // Grounding root pulse followed by absolute silence (Bahya Kumbhaka)
          await HapticFeedback.selectionClick();
          break;

        case HapticPatternType.continuousHum:
          // Bhramari Humming Bee: Sustained low resonant vibration
          if (_hasCustomVibrations) {
            await Vibration.vibrate(
              pattern: [0, 600, 100, 600, 100, 600],
              intensities: [0, 120, 0, 140, 0, 120],
            );
          } else {
            await HapticFeedback.mediumImpact();
          }
          break;

        case HapticPatternType.rapidPulse:
          // Kapalabhati quick burst
          if (_hasCustomVibrations) {
            await Vibration.vibrate(duration: 50, amplitude: 255);
          } else {
            await HapticFeedback.heavyImpact();
          }
          break;

        case HapticPatternType.none:
          break;
      }
    } catch (_) {
      HapticFeedback.selectionClick();
    }
  }

  static Future<void> triggerTap() async {
    HapticFeedback.lightImpact();
  }
}
