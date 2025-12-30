enum Mood {
  happy,
  sad,
  angry,
  anxious,
  calm,
  moodSwings,
  irritablity,
  stress,
  overwhelmed,
  lowMotivation,
  sensitive,
  troubleConcentrating,
}

class MoodLog {
  final String id;
  final DateTime logDate;
  final Mood mood;
  const MoodLog({required this.id, required this.logDate, required this.mood});
}
