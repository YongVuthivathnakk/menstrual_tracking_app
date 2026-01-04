import 'package:flutter/material.dart';
import 'package:menstrual_tracking_app/model/mood_log.dart';
import 'package:menstrual_tracking_app/model/note_log.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:menstrual_tracking_app/ui/widget/back_app_bar.dart';
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
  String newNote = '';
  String newHeading = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    headingController = TextEditingController(text: newHeading);
    noteController = TextEditingController(text: newNote);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    headingController.dispose();
    noteController.dispose();
  }

  void buildingJson() {}

  void getMood() {
    final MoodLog newMooodLog = MoodLog(id: Uuid().v4(), mood: moodList);
    debugPrint(newMooodLog.toString());
  }

  void getSymptom() {
    final SymptomLog newSymptomlog = SymptomLog(
      id: Uuid().v4(),
      symptoms: symptomMap,
    );
    debugPrint(newSymptomlog.toString()); //working
  }

  void getNotes() {
    final NoteLog newNoteLog = NoteLog(
      id: Uuid().v4(),
      note: newNote,
      heading: newHeading,
    );
    debugPrint(newNoteLog.toString());
  }

  void logData() {
    getMood();
    getSymptom();
    getNotes();
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
              heading: newHeading,
              note: newNote,
              onHeadingChanged: (value) {
                setState(() {
                  newHeading = value;
                });
              },
              onNoteChanged: (value) {
                setState(() {
                  newNote = value;
                });
              },
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
