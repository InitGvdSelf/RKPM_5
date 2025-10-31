import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/state/meds_container.dart';

class NavigationChoiceScreen extends StatelessWidget {
  const NavigationChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEEF2FF), Color(0xFFE6FFFA)],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: const [
                    Icon(Icons.medical_services_outlined, size: 28, color: Color(0xFF334155)),
                    SizedBox(width: 10),
                    Text('Режим навигации', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Выберите, как перемещаться по приложению', style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
                const SizedBox(height: 24),
                _NavCard(
                  accent: const Color(0xFF4F46E5),
                  icon: Icons.swipe,
                  title: 'Страничная навигация',
                  subtitle: 'Горизонтальные свайпы между экранами',
                  badge: 'PageView',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MedsContainer(navMode: MedsNavMode.pageView),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _NavCard(
                  accent: const Color(0xFF059669),
                  icon: Icons.alt_route,
                  title: 'Маршрутизированная навигация',
                  subtitle: 'Переходы по экранам через маршруты',
                  badge: 'Routes',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MedsContainer(navMode: MedsNavMode.routes),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: Color(0xFF334155)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Оба режима запускают те же экраны: Главная, Сегодня, Лекарства, Настройки, Профиль.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatefulWidget {
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;

  const _NavCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  State<_NavCard> createState() => _NavCardState();
}

class _NavCardState extends State<_NavCard> with SingleTickerProviderStateMixin {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: _hover ? 1.02 : 1.0,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF94A3B8).withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, size: 28, color: widget.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: widget.accent.withOpacity(0.2)),
                            ),
                            child: Text(
                              widget.badge,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: widget.accent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chevron_right, color: widget.accent, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}