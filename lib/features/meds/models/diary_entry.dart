class DiaryEntry {
  final String id;
  final DateTime date;
  final int mood; // 1..5
  final String note;

  const DiaryEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'mood': mood,
    'note': note,
  };

  factory DiaryEntry.fromJson(Map<String, dynamic> j) => DiaryEntry(
    id: (j['id'] ?? '') as String,
    date: DateTime.tryParse((j['date'] ?? '') as String) ?? DateTime.now(),
    mood: (j['mood'] ?? 3) as int,
    note: (j['note'] ?? '') as String,
  );
}