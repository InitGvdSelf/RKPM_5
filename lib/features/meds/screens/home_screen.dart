import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app_router.dart'; // тут лежат имена маршрутов (Routes.*)

/// Домашний экран-хаб: кнопки дергают именованные маршруты.
/// Состояние и сервисы пробрасываются внутри конфигурации go_router,
/// а не через конструкторы экранов здесь.
class MedsHomeScreen extends StatelessWidget {
  const MedsHomeScreen({super.key});

  void _openSchedule(BuildContext context) => context.pushNamed(Routes.schedule);
  void _openMeds(BuildContext context)     => context.pushNamed(Routes.meds);
  void _openStats(BuildContext context)    => context.pushNamed(Routes.stats);
  void _openProfile(BuildContext context)  => context.pushNamed(Routes.profile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Учёт приёма лекарственных препаратов')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => _openSchedule(context),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Расписание'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openMeds(context),
                icon: const Icon(Icons.medication),
                label: const Text('Лекарства'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openStats(context),
                icon: const Icon(Icons.insights),
                label: const Text('Статистика'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openProfile(context),
                icon: const Icon(Icons.person),
                label: const Text('Профиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}