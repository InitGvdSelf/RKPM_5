import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пример классического Bloc'),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: bloc.stream,
          initialData: bloc.state,
          builder: (context, snapshot) {
            final value = snapshot.data ?? 0;

            return Text(
              'Нажато: $value',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(const IncrementPressed());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}