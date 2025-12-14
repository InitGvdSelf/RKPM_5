class CourseDto {
  final String id;
  final String? medicineId;
  final String medicineName;
  final String startDate;
  final String? endDate;
  final int timesPerDay;
  final String note;

  CourseDto({
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
    'startDate': startDate,
    'endDate': endDate,
    'timesPerDay': timesPerDay,
    'note': note,
  };

  factory CourseDto.fromJson(Map<String, dynamic> json) => CourseDto(
    id: json['id'] as String,
    medicineId: json['medicineId'] as String?,
    medicineName: json['medicineName'] as String,
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String?,
    timesPerDay: json['timesPerDay'] as int,
    note: json['note'] as String,
  );
}

