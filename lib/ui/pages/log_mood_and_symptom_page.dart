import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/mood_log.dart';
import 'package:menstrual_tracking_app/model/note_log.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:menstrual_tracking_app/services/menstrual_log_database.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
import 'package:menstrual_tracking_app/ui/widget/empty_date_dialog.dart';
import 'package:menstrual_tracking_app/ui/widget/mood_log_card.dart';
import 'package:menstrual_tracking_app/ui/widget/note_card.dart';
import 'package:menstrual_tracking_app/ui/widget/submit_button.dart';
import 'package:menstrual_tracking_app/ui/widget/symptom_log_card.dart';
import 'package:menstrual_tracking_app/utils/loading_animation.dart';
import 'package:uuid/uuid.dart';

class LogMoodAndSymptomPage extends StatefulWidget {
  const LogMoodAndSymptomPage({super.key});

  @override
  State<LogMoodAndSymptomPage> createState() => _LogMoodAndSymptomPageState();
}

class _LogMoodAndSymptomPageState extends State<LogMoodAndSymptomPage> {
  late TextEditingController headingController;
  late TextEditingController noteController;

  List<Mood> moodList = [];
  Map<Symptom, Intensity> symptomMap = {};

  @override
  void initState() {
    // implement initState
    super.initState();
    headingController = TextEditingController();
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    // implement dispose
    headingController.dispose();
    noteController.dispose();
    super.dispose();
  }

  MoodLog getMood() {
    return MoodLog(id: Uuid().v4(), moods: moodList, logDate: DateTime.now());
  }

  SymptomLog getSymptom() {
    return SymptomLog(
      id: Uuid().v4(),
      symptoms: symptomMap,
      logDate: DateTime.now(),
    );
  }

  NoteLog getNotes() {
    return NoteLog(
      id: Uuid().v4(),
      logDate: DateTime.now(),
      heading: headingController.text.trim(),
      note: noteController.text.trim(),
    );
  }

  void showError({
    required String message,
    DialogType type = DialogType.warning,
  }) {
    showDialog(
      context: context,
      builder: (_) => EmptyDateDialog(message: message, type: type),
    );
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingAnimation(size: 80)),
    );
  }

  void logData() async {
    final newHeading = headingController.text.trim();
    final newNote = noteController.text.trim();

    if (moodList.isEmpty || symptomMap.isEmpty) {
      showError(
        message: 'Please select at least one mood and one symptom',
        type: DialogType.warning,
      );
      return;
    }

    if (newHeading.isNotEmpty && newNote.isEmpty) {
      showError(
        message: 'Please enter note text for the heading or remove the heading',
        type: DialogType.warning,
      );
      return;
    }

    if (newHeading.isEmpty && newNote.isNotEmpty) {
      showError(
        message: 'Please add a heading when adding a note',
        type: DialogType.warning,
      );
      return;
    }

    // Show a simple non-dismissible loading dialog while we save the data

    showLoading();

    try {
      final futures = <Future>[];

      if (newHeading.isNotEmpty && newNote.isNotEmpty) {
        final note = getNotes();
        futures.add(MenstrualLogDatabase.instance.insertNoteLog(note));
      }

      final newMood = getMood();
      final newSymptoms = getSymptom();
      futures.add(MenstrualLogDatabase.instance.insertMoodLog(newMood));
      futures.add(MenstrualLogDatabase.instance.insertSymptomLog(newSymptoms));

      // Run DB writes concurrently for speed
      await Future.wait(futures);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // close loading

      showError(
        message: 'Failed to save data. Please try again.',
        type: DialogType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(),
      body: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: MoodLogCard(
              moodList: moodList,
              onMoodChanged: (moods) {
                // Don't call setState here: MoodLogCard updates itself via ValueNotifier
                // Assign to the local variable so we can use it when saving without
                // forcing a rebuild of the entire page on every tap.
                moodList = moods;
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SymptomLogCard(
              symptoms: symptomMap,
              onSymptomChanged: (symtoms) {
                // Avoid rebuilding the whole page for each change — keep local update
                symptomMap = symtoms;
              },
            ),
          ),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: NoteCard(
              headingController: headingController,
              noteController: noteController,
            ),
          ),
          SizedBox(height: 20),

          SubmitButton(label: "Log Data", onSubmit: logData),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
