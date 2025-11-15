import 'package:bloc/bloc.dart';

abstract class MainEvent {
  const MainEvent();
}

class IncrementPressed extends MainEvent {
  const IncrementPressed();
}

class MainBloc extends Bloc<MainEvent, int> {
  MainBloc() : super(0) {
    on<IncrementPressed>(_onIncrementPressed);
  }

  void _onIncrementPressed(
      IncrementPressed event,
      Emitter<int> emit,
      ) {
    emit(state + 1);
  }
}