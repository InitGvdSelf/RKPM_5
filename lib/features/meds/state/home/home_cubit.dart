import 'package:bloc/bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void setTab(int index) {
    if (index == state.selectedIndex) return;
    emit(state.copyWith(selectedIndex: index));
  }
}