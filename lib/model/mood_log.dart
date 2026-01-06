enum Mood {
  happy("Happy", "😀"),
  sad("Sad", "😢"),
  angry("Angry", "😡"),
  anxious("Anxious", "😰"),
  calm("Calm", "😌"),
  moodSwings("Mood Swings", "🎢"),
  irritability("Irritability", "😠"), // Fixed spelling
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
  final List<Mood> mood;
  const MoodLog({required this.id, required this.mood});

  Map<String, dynamic> toJson() => {
    "id": id,
    "mood": mood.map((m) => m.name).toList(),
  };

  @override
  String toString() {
    return 'MoodLog(id: $id, moods: ${mood.map((m) => m.label).toList()})';
  }
}
