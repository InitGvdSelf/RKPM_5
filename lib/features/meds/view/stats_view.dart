import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/state/stats/stats_cubit.dart';
import 'package:rkpm_5/features/meds/state/stats/stats_state.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Статистика')),
            body: Center(child: Text(state.error!)),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Статистика')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _StatCard(
                  title: 'Лекарства',
                  value: state.totalMeds.toString(),
                  subtitle: 'Всего уникальных препаратов',
                  icon: Icons.medication,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Запланированные приёмы',
                  value: state.totalDoses.toString(),
                  subtitle: 'Всего доз в расписании',
                  icon: Icons.event_note,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Выполненные приёмы',
                  value: state.takenDoses.toString(),
                  subtitle: 'Отмечены как принятые',
                  icon: Icons.check_circle,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Пропущенные приёмы',
                  value: state.skippedDoses.toString(),
                  subtitle: 'Отмечены как пропущенные',
                  icon: Icons.cancel,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Ожидающие приёмы',
                  value: state.pendingDoses.toString(),
                  subtitle: 'Ещё не отмечены',
                  icon: Icons.hourglass_bottom,
                ),
                const SizedBox(height: 12),
                _StatCard(
                  title: 'Приверженность',
                  value: '${(state.adherence * 100).toStringAsFixed(0)}%',
                  subtitle: 'Доля принятых доз от общего числа',
                  icon: Icons.insights,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              value,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}