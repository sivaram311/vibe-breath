import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';

class PranayamaConfigSheet extends StatefulWidget {
  final BreathingPattern initialPattern;
  final int totalCycles;
  final Function(BreathingPattern, int cycles) onSave;

  const PranayamaConfigSheet({
    super.key,
    required this.initialPattern,
    required this.totalCycles,
    required this.onSave,
  });

  @override
  State<PranayamaConfigSheet> createState() => _PranayamaConfigSheetState();
}

class _PranayamaConfigSheetState extends State<PranayamaConfigSheet> {
  late String _selectedId;
  late int _cycles;

  // Custom 4-phase timer durations
  int _inhale = 4;
  int _holdIn = 4;
  int _exhale = 4;
  int _holdOut = 4;

  // 4 Default Haptic Pattern Selections
  HapticPatternType _inhaleHaptic = HapticPatternType.rampUp;
  HapticPatternType _holdInHaptic = HapticPatternType.heartbeat;
  HapticPatternType _exhaleHaptic = HapticPatternType.rampDown;
  HapticPatternType _holdOutHaptic = HapticPatternType.stillness;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialPattern.id;
    _cycles = widget.totalCycles;
  }

  void _applyCustomRhythm() {
    final customPattern = BreathingPattern(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Custom Pranayama',
      sanskritTitle: 'स्वेच्छा प्राणायाम',
      subtitle: '${_inhale}s In • ${_holdIn}s Hold • ${_exhale}s Out • ${_holdOut}s Hold',
      defaultCycles: _cycles,
      phases: [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Puraka (Inhale)',
          sanskritLabel: 'पूरक',
          durationSeconds: _inhale,
          hapticType: _inhaleHaptic,
          hapticDescription: _getHapticTitle(_inhaleHaptic),
          startColor: const Color(0xFF00F2FE),
          endColor: const Color(0xFF4FACFE),
        ),
        if (_holdIn > 0)
          BreathPhase(
            type: BreathPhaseType.holdIn,
            label: 'Antar Kumbhaka',
            sanskritLabel: 'आन्तर कुम्भक',
            durationSeconds: _holdIn,
            hapticType: _holdInHaptic,
            hapticDescription: _getHapticTitle(_holdInHaptic),
            startColor: const Color(0xFF4FACFE),
            endColor: const Color(0xFF8E2DE2),
          ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Rechaka (Exhale)',
          sanskritLabel: 'रेचक',
          durationSeconds: _exhale,
          hapticType: _exhaleHaptic,
          hapticDescription: _getHapticTitle(_exhaleHaptic),
          startColor: const Color(0xFF8E2DE2),
          endColor: const Color(0xFF4A00E0),
        ),
        if (_holdOut > 0)
          BreathPhase(
            type: BreathPhaseType.holdOut,
            label: 'Bahya Kumbhaka',
            sanskritLabel: 'बाह्य कुम्भक',
            durationSeconds: _holdOut,
            hapticType: _holdOutHaptic,
            hapticDescription: _getHapticTitle(_holdOutHaptic),
            startColor: const Color(0xFF4A00E0),
            endColor: const Color(0xFF00F2FE),
          ),
      ],
    );

    widget.onSave(customPattern, _cycles);
    Navigator.of(context).pop();
  }

  String _getHapticTitle(HapticPatternType type) {
    switch (type) {
      case HapticPatternType.rampUp:
        return 'Micro-tick Ramp (Inhale)';
      case HapticPatternType.heartbeat:
        return 'Heartbeat Pulse (Hold In)';
      case HapticPatternType.rampDown:
        return 'Descending Hum (Exhale)';
      case HapticPatternType.stillness:
        return 'Grounding Stillness (Hold Out)';
      case HapticPatternType.continuousHum:
        return 'Continuous Bhramari Hum';
      case HapticPatternType.rapidPulse:
        return 'Kapalabhati Quick Fire';
      case HapticPatternType.none:
        return 'No Vibration';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF0C0D14),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet handle
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Vedic Pranayama & Patterns',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select traditional practice or customize 4-phase rhythm & haptics',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Cycles selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF161824),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Session Cycles:',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF00F2FE)),
                          onPressed: () {
                            if (_cycles > 1) setState(() => _cycles--);
                          },
                        ),
                        Text(
                          '$_cycles',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00F2FE)),
                          onPressed: () {
                            if (_cycles < 108) setState(() => _cycles++);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Presets List
              ...BreathingPattern.defaultPatterns.map((pattern) {
                final isSelected = pattern.id == _selectedId;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E2638) : const Color(0xFF12141F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00F2FE) : Colors.white10,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Row(
                      children: [
                        Text(
                          pattern.title,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF00F2FE) : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (pattern.sanskritTitle.isNotEmpty)
                          Text(
                            pattern.sanskritTitle,
                            style: TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      pattern.subtitle,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF00F2FE))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedId = pattern.id;
                        _cycles = pattern.defaultCycles;
                      });
                      widget.onSave(pattern, _cycles);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),

              const SizedBox(height: 18),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),

              const Text(
                'Custom 4-Phase Builder & Haptics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              _buildPhaseCard('Inhale (Puraka)', _inhale, _inhaleHaptic,
                  (d) => setState(() => _inhale = d),
                  (h) => setState(() => _inhaleHaptic = h)),

              _buildPhaseCard('Hold Full (Antar Kumbhaka)', _holdIn, _holdInHaptic,
                  (d) => setState(() => _holdIn = d),
                  (h) => setState(() => _holdInHaptic = h)),

              _buildPhaseCard('Exhale (Rechaka)', _exhale, _exhaleHaptic,
                  (d) => setState(() => _exhale = d),
                  (h) => setState(() => _exhaleHaptic = h)),

              _buildPhaseCard('Hold Empty (Bahya Kumbhaka)', _holdOut, _holdOutHaptic,
                  (d) => setState(() => _holdOut = d),
                  (h) => setState(() => _holdOutHaptic = h)),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00F2FE),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _applyCustomRhythm,
                  child: const Text(
                    'Apply Custom Pranayama Rhythm',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseCard(
    String title,
    int duration,
    HapticPatternType haptic,
    ValueChanged<int> onDurationChanged,
    ValueChanged<HapticPatternType> onHapticChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF131520),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              Text('${duration}s', style: const TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: duration.toDouble(),
            min: 0,
            max: 30,
            divisions: 30,
            activeColor: const Color(0xFF00F2FE),
            inactiveColor: Colors.white12,
            onChanged: (v) => onDurationChanged(v.round()),
          ),
          DropdownButton<HapticPatternType>(
            value: haptic,
            isDense: true,
            isExpanded: true,
            dropdownColor: const Color(0xFF1C1E2E),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            items: HapticPatternType.values.map((t) {
              return DropdownMenuItem(
                value: t,
                child: Text('Vibration: ${_getHapticTitle(t)}'),
              );
            }).toList(),
            onChanged: (newHaptic) {
              if (newHaptic != null) onHapticChanged(newHaptic);
            },
          ),
        ],
      ),
    );
  }
}
