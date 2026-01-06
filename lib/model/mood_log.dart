import 'dart:convert';

enum Mood {
  happy("Happy", "😀"),
  sad("Sad", "😢"),
  angry("Angry", "😡"),
  anxious("Anxious", "😰"),
  calm("Calm", "😌"),
  moodSwings("Mood Swings", "🎢"),
  irritability("Irritability", "😠"),
  stress("Stress", "😫"),
  overwhelmed("Overwhelmed", "🌊"),
  lowMotivation("Low Motivation", "📉"),
  sensitive("Sensitive", "🥺"),
  troubleConcentrating("Trouble Concentrating", "🧠");

  final String label;
  final String emoji;

  const Mood(this.label, this.emoji);
}

class MoodLog {
  final String id;
  final DateTime logDate;
  final List<Mood> moods;

  const MoodLog({required this.id, required this.moods, required this.logDate});

  Map<String, dynamic> toMap() => {
    'id': id,
    'logDate': logDate.toIso8601String(),
    'moods': jsonEncode(moods.map((m) => m.name).toList()),
  };

  factory MoodLog.fromMap(Map<String, dynamic> map) {
    return MoodLog(
      id: map['id'],
      logDate: DateTime.parse(map['logDate']),
      moods: (jsonDecode(map['moods']) as List)
          .map((e) => Mood.values.byName(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'MoodLog(id: $id, moods: ${moods.map((m) => m.label).toList()})';
  }
}
