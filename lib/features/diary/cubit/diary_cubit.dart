import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/diary_entry_model.dart';
import 'package:rkpm_5/domain/usecases/diary/get_diary_usecase.dart';
import 'package:rkpm_5/domain/usecases/diary/add_diary_entry_usecase.dart';
import 'package:rkpm_5/domain/usecases/diary/delete_diary_entry_usecase.dart';
import 'diary_state.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final GetDiaryUseCase getDiaryUseCase;
  final AddDiaryEntryUseCase addDiaryEntryUseCase;
  final DeleteDiaryEntryUseCase deleteDiaryEntryUseCase;

  DiaryCubit({
    GetDiaryUseCase? getDiaryUseCase,
    AddDiaryEntryUseCase? addDiaryEntryUseCase,
    DeleteDiaryEntryUseCase? deleteDiaryEntryUseCase,
  })  : getDiaryUseCase = getDiaryUseCase ?? DI.getDiaryUseCase,
        addDiaryEntryUseCase = addDiaryEntryUseCase ?? DI.addDiaryEntryUseCase,
        deleteDiaryEntryUseCase = deleteDiaryEntryUseCase ?? DI.deleteDiaryEntryUseCase,
        super(DiaryState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final result = await getDiaryUseCase();
    result.fold(
      (_) => emit(state.copyWith(isLoading: false, entries: [])),
      (entries) {
        entries.sort((a, b) => b.date.compareTo(a.date));
        emit(state.copyWith(isLoading: false, entries: entries));
      },
    );
  }

  Future<void> add(DiaryEntry entry) async {
    final result = await addDiaryEntryUseCase(entry);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }

  Future<void> delete(String id) async {
    final result = await deleteDiaryEntryUseCase(id);
    result.fold(
      (_) {},
      (_) => _load(),
    );
  }
}

