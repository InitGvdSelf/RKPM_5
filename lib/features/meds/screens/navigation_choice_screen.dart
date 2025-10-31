import 'package:flutter/material.dart';

class NavigationChoiceScreen extends StatelessWidget {
  const NavigationChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _NavCard(
        icon: Icons.swipe,
        title: 'Страничная навигация',
        subtitle: 'PageView + BottomNavigationBar',
        route: '/pageview',
      ),
      _NavCard(
        icon: Icons.alt_route,
        title: 'Маршрутизированная',
        subtitle: 'Именованные маршруты',
        route: '/routes',
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор навигации')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text('Выберите тип', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...cards.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.of(context).pushReplacementNamed(c.route),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 26, child: Icon(c.icon)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(c.subtitle, style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _NavCard {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  _NavCard({required this.icon, required this.title, required this.subtitle, required this.route});
}