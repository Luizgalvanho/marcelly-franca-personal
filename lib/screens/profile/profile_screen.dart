import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../auth/login_screen.dart';
import '../assessment/assessment_screen.dart';
import '../diet/diet_screen.dart';
import '../packages/packages_screen.dart';
import '../gamification/gamification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final gam = state.gamification;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A0A1A), Color(0xFF0A0A0A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                            child: const Icon(Icons.person,
                                color: AppColors.primary, size: 44),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user?.name ?? 'Usuário',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.objective ?? 'Sem objetivo definido',
                            style: const TextStyle(
                              color: AppColors.grey300,
                              fontSize: 12,
                            ),
                          ),
                          if (user?.level != null) ...[
                            const SizedBox(width: 8),
                            LevelBadge(level: user!.level),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats
                Row(
                  children: [
                    Expanded(
                      child: _ProfileStat(
                        value: '${user?.totalPoints ?? 0}',
                        label: 'Pontos',
                        icon: '⭐',
                      ),
                    ),
                    Expanded(
                      child: _ProfileStat(
                        value: '${user?.currentStreak ?? 0}',
                        label: 'Dias',
                        icon: '🔥',
                      ),
                    ),
                    Expanded(
                      child: _ProfileStat(
                        value: '${gam?.trainingsCompleted ?? 0}',
                        label: 'Treinos',
                        icon: '💪',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Body info
                const SectionHeader(title: 'Meu Perfil'),
                const SizedBox(height: 12),
                DarkCard(
                  child: Column(
                    children: [
                      StatRow(
                          label: 'Peso Atual',
                          value: '${user?.currentWeight ?? 0} kg'),
                      const Divider(height: 1, color: AppColors.grey800),
                      StatRow(
                          label: 'Meta de Peso',
                          value: '${user?.targetWeight ?? 0} kg',
                          valueColor: AppColors.primary),
                      const Divider(height: 1, color: AppColors.grey800),
                      StatRow(
                          label: 'Altura',
                          value: '${user?.height ?? 0} cm'),
                      const Divider(height: 1, color: AppColors.grey800),
                      StatRow(
                          label: 'Idade',
                          value: '${user?.age ?? 0} anos'),
                      const Divider(height: 1, color: AppColors.grey800),
                      StatRow(
                          label: 'Plano',
                          value: user?.contractedPlan ?? '—',
                          valueColor: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Menu items
                const SectionHeader(title: 'Acesso Rápido'),
                const SizedBox(height: 12),
                _MenuItem(
                  icon: Icons.accessibility_new,
                  label: 'Avaliação Física',
                  color: const Color(0xFF9C27B0),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AssessmentScreen())),
                ),
                _MenuItem(
                  icon: Icons.restaurant_menu_outlined,
                  label: 'Meu Plano Alimentar',
                  color: const Color(0xFF4CAF50),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DietScreen())),
                ),
                _MenuItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Minhas Aulas',
                  color: AppColors.primary,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PackagesScreen())),
                ),
                _MenuItem(
                  icon: Icons.emoji_events_outlined,
                  label: 'Conquistas e Gamificação',
                  color: AppColors.warning,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GamificationScreen())),
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  color: const Color(0xFF2196F3),
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.help_outline,
                  label: 'Ajuda e Suporte',
                  color: AppColors.grey500,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                // Logout
                GestureDetector(
                  onTap: () async {
                    await context.read<AppState>().logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: AppColors.error, size: 18),
                        SizedBox(width: 8),
                        Text('Sair da conta',
                            style: TextStyle(
                                color: AppColors.error,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final String icon;
  const _ProfileStat(
      {required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.grey500, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.grey700, size: 18),
          ],
        ),
      ),
    );
  }
}
