import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/mood_log.dart';
import 'package:menstrual_tracking_app/utils/button_style.dart';
import 'package:menstrual_tracking_app/utils/log_header.dart';

class MoodLogCard extends StatefulWidget {
  final List<Mood> moodList;
  final ValueChanged<List<Mood>> onMoodChanged;
  const MoodLogCard({
    super.key,
    required this.moodList,
    required this.onMoodChanged,
  });

  @override
  State<MoodLogCard> createState() => _MoodLogCardState();
}

class _MoodLogCardState extends State<MoodLogCard> {
  late List<Mood> selectedMoods;

  @override
  void initState() {
    super.initState();
    selectedMoods = List.from(widget.moodList);
  }

  void onToggleMood(Mood mood) {
    setState(() {
      if (selectedMoods.contains(mood)) {
        selectedMoods.remove(mood);
      } else {
        selectedMoods.add(mood);
      }
    });

    widget.onMoodChanged(selectedMoods);
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
            const LogHeader(title: 'Mood Log', description: 'Track your mood'),
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
                  const Text(
                    "How are you feeling today?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: Mood.values.length,
                    itemBuilder: (context, index) {
                      final mood = Mood.values[index];

                      return MoodButton(
                        mood: mood,
                        isSelected: selectedMoods.contains(mood),
                        onTap: () => onToggleMood(mood),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodButton extends StatelessWidget {
  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodButton({
    super.key,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: AppStyle.selectedButtonStyle(
        colorTheme: ColorTheme.blue,
        isSelected: isSelected,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 38)),
          Text(
            mood.label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
