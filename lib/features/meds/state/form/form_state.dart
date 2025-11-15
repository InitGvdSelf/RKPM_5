// lib/features/meds/state/form_state.dart
import 'package:equatable/equatable.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedFormState extends Equatable {
  final String name;
  final String form;
  final String dose;
  final String notes;
  final String? imageUrl;
  final Schedule schedule;

  final bool isEdit;
  final bool isSaving;
  final String? error;

  const MedFormState({
    required this.name,
    required this.form,
    required this.dose,
    required this.notes,
    required this.imageUrl,
    required this.schedule,
    required this.isEdit,
    required this.isSaving,
    required this.error,
  });

  factory MedFormState.create() {
    // дефолт: ежедневный приём в 09:00
    final defaultSchedule = Schedule.weekly(
      active: true,
      daysOfWeek: {1, 2, 3, 4, 5, 6, 7},
      times: const [Clock(9, 0)],
    );

    return MedFormState(
      name: '',
      form: '',
      dose: '',
      notes: '',
      imageUrl: null,
      schedule: defaultSchedule,
      isEdit: false,
      isSaving: false,
      error: null,
    );
  }

  factory MedFormState.fromMedicine(Medicine m) {
    return MedFormState(
      name: m.name,
      form: m.form,
      dose: m.dose,
      notes: m.notes,
      imageUrl: m.imageUrl,
      schedule: m.schedule,
      isEdit: true,
      isSaving: false,
      error: null,
    );
  }

  MedFormState copyWith({
    String? name,
    String? form,
    String? dose,
    String? notes,
    String? imageUrl,
    Schedule? schedule,
    bool? isEdit,
    bool? isSaving,
    String? error,
  }) {
    return MedFormState(
      name: name ?? this.name,
      form: form ?? this.form,
      dose: dose ?? this.dose,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      schedule: schedule ?? this.schedule,
      isEdit: isEdit ?? this.isEdit,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    name,
    form,
    dose,
    notes,
    imageUrl,
    schedule,
    isEdit,
    isSaving,
    error,
  ];
}