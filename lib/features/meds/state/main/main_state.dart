import 'package:equatable/equatable.dart';

class MainState extends Equatable {
  final int selectedIndex;

  const MainState({required this.selectedIndex});

  factory MainState.initial() => const MainState(selectedIndex: 0);

  MainState copyWith({int? selectedIndex}) {
    return MainState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [selectedIndex];
}