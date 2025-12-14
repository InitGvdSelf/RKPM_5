class MedCourse {
  final String id;

  // если выбрали из списка лекарств — сохраняем id
  final String? medicineId;

  // на всякий случай сохраняем имя (если ввели вручную или лекарство потом удалили)
  final String medicineName;

  final DateTime startDate;
  final DateTime? endDate;
  final int timesPerDay;
  final String note;

  const MedCourse({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.startDate,
    required this.endDate,
    required this.timesPerDay,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineId': medicineId,
    'medicineName': medicineName,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'timesPerDay': timesPerDay,
    'note': note,
  };

  factory MedCourse.fromJson(Map<String, dynamic> j) => MedCourse(
    id: (j['id'] ?? '') as String,
    medicineId: j['medicineId'] as String?,
    medicineName: (j['medicineName'] ?? '') as String,
    startDate:
    DateTime.tryParse((j['startDate'] ?? '') as String) ?? DateTime.now(),
    endDate: (j['endDate'] == null)
        ? null
        : DateTime.tryParse((j['endDate'] ?? '') as String),
    timesPerDay: (j['timesPerDay'] ?? 1) as int,
    note: (j['note'] ?? '') as String,
  );
}