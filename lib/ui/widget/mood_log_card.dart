import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

class _MoodLogCardState extends State<MoodLogCard>
    with AutomaticKeepAliveClientMixin {
  late final ValueNotifier<Set<Mood>> _selectedMoods;

  @override
  void initState() {
    super.initState();
    _selectedMoods = ValueNotifier(widget.moodList.toSet());
  }

  @override
  bool get wantKeepAlive => true;

  void _toggleMood(Mood mood) {
    final current = _selectedMoods.value;

    if (current.contains(mood)) {
      current.remove(mood);
    } else {
      current.add(mood);
    }

    _selectedMoods.value = {...current};
    widget.onMoodChanged(_selectedMoods.value.toList());
  }

  @override
  void dispose() {
    _selectedMoods.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MoodLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent passed a different initial mood list, synchronize
    final oldSet = oldWidget.moodList.toSet();
    final newSet = widget.moodList.toSet();
    if (!setEquals(oldSet, newSet)) {
      _selectedMoods.value = newSet;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // keep state alive when scrolling
    return RepaintBoundary(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogHeader(
                title: 'Mood Log',
                description: 'Track your mood',
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "How are you feeling today?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Use Wrap instead of GridView to avoid expensive shrinkWrap layout
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return ValueListenableBuilder<Set<Mood>>(
                          valueListenable: _selectedMoods,
                          builder: (_, selected, _) {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: Mood.values.map((mood) {
                                return SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: MoodButton(
                                    mood: mood,
                                    isSelected: selected.contains(mood),
                                    onTap: () => _toggleMood(mood),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 6),
          Text(
            mood.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
