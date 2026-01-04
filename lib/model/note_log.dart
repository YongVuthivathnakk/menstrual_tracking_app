class NoteLog {
  final String id;
  final String note;
  final String heading;
  const NoteLog({required this.id, required this.note, required this.heading});

  Map<String, dynamic> toJson() => {"id": id, "heading": heading, "note": note};

  @override
  String toString() {
    return 'NoteLog(id: $id, heading: $heading note: $note)';
  }
}
