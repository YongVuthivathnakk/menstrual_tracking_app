class NoteLog {
  final String id;
  final DateTime logDate;
  final String note;
  final String heading;

  const NoteLog({
    required this.id,
    required this.note,
    required this.heading,
    required this.logDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'logDate': logDate.toIso8601String(),
    'heading': heading,
    'note': note,
  };

  factory NoteLog.fromMap(Map<String, dynamic> map) => NoteLog(
    id: map['id'],
    logDate: DateTime.parse(map['logDate']),
    heading: map['heading'],
    note: map['note'],
  );
  @override
  String toString() {
    return 'NoteLog(id: $id, heading: $heading note: $note)';
  }
}
