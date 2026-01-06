import 'dart:typed_data';

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
    // TODO: implement initState
    super.initState();
    headingController = TextEditingController();
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      note: headingController.text.trim(),
      heading: noteController.text.trim(),
    );
  }

  void showError() {
    showDialog(context: context, builder: (_) => EmptyDateDialog());
  }

  void logData() {
    final newHeading = headingController.text.trim();
    final newNote = noteController.text.trim();

    if (moodList.isEmpty || symptomMap.isEmpty) {
      showError();
      return;
    }

    if (newHeading.isNotEmpty && newNote.isEmpty) {
      showError();
      return;
    }

    if (newHeading.isEmpty && newNote.isNotEmpty) {
      showError();
      return;
    }

    if (newHeading.isNotEmpty && newNote.isNotEmpty) {
      final newNote = getNotes();
      // await MenstrualLogDatabase.instance.insertNoteLog(getNotes());
    }

    final newMood = getMood();
    final newSymptoms = getSymptom();
    // await MenstrualLogDatabase.instance.insertMoodLog(getMood());
    // await MenstrualLogDatabase.instance.insertSymptomLog(getSymptom());

    debugPrint("Submitx");

    // Navigator.pop(context);
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
                setState(() {
                  moodList = moods;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SymptomLogCard(
              symptoms: symptomMap,
              onSymptomChanged: (symtoms) {
                setState(() {
                  symptomMap = symtoms;
                });
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
