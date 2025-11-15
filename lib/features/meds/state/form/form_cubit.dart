// lib/features/meds/state/form_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/domain/image_service.dart';

import 'form_state.dart';

class MedFormCubit extends Cubit<MedFormState> {
  final ImageService images;
  final Medicine? existing;

  MedFormCubit({
    required this.images,
    this.existing,
  }) : super(
    existing != null
        ? MedFormState.fromMedicine(existing)
        : MedFormState.create(),
  );

  void updateName(String value) {
    emit(state.copyWith(name: value));
  }

  void updateForm(String value) {
    emit(state.copyWith(form: value));
  }

  void updateDose(String value) {
    emit(state.copyWith(dose: value));
  }

  void updateNotes(String value) {
    emit(state.copyWith(notes: value));
  }

  Future<void> changeImage() async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final url = await images.nextMedImage();
      emit(
        state.copyWith(
          imageUrl: url,
          isSaving: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Не удалось загрузить изображение',
        ),
      );
    }
  }

  Future<Medicine?> submit() async {
    if (state.name.trim().isEmpty) {
      emit(state.copyWith(error: 'Введите название лекарства'));
      return null;
    }

    emit(state.copyWith(isSaving: true, error: null));

    try {
      final trimmedName = state.name.trim();
      final trimmedForm = state.form.trim();
      final trimmedDose = state.dose.trim();
      final trimmedNotes = state.notes.trim();

      final Medicine med;
      if (existing != null) {
        med = existing!.copyWith(
          name: trimmedName,
          form: trimmedForm,
          dose: trimmedDose,
          notes: trimmedNotes,
          imageUrl: state.imageUrl,
          schedule: state.schedule,
        );
      } else {
        med = Medicine(
          id: const Uuid().v4(),
          name: trimmedName,
          form: trimmedForm,
          dose: trimmedDose,
          notes: trimmedNotes,
          imageUrl: state.imageUrl,
          schedule: state.schedule,
        );
      }

      emit(state.copyWith(isSaving: false));
      return med;
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Не удалось сохранить лекарство',
        ),
      );
      return null;
    }
  }
}