import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:menstrual_tracking_app/utils/button_style.dart';
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
  late Map<Symptom, Intensity> selectedSymptoms = {};

  void onToggleIntensity(Intensity intensity) {}

  void onToggleSymptom(Symptom symptom) {
    setState(() {
      if (selectedSymptoms.containsKey(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms[symptom] = Intensity.mild;
      }
    });
    widget.onSymptomChanged(selectedSymptoms);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogHeader(
              title: 'Symptoms Log',
              description: 'Select sypmtoms (Optional):',
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Symptom Selector
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1.5,
                        ),
                    itemCount: Symptom.values.length,
                    itemBuilder: (context, index) {
                      final symptom = Symptom.values[index];

                      return SymptomButton(
                        symptom: symptom,
                        isSelected: selectedSymptoms.containsKey(symptom),
                        onPressed: () => onToggleSymptom(symptom),
                      );
                    },
                  ),

                  // Intensity Selectors
                  if (selectedSymptoms.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    Text(
                      "Set Intensity for Each Symptom:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedSymptoms.length,
                      itemBuilder: (context, index) {
                        final symptom = selectedSymptoms.keys.elementAt(index);
                        final intensity = selectedSymptoms[symptom]!;

                        return IntensityButton(
                          key: ValueKey(symptom),
                          selectedSymptom: symptom,
                          selectedIntensity: intensity,
                          onIntensityChanged: (newIntensity) {
                            setState(() {
                              selectedSymptoms[symptom] = newIntensity;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntensityButton extends StatelessWidget {
  final Symptom selectedSymptom;
  final Intensity selectedIntensity;
  final ValueChanged<Intensity> onIntensityChanged;

  const IntensityButton({
    super.key,
    required this.selectedSymptom,
    required this.selectedIntensity,
    required this.onIntensityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${selectedSymptom.label}:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Row(
          spacing: 5,
          children: Intensity.values.map((i) {
            final isSelected = selectedIntensity == i;

            return TextButton(
              style: AppStyle.selectedButtonStyle(
                colorTheme: ColorTheme.orange,
                isSelected: isSelected,
              ),
              onPressed: () => onIntensityChanged(i),
              child: Text(i.name.toUpperCase(), style: TextStyle(fontSize: 12)),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
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
    return TextButton(
      onPressed: onPressed,
      style: AppStyle.selectedButtonStyle(
        colorTheme: ColorTheme.blue,
        isSelected: isSelected,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            symptom.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
