import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'counter_store.dart';

class MobxCounterPage extends StatelessWidget {
  MobxCounterPage({super.key});

  final Counter counter = Counter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Счётчик на MobX'),
      ),
      body: Center(
        child: Observer(
          builder: (_) {
            return Text(
              '${counter.value}',
              style: theme.textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'mobx_increment',
            onPressed: counter.increment,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'mobx_decrement',
            onPressed: counter.decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}