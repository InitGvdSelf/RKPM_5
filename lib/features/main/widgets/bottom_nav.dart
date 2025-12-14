import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Расписание',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medication),
          label: 'Лекарства',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_pharmacy),
          label: 'Аптеки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.note_alt),
          label: 'Дневник',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_note),
          label: 'К врачу',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.playlist_add_check),
          label: 'Курсы',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    );
  }
}

