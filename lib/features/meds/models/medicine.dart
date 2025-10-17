import 'package:flutter/material.dart';

enum DoseStatus { pending, taken, skipped }
enum ScheduleMode { weekly, dates }

class Medicine {
  final String id;
  String name;
  String form;
  String dose;
  String notes;
  Schedule schedule;
  Medicine({
    required this.id,
    required this.name,
    required this.form,
    required this.dose,
    required this.notes,
    required this.schedule,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'form': form,
    'dose': dose,
    'notes': notes,
    'schedule': schedule.toJson(),
  };
  factory Medicine.fromJson(Map<String, dynamic> j) => Medicine(
    id: j['id'],
    name: j['name'],
    form: j['form'] ?? '',
    dose: j['dose'] ?? '',
    notes: j['notes'] ?? '',
    schedule: Schedule.fromJson(j['schedule']),
  );
}

class Schedule {
  bool active;
  ScheduleMode mode;
  List<Clock> times;
  Set<int> daysOfWeek;
  List<DateTime> dates;
  Schedule({
    required this.active,
    required this.mode,
    required this.times,
    required this.daysOfWeek,
    required this.dates,
  });
  Map<String, dynamic> toJson() => {
    'active': active,
    'mode': mode.name,
    'times': times.map((e) => e.toJson()).toList(),
    'daysOfWeek': daysOfWeek.toList(),
    'dates': dates.map((e) => e.toIso8601String()).toList(),
  };
  factory Schedule.fromJson(Map<String, dynamic> j) => Schedule(
    active: j['active'] ?? true,
    mode: ScheduleMode.values.firstWhere(
          (e) => e.name == (j['mode'] ?? 'weekly'),
      orElse: () => ScheduleMode.weekly,
    ),
    times: (j['times'] as List? ?? [])
        .map((e) => Clock.fromJson(e as Map<String, dynamic>))
        .toList(),
    daysOfWeek: Set<int>.from(j['daysOfWeek'] ?? [1, 2, 3, 4, 5, 6, 7]),
    dates: (j['dates'] as List? ?? [])
        .map((e) => DateTime.parse(e as String))
        .toList(),
  );
}

class DoseEntry {
  final String id;
  final String medicineId;
  DateTime plannedAt;
  DoseStatus status;
  DateTime? factAt;
  String note;
  DoseEntry({
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
    'plannedAt': plannedAt.toIso8601String(),
    'status': status.name,
    'factAt': factAt?.toIso8601String(),
    'note': note,
  };
  factory DoseEntry.fromJson(Map<String, dynamic> j) => DoseEntry(
    id: j['id'],
    medicineId: j['medicineId'],
    plannedAt: DateTime.parse(j['plannedAt']),
    status: DoseStatus.values.firstWhere(
          (e) => e.name == j['status'],
      orElse: () => DoseStatus.pending,
    ),
    factAt: j['factAt'] != null ? DateTime.parse(j['factAt']) : null,
    note: j['note'] ?? '',
  );
}

class Clock {
  final int hour;
  final int minute;
  const Clock(this.hour, this.minute);
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
  Map<String, dynamic> toJson() => {'h': hour, 'm': minute};
  factory Clock.fromJson(Map<String, dynamic> j) => Clock(j['h'], j['m']);
  @override
  String toString() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}