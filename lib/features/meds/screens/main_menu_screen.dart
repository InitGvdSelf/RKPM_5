import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final Map<String, WidgetBuilder>? routes;
  const MainMenuScreen({super.key, this.routes});

  @override
  Widget build(BuildContext context) {
    final items = <_Item>[
      _Item('Статистика', Icons.home, '/stats'),
      _Item('Сегодня', Icons.calendar_month, '/today'),
      _Item('Лекарства', Icons.medication, '/meds'),
      _Item('Профиль', Icons.person, '/profile'),
      _Item('Настройки', Icons.settings, '/settings'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Меню')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: items.map((e) {
            return InkWell(
              onTap: () {
                if (routes != null && routes!.containsKey(e.route)) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => routes![e.route]!.call(context)));
                } else {
                  Navigator.of(context).pushNamed(e.route);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.icon, size: 36),
                    const SizedBox(height: 12),
                    Text(e.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Item {
  final String title;
  final IconData icon;
  final String route;
  _Item(this.title, this.icon, this.route);
}