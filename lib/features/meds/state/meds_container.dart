import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/main_menu_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/settings_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';

enum MedsNavMode { routes, pageView }

class MedsContainer extends StatefulWidget {
  final MedsNavMode navMode;

  const MedsContainer({super.key, this.navMode = MedsNavMode.routes});

  @override
  State<MedsContainer> createState() => _MedsContainerState();
}

class _MedsContainerState extends State<MedsContainer> {
  final List<Medicine> _meds = [];
  final List<DoseEntry> _doses = [];
  bool _darkMode = false;

  Medicine? Function(String) get _deleteMed => (id) {
    final idx = _meds.indexWhere((m) => m.id == id);
    if (idx < 0) return null;
    final removed = _meds.removeAt(idx);
    return removed;
  };

  void _restoreMed(Medicine m) => setState(() => _meds.add(m));
  void _addMed(Medicine m) => setState(() => _meds.add(m));
  void _updateMed(Medicine m) => setState(() {});

  List<DoseEntry> Function(DateTime) get _dosesForDay => (DateTime d) => _doses;

  String _fmtDate(DateTime d) => DateFormat('dd.MM.yyyy', 'ru_RU').format(d);
  String _fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru_RU').format(d);
  String _fmtTime(DateTime d) => DateFormat('HH:mm', 'ru_RU').format(d);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.teal,
      brightness: _darkMode ? Brightness.dark : Brightness.light,
    );
    final app = widget.navMode == MedsNavMode.pageView ? _buildPageViewApp() : _buildRoutedApp();
    return Theme(data: theme, child: app);
  }

  List<_TabPage> _pages() {
    return <_TabPage>[
      _TabPage(
        title: 'Главная',
        icon: Icons.home,
        builder: (_) => StatsScreen(meds: _meds, doses: _doses),
      ),
      _TabPage(
        title: 'Сегодня',
        icon: Icons.calendar_month,
        builder: (_) => ScheduleScreen(
          medicines: _meds,
          dosesForDay: _dosesForDay,
          onMarkDose: (id, status) {},
          onSetDoseNote: (id, note) {},
          fmtDate: _fmtDate,
          fmtMonth: _fmtMonth,
          fmtTime: _fmtTime,
        ),
      ),
      _TabPage(
        title: 'Лекарства',
        icon: Icons.medication,
        builder: (_) => MedsListScreen(
          medicines: _meds,
          onAddMedicine: _addMed,
          onUpdateMedicine: _updateMed,
          onDeleteMedicine: _deleteMed,
          onRestoreMedicine: _restoreMed,
        ),
      ),
      _TabPage(
        title: 'Настройки',
        icon: Icons.settings,
        builder: (_) => SettingsScreen(
          darkMode: _darkMode,
          onToggleDark: (v) => setState(() => _darkMode = v),
        ),
      ),
      _TabPage(
        title: 'Профиль',
        icon: Icons.person,
        builder: (_) => const ProfileScreen(),
      ),
    ];
  }

  Widget _wrap(String title, Widget child) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: child);
  }

  Route<dynamic> _routeBuilder(RouteSettings settings) {
    if (settings.name == '/' || settings.name == '/menu') {
      return MaterialPageRoute(builder: (_) => const MainMenuScreen());
    }
    switch (settings.name) {
      case '/stats':
        return MaterialPageRoute(builder: (_) => _wrap('Главная', StatsScreen(meds: _meds, doses: _doses)));
      case '/today':
        return MaterialPageRoute(
          builder: (_) => _wrap(
            'Сегодня',
            ScheduleScreen(
              medicines: _meds,
              dosesForDay: _dosesForDay,
              onMarkDose: (id, status) {},
              onSetDoseNote: (id, note) {},
              fmtDate: _fmtDate,
              fmtMonth: _fmtMonth,
              fmtTime: _fmtTime,
            ),
          ),
        );
      case '/meds':
        return MaterialPageRoute(
          builder: (_) => _wrap(
            'Лекарства',
            MedsListScreen(
              medicines: _meds,
              onAddMedicine: _addMed,
              onUpdateMedicine: _updateMed,
              onDeleteMedicine: _deleteMed,
              onRestoreMedicine: _restoreMed,
            ),
          ),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => _wrap(
            'Настройки',
            SettingsScreen(
              darkMode: _darkMode,
              onToggleDark: (v) => setState(() => _darkMode = v),
            ),
          ),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => _wrap('Профиль', const ProfileScreen()));
      default:
        return MaterialPageRoute(builder: (_) => const MainMenuScreen());
    }
  }

  Widget _buildRoutedApp() {
    return Navigator(
      onGenerateRoute: _routeBuilder,
      initialRoute: '/menu',
    );
  }

  Widget _buildPageViewApp() {
    final pages = _pages();
    final controller = PageController();
    int index = 0;
    return StatefulBuilder(
      builder: (context, setLocal) {
        return Scaffold(
          appBar: AppBar(title: Text(pages[index].title)),
          body: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: i == index ? 36 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index ? const Color(0xFF495A9C) : Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (i) => setLocal(() => index = i),
                  children: pages.map((p) => p.builder(context)).toList(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) {
              controller.animateToPage(i, duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
              setLocal(() => index = i);
            },
            items: pages.map((p) => BottomNavigationBarItem(icon: Icon(p.icon), label: p.title)).toList(),
          ),
        );
      },
    );
  }
}

class _TabPage {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;

  _TabPage({required this.title, required this.icon, required this.builder});
}