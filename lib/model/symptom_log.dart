enum Intensity { mild, moderate, servere }

enum Symptom {
  cramps,
  bloating,
  breastTenderness,
  headache,
  migraine,
  acne,
  fatigue,
  backPain,
  nausea,
  appetiteChanges,
  foodCravings,
  constipation,
  diarrhea,
}

class SymptomLog {
  final String id;
  final DateTime logDate;
  final List<Symptom> symptoms;
  final List<Intensity> intensity;

  const SymptomLog({
    required this.id,
    required this.logDate,
    required this.symptoms,
    required this.intensity,
  });
}
