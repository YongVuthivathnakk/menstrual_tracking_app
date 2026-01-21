import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:menstrual_tracking_app/utils/log_header.dart';

class SymptomLogCard extends StatefulWidget {
  final Map<Symptom, Intensity> symptoms;
  final ValueChanged<Map<Symptom, Intensity>> onSymptomChanged;

  const SymptomLogCard({
    super.key,
    required this.onSymptomChanged,
    required this.symptoms,
  });

  @override
  State<SymptomLogCard> createState() => _SymptomLogCardState();
}

class _SymptomLogCardState extends State<SymptomLogCard> {
  // Use a ValueNotifier so only widgets depending on selection rebuild
  late final ValueNotifier<Map<Symptom, Intensity>> _selectedSymptoms;

  @override
  void initState() {
    super.initState();
    _selectedSymptoms = ValueNotifier(Map.from(widget.symptoms));
  }

  void onToggleSymptom(Symptom symptom) {
    final current = Map<Symptom, Intensity>.from(_selectedSymptoms.value);
    if (current.containsKey(symptom)) {
      current.remove(symptom);
    } else {
      current[symptom] = Intensity.mild;
    }
    _selectedSymptoms.value = Map.unmodifiable(current);
    widget.onSymptomChanged(_selectedSymptoms.value);
  }

  void updateIntensity(Symptom symptom, Intensity intensity) {
    final current = Map<Symptom, Intensity>.from(_selectedSymptoms.value);
    current[symptom] = intensity;
    _selectedSymptoms.value = Map.unmodifiable(current);
    widget.onSymptomChanged(_selectedSymptoms.value);
  }

  @override
  void dispose() {
    _selectedSymptoms.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogHeader(
                title: "Symptom Log",
                description: "How do you feel today?",
              ),
              const SizedBox(height: 20),

              // Symptom Selection Grid
              ValueListenableBuilder<Map<Symptom, Intensity>>(
                valueListenable: _selectedSymptoms,
                builder: (context, selectedMap, _) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: Symptom.values.map((symptom) {
                          final isSelected = selectedMap.containsKey(symptom);
                          return SizedBox(
                            width: 130,
                            height: 50,
                            child: SymptomButton(
                              symptom: symptom,
                              isSelected: isSelected,
                              onPressed: () => onToggleSymptom(symptom),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),

              // Intensity Section
              ValueListenableBuilder<Map<Symptom, Intensity>>(
                valueListenable: _selectedSymptoms,
                builder: (context, selectedMap, _) {
                  if (selectedMap.isEmpty) return const SizedBox.shrink();
                  final entries = selectedMap.entries.toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      const Text(
                        "Set Intensity:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: entries.map((e) {
                          final symptom = e.key;
                          return IntensitySelectorItem(
                            symptom: symptom,
                            notifier: _selectedSymptoms,
                            onIntensityChanged: (val) =>
                                updateIntensity(symptom, val),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntensitySelectorRow extends StatelessWidget {
  final Symptom symptom;
  final Intensity currentIntensity;
  final ValueChanged<Intensity> onIntensityChanged;

  const IntensitySelectorRow({
    super.key,
    required this.symptom,
    required this.currentIntensity,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symptom.label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: Intensity.values.map((intensity) {
              final isSelected = currentIntensity == intensity;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Center(child: Text(intensity.label)),
                    selected: isSelected,
                    onSelected: (_) => onIntensityChanged(intensity),
                    selectedColor: Colors.orange.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.orange.shade900 : Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SymptomButton extends StatelessWidget {
  final Symptom symptom;
  final bool isSelected;
  final VoidCallback onPressed;

  const SymptomButton({
    super.key,
    required this.symptom,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue.shade50 : Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        symptom.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.blue.shade700 : Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class IntensitySelectorItem extends StatelessWidget {
  final Symptom symptom;
  final ValueNotifier<Map<Symptom, Intensity>> notifier;
  final ValueChanged<Intensity> onIntensityChanged;

  const IntensitySelectorItem({
    super.key,
    required this.symptom,
    required this.notifier,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<Symptom, Intensity>>(
      valueListenable: notifier,
      builder: (context, map, _) {
        // If the symptom was removed, return empty
        if (!map.containsKey(symptom)) return const SizedBox.shrink();
        final intensity = map[symptom]!;
        return IntensitySelectorRow(
          symptom: symptom,
          currentIntensity: intensity,
          onIntensityChanged: onIntensityChanged,
        );
      },
    );
  }
}
