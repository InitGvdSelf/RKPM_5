class DiaryEntryDto {
  final String id;
  final String date;
  final int mood;
  final String note;

  DiaryEntryDto({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'mood': mood,
    'note': note,
  };

  factory DiaryEntryDto.fromJson(Map<String, dynamic> json) => DiaryEntryDto(
    id: json['id'] as String,
    date: json['date'] as String,
    mood: json['mood'] as int,
    note: json['note'] as String,
  );
}

