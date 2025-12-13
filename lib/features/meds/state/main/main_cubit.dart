import 'package:bloc/bloc.dart';

import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState.initial());

  void setTab(int index) {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: index));
  }
}