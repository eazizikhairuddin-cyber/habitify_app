import 'package:flutter/material.dart';

import '../../habits/presentation/routines_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../statistics/presentation/statistics_screen.dart';
import '../../habits/presentation/today_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  final pages = const [TodayScreen(), RoutinesScreen(), StatisticsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.repeat), label: 'Routines'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Statistics'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onDestinationSelected: (v) => setState(() => index = v),
      ),
    );
  }
}
