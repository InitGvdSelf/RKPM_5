class DoseDto {
  final String id;
  final String medicineId;
  final String plannedAt;
  final String status;
  final String? factAt;
  final String note;

  DoseDto({
    required this.id,
    required this.medicineId,
    required this.plannedAt,
    required this.status,
    this.factAt,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineId': medicineId,
    'plannedAt': plannedAt,
    'status': status,
    'factAt': factAt,
    'note': note,
  };

  factory DoseDto.fromJson(Map<String, dynamic> json) => DoseDto(
    id: json['id'] as String,
    medicineId: json['medicineId'] as String,
    plannedAt: json['plannedAt'] as String,
    status: json['status'] as String,
    factAt: json['factAt'] as String?,
    note: json['note'] as String,
  );
}

