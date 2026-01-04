enum Intensity {
  mild("Mild"),
  moderate("Moderate"),
  severe("Servere");

  final String label;
  const Intensity(this.label);
}

enum Symptom {
  cramps("Cramps"),
  bloating("Bloating"),
  breastTenderness("Breast Tenderness"),
  headache("Headache"),
  migraine("Migraine"),
  acne("Acne"),
  fatigue("Fatigue"),
  backPain("Back Pain"),
  nausea("Nausea"),
  appetiteChanges("Appetite Changes"),
  foodCravings("Food Cravings"),
  constipation("Constipation"),
  diarrhea("Diarrhea");

  final String label;
  const Symptom(this.label);
}

class SymptomLog {
  final String id;
  final Map<Symptom, Intensity> symptoms;

  const SymptomLog({required this.id, required this.symptoms});

  // Cannot convert enum as key to Json data so set the enum to string usign it name.

  Map<String, dynamic> toJson() => {
    "id": id,
    "symptom": symptoms.map((key, value) => MapEntry(key.name, value.name)),
  };

  @override
  String toString() {
    return 'SymptomLog(id: $id, symptoms: $symptoms)';
  }
}
