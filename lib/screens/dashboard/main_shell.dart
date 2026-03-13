import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../dashboard/dashboard_screen.dart';
import '../training/workout_screen.dart';
import '../videos/videos_screen.dart';
import '../gamification/gamification_screen.dart';
import '../profile/profile_screen.dart';
import '../admin/admin_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _studentScreens = const [
    DashboardScreen(),
    WorkoutScreen(),
    VideosScreen(),
    GamificationScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _adminScreens = const [
    AdminScreen(),
    WorkoutScreen(),
    VideosScreen(),
    GamificationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isTrainer = context.watch<AppState>().isTrainer;
    final screens = isTrainer ? _adminScreens : _studentScreens;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.grey800,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey500,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
            ),
            items: [
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.home_rounded,
                  isSelected: _currentIndex == 0,
                ),
                label: isTrainer ? 'Painel' : 'Início',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.fitness_center_rounded,
                  isSelected: _currentIndex == 1,
                ),
                label: 'Treinos',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.play_circle_fill_rounded,
                  isSelected: _currentIndex == 2,
                ),
                label: 'Vídeos',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.emoji_events_rounded,
                  isSelected: _currentIndex == 3,
                ),
                label: 'Conquistas',
              ),
              BottomNavigationBarItem(
                icon: _NavIcon(
                  icon: Icons.person_rounded,
                  isSelected: _currentIndex == 4,
                ),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _NavIcon({required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(isSelected ? 6 : 0),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 22),
    );
  }
}
