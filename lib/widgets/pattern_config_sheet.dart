import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';

class PatternConfigSheet extends StatefulWidget {
  final BreathingPattern initialPattern;
  final Function(BreathingPattern) onSelect;

  const PatternConfigSheet({
    super.key,
    required this.initialPattern,
    required this.onSelect,
  });

  @override
  State<PatternConfigSheet> createState() => _PatternConfigSheetState();
}

class _PatternConfigSheetState extends State<PatternConfigSheet> {
  late String _selectedId;

  // Custom configuration sliders
  int _inhale = 4;
  int _holdIn = 4;
  int _exhale = 4;
  int _holdOut = 4;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialPattern.id;
  }

  void _applyCustomPattern() {
    final custom = BreathingPattern(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Custom Rhythm',
      subtitle: '${_inhale}s - ${_holdIn}s - ${_exhale}s - ${_holdOut}s',
      defaultCycles: 10,
      phases: [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Inhale',
          durationSeconds: _inhale,
          hapticDescription: 'Micro-tick ramp up',
          startColor: const Color(0xFF00F2FE),
          endColor: const Color(0xFF4FACFE),
        ),
        if (_holdIn > 0)
          BreathPhase(
            type: BreathPhaseType.holdIn,
            label: 'Hold (Full)',
            durationSeconds: _holdIn,
            hapticDescription: 'Soft rhythmic pulse',
            startColor: const Color(0xFF4FACFE),
            endColor: const Color(0xFF8E2DE2),
          ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale',
          durationSeconds: _exhale,
          hapticDescription: 'Smooth descending hum',
          startColor: const Color(0xFF8E2DE2),
          endColor: const Color(0xFF4A00E0),
        ),
        if (_holdOut > 0)
          BreathPhase(
            type: BreathPhaseType.holdOut,
            label: 'Hold (Empty)',
            durationSeconds: _holdOut,
            hapticDescription: 'Pure stillness',
            startColor: const Color(0xFF4A00E0),
            endColor: const Color(0xFF00F2FE),
          ),
      ],
    );
    widget.onSelect(custom);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF0E0E14),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Breathing Patterns',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // Presets list
              ...BreathingPattern.defaultPatterns.map((pattern) {
                final isSelected = pattern.id == _selectedId;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF13151F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF00F2FE) : Colors.white10,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      pattern.title,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF00F2FE) : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      pattern.subtitle,
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF00F2FE))
                        : null,
                    onTap: () {
                      setState(() => _selectedId = pattern.id);
                      widget.onSelect(pattern);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }),

              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 12),
              const Text(
                'Custom Phase Timers (Seconds)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              _buildSlider('Inhale', _inhale, (val) => setState(() => _inhale = val)),
              _buildSlider('Hold (In)', _holdIn, (val) => setState(() => _holdIn = val)),
              _buildSlider('Exhale', _exhale, (val) => setState(() => _exhale = val)),
              _buildSlider('Hold (Out)', _holdOut, (val) => setState(() => _holdOut = val)),

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
                  onPressed: _applyCustomPattern,
                  child: const Text(
                    'Apply Custom Pattern',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 12,
            divisions: 12,
            activeColor: const Color(0xFF00F2FE),
            inactiveColor: Colors.white12,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            '${value}s',
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
