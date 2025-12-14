class VisitDto {
  final String id;
  final String dateTime;
  final String doctor;
  final String reason;
  final String note;

  VisitDto({
    required this.id,
    required this.dateTime,
    required this.doctor,
    required this.reason,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateTime': dateTime,
    'doctor': doctor,
    'reason': reason,
    'note': note,
  };

  factory VisitDto.fromJson(Map<String, dynamic> json) => VisitDto(
    id: json['id'] as String,
    dateTime: json['dateTime'] as String,
    doctor: json['doctor'] as String,
    reason: json['reason'] as String,
    note: json['note'] as String,
  );
}

