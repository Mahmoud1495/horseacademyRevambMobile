import 'package:flutter/material.dart';
import 'package:horseacademy/data/models/user_model.dart';
import 'package:horseacademy/presentation/Shared/DashboardScaffold.dart';
import 'package:horseacademy/presentation/Timer/timer_page.dart';

import 'trainee_home.dart';
import 'trainee_profile_page.dart';
import 'trainee_sessions_page.dart';

class TraineeTabs extends StatefulWidget {
  final UserModel user;

  const TraineeTabs({super.key, required this.user});

  @override
  State<TraineeTabs> createState() => _TraineeTabsState();
}

class _TraineeTabsState extends State<TraineeTabs> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScaffold(
        user: widget.user,
        title: "الملف الشخصي",
        body: TraineeProfilePage(user: widget.user),
      ),

      DashboardScaffold(
        user: widget.user,
        title: "الرئيسية",
        body: TraineeHome(user: widget.user),
      ),

      DashboardScaffold(
        user: widget.user,
        title: "سجل الجلسات",
        body: TraineeSessionsPage(userId: widget.user.id),
      ),
      DashboardScaffold(
        user: widget.user,
        title: "Timer",
        body: TimerPage(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'السجل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'timer',
          ),
        ],
      ),
    );
  }
}
