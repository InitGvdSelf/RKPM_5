class Visit {
  final String id;
  final DateTime dateTime;
  final String doctor;
  final String reason;
  final String note;

  const Visit({
    required this.id,
    required this.dateTime,
    required this.doctor,
    required this.reason,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateTime': dateTime.toIso8601String(),
    'doctor': doctor,
    'reason': reason,
    'note': note,
  };

  factory Visit.fromJson(Map<String, dynamic> j) => Visit(
    id: (j['id'] ?? '') as String,
    dateTime:
    DateTime.tryParse((j['dateTime'] ?? '') as String) ?? DateTime.now(),
    doctor: (j['doctor'] ?? '') as String,
    reason: (j['reason'] ?? '') as String,
    note: (j['note'] ?? '') as String,
  );
}

