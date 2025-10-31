import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/taken_doses_screen.dart';
import 'package:rkpm_5/features/meds/screens/planned_doses_screen.dart';

class PageViewNavigationScreen extends StatefulWidget {
  const PageViewNavigationScreen({super.key});

  @override
  State<PageViewNavigationScreen> createState() => _PageViewNavigationScreenState();
}

class _PageViewNavigationScreenState extends State<PageViewNavigationScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final List<Medicine> _meds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title())),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _pageIndex = i),
        children: [
          StatsScreen(
            meds: _meds,
            doses: const [], // у тебя модели доз нет — передаём пустой список
          ),
          TakenDosesScreen(
            onAddMedicine: (m) => setState(() => _meds.add(m)),
          ),
          PlannedDosesScreen(
            onAddMedicine: (m) => setState(() => _meds.add(m)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (i) => _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Принятые'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'К принятию'),
        ],
      ),
    );
  }

  String _title() {
    switch (_pageIndex) {
      case 0:
        return 'Главная';
      case 1:
        return 'Принятые';
      case 2:
        return 'К принятию';
      default:
        return '';
    }
  }
}бля