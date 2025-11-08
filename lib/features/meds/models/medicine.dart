import 'package:flutter/material.dart';

/// --------- Enums ---------
enum DoseStatus { pending, taken, skipped }
enum ScheduleMode { weekly, dates }

/// --------- Entities ---------

class Medicine {
  final String id;
  String name;
  String form;
  String dose;
  String notes;
  String? imageUrl;
  Schedule schedule;

  Medicine({
    required this.id,
    required this.name,
    required this.form,
    required this.dose,
    required this.notes,
    required this.schedule,
    this.imageUrl,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? form,
    String? dose,
    String? notes,
    String? imageUrl,
    Schedule? schedule,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      dose: dose ?? this.dose,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      schedule: schedule ?? this.schedule,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'form': form,
    'dose': dose,
    'notes': notes,
    'imageUrl': imageUrl,
    'schedule': schedule.toJson(),
  };

  factory Medicine.fromJson(Map<String, dynamic> j) => Medicine(
    id: (j['id'] ?? '') as String,
    name: (j['name'] ?? '') as String,
    form: (j['form'] ?? '') as String,
    dose: (j['dose'] ?? '') as String,
    notes: (j['notes'] ?? '') as String,
    imageUrl: j['imageUrl'] as String?,
    schedule: Schedule.fromJson(
      (j['schedule'] as Map?)?.cast<String, dynamic>() ?? const {},
    ),
  );

  @override
  String toString() => 'Medicine($name $dose)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Medicine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Clock {
  final int hour;
  final int minute;

  const Clock(this.hour, this.minute);

  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);

  Map<String, dynamic> toJson() => {'h': hour, 'm': minute};

  factory Clock.fromJson(Map<String, dynamic> j) =>
      Clock((j['h'] ?? 0) as int, (j['m'] ?? 0) as int);

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Clock &&
              runtimeType == other.runtimeType &&
              hour == other.hour &&
              minute == other.minute;

  @override
  int get hashCode => Object.hash(hour, minute);
}

class Schedule {
  bool active;
  ScheduleMode mode;
  List<Clock> times;
  Set<int> daysOfWeek; // 1..7 (Mon..Sun)
  List<DateTime> dates;

  Schedule({
    required this.active,
    required this.mode,
    required this.times,
    required this.daysOfWeek,
    required this.dates,
  });

  /// Еженедельный режим.
  factory Schedule.weekly({
    required bool active,
    required Set<int> daysOfWeek,
    required List<Clock> times,
  }) =>
      Schedule(
        active: active,
        mode: ScheduleMode.weekly,
        times: List<Clock>.from(times),
        daysOfWeek: Set<int>.from(daysOfWeek),
        dates: const [],
      );

  /// Конкретные даты.
  factory Schedule.dates({
    required bool active,
    required List<DateTime> dates,
    required List<Clock> times,
  }) =>
      Schedule(
        active: active,
        mode: ScheduleMode.dates,
        times: List<Clock>.from(times),
        daysOfWeek: const {},
        dates: List<DateTime>.from(dates),
      );

  bool get isWeekly => mode == ScheduleMode.weekly;
  bool get isDates => mode == ScheduleMode.dates;

  Schedule copyWith({
    bool? active,
    ScheduleMode? mode,
    List<Clock>? times,
    Set<int>? daysOfWeek,
    List<DateTime>? dates,
  }) =>
      Schedule(
        active: active ?? this.active,
        mode: mode ?? this.mode,
        times: times ?? this.times,
        daysOfWeek: daysOfWeek ?? this.daysOfWeek,
        dates: dates ?? this.dates,
      );

  Map<String, dynamic> toJson() => {
    'active': active,
    'mode': mode.name,
    'times': times.map((e) => e.toJson()).toList(),
    'daysOfWeek': daysOfWeek.toList(),
    'dates': dates.map((e) => e.toIso8601String()).toList(),
  };

  factory Schedule.fromJson(Map<String, dynamic> j) {
    final rawMode = (j['mode'] ?? 'weekly') as String;
    final mode = ScheduleMode.values.firstWhere(
          (e) => e.name == rawMode,
      orElse: () => ScheduleMode.weekly,
    );

    final times = ((j['times'] as List?) ?? const [])
        .map((e) => Clock.fromJson((e as Map).cast<String, dynamic>()))
        .toList();

    final days = Set<int>.from(
      (j['daysOfWeek'] as List?) ?? const [1, 2, 3, 4, 5, 6, 7],
    );

    final dates = ((j['dates'] as List?) ?? const [])
        .map((e) => DateTime.tryParse(e as String))
        .whereType<DateTime>()
        .toList();

    return Schedule(
      active: (j['active'] ?? true) as bool,
      mode: mode,
      times: times,
      daysOfWeek: days,
      dates: dates,
    );
  }

  @override
  String toString() => 'Schedule($mode, active=$active)';
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

  DoseEntry copyWith({
    String? id,
    String? medicineId,
    DateTime? plannedAt,
    DoseStatus? status,
    DateTime? factAt,
    String? note,
  }) {
    return DoseEntry(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      plannedAt: plannedAt ?? this.plannedAt,
      status: status ?? this.status,
      factAt: factAt ?? this.factAt,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'medicineId': medicineId,
    'plannedAt': plannedAt.toIso8601String(),
    'status': status.name,
    'factAt': factAt?.toIso8601String(),
    'note': note,
  };

  factory DoseEntry.fromJson(Map<String, dynamic> j) => DoseEntry(
    id: (j['id'] ?? '') as String,
    medicineId: (j['medicineId'] ?? '') as String,
    plannedAt: DateTime.tryParse((j['plannedAt'] ?? '') as String) ??
        DateTime.now(),
    status: DoseStatus.values.firstWhere(
          (e) => e.name == (j['status'] ?? 'pending'),
      orElse: () => DoseStatus.pending,
    ),
    factAt: j['factAt'] != null
        ? DateTime.tryParse(j['factAt'] as String)
        : null,
    note: (j['note'] ?? '') as String,
  );

  @override
  String toString() =>
      'DoseEntry($medicineId @ $plannedAt, $status, note="${note.trim()}")';
}