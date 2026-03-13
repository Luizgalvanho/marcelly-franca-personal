import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../training/workout_screen.dart';
import '../assessment/assessment_screen.dart';
import '../diet/diet_screen.dart';
import '../hydration/hydration_screen.dart';
import '../packages/packages_screen.dart';
import '../gamification/gamification_screen.dart';
import '../schedule/schedule_screen.dart';
import '../videos/videos_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final today = state.todayWorkout;
    final pkg = state.activePackage;
    final hydration = state.todayHydration;
    final gamification = state.gamification;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A0A14),
                    AppColors.background,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: const TextStyle(
                          color: AppColors.grey300,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${user?.name.split(' ').first ?? 'Aluna'}! 💪',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Streak badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${user?.currentStreak ?? 0}d',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.cardBg,
                        child: const Icon(Icons.person,
                            color: AppColors.grey500, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Treino do Dia ──
                _SectionTitle(
                    title: 'Treino de Hoje',
                    icon: Icons.fitness_center,
                    onSeeAll: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const WorkoutScreen()))),
                const SizedBox(height: 12),
                if (today != null)
                  _TodayWorkoutCard(workout: today, context: context)
                else
                  _RestDayCard(),
                const SizedBox(height: 24),

                // ── Progresso Semanal ──
                const _SectionTitle(
                    title: 'Progresso Semanal', icon: Icons.bar_chart),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CircularProgressWidget(
                        value: state.weeklyCompletedWorkouts / 5,
                        label: '${state.weeklyCompletedWorkouts}/5',
                        sublabel: 'Treinos',
                        size: 90,
                      ),
                    ),
                    Expanded(
                      child: CircularProgressWidget(
                        value: (hydration?.progress ?? 0),
                        label: '${((hydration?.progress ?? 0) * 100).toInt()}%',
                        sublabel: 'Hidratação',
                        size: 90,
                        color: const Color(0xFF29B6F6),
                      ),
                    ),
                    Expanded(
                      child: CircularProgressWidget(
                        value: 0.75,
                        label: '75%',
                        sublabel: 'Dieta',
                        size: 90,
                        color: const Color(0xFF00E676),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Aulas Contratadas ──
                if (pkg != null) ...[
                  _SectionTitle(
                    title: 'Minhas Aulas',
                    icon: Icons.calendar_today,
                    onSeeAll: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PackagesScreen())),
                  ),
                  const SizedBox(height: 12),
                  _PackageCard(pkg: pkg),
                  const SizedBox(height: 24),
                ],

                // ── Hidratação ──
                _SectionTitle(
                  title: 'Hidratação',
                  icon: Icons.water_drop_outlined,
                  onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HydrationScreen())),
                ),
                const SizedBox(height: 12),
                _HydrationCard(hydration: hydration),
                const SizedBox(height: 24),

                // ── Gamificação ──
                _SectionTitle(
                  title: 'Meu Desempenho',
                  icon: Icons.emoji_events_outlined,
                  onSeeAll: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const GamificationScreen())),
                ),
                const SizedBox(height: 12),
                _GamificationCard(gamification: gamification, user: user),
                const SizedBox(height: 24),

                // ── Atalhos ──
                const _SectionTitle(
                    title: 'Acesso Rápido', icon: Icons.grid_view),
                const SizedBox(height: 12),
                _QuickAccessGrid(context: context),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bom dia,';
    if (h < 18) return 'Boa tarde,';
    return 'Boa noite,';
  }
}

// ── Section Title ──────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onSeeAll;

  const _SectionTitle(
      {required this.title, required this.icon, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(title,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text('Ver mais',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}

// ── Today Workout Card ────────────────────────────────────────────────────────
class _TodayWorkoutCard extends StatelessWidget {
  final dynamic workout;
  final BuildContext context;
  const _TodayWorkoutCard({required this.workout, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const WorkoutScreen())),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3D0020), Color(0xFF1A0A0A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Treino de Hoje',
                        style: TextStyle(
                            color: AppColors.grey300, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      workout.name,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.primary, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (workout.muscleGroups as List<String>)
                  .map((m) => MuscleGroupBadge(label: m))
                  .toList(),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _InfoChip(
                    icon: Icons.repeat,
                    label: '${(workout.exercises as List).length} exercícios'),
                const SizedBox(width: 10),
                _InfoChip(
                    icon: Icons.timer_outlined,
                    label: '${(workout.exercises as List).length * 8}min est.'),
              ],
            ),
            const SizedBox(height: 14),
            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${((workout.progress) * 100).toInt()}% concluído',
                  style: const TextStyle(
                      color: AppColors.grey300, fontSize: 12),
                ),
                if (workout.isCompleted)
                  const Text('✅ Completo!',
                      style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            PinkProgressBar(progress: workout.progress),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey500, size: 13),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.grey300, fontSize: 11)),
      ],
    );
  }
}

class _RestDayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DarkCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.grey800,
              shape: BoxShape.circle,
            ),
            child: const Text('😴', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dia de Descanso',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('Recuperação é parte do treino! 🌙',
                  style: TextStyle(
                      color: AppColors.grey500, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Package Card ──────────────────────────────────────────────────────────────
class _PackageCard extends StatelessWidget {
  final dynamic pkg;
  const _PackageCard({required this.pkg});

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      hasBorder: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pkg.name,
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('${pkg.remainingClasses} aulas restantes',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${pkg.completedClasses}/${pkg.totalClasses}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PinkProgressBar(progress: pkg.progress),
          const SizedBox(height: 8),
          if (pkg.isExpiringSoon || pkg.isLowClasses)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    pkg.isLowClasses
                        ? 'Poucas aulas restantes! Renove já.'
                        : 'Pacote expirando em breve!',
                    style: const TextStyle(
                        color: AppColors.warning, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Hydration Card ────────────────────────────────────────────────────────────
class _HydrationCard extends StatefulWidget {
  final dynamic hydration;
  const _HydrationCard({required this.hydration});

  @override
  State<_HydrationCard> createState() => _HydrationCardState();
}

class _HydrationCardState extends State<_HydrationCard> {
  @override
  Widget build(BuildContext context) {
    final h = widget.hydration;
    final consumed = h?.consumedLiters ?? 0.0;
    final goal = h?.goalLiters ?? 2.5;
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return DarkCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('💧', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${consumed.toStringAsFixed(1)}L / ${goal.toStringAsFixed(1)}L',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        h?.goalReached == true
                            ? '🎉 Meta atingida!'
                            : 'Meta diária de hidratação',
                        style: TextStyle(
                          color: h?.goalReached == true
                              ? AppColors.success
                              : AppColors.grey500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF29B6F6),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          PinkProgressBar(
            progress: progress,
            height: 8,
            backgroundColor: AppColors.grey800,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _WaterButton(
                  label: '+300ml',
                  onTap: () {
                    context.read<AppState>().addWaterSimple(0.3);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WaterButton(
                  label: '+500ml',
                  onTap: () {
                    context.read<AppState>().addWaterSimple(0.5);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _WaterButton(
                  label: '+1L',
                  onTap: () {
                    context.read<AppState>().addWaterSimple(1.0);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _WaterButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF29B6F6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFF29B6F6).withValues(alpha: 0.3), width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF29B6F6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Gamification Card ─────────────────────────────────────────────────────────
class _GamificationCard extends StatelessWidget {
  final dynamic gamification;
  final dynamic user;
  const _GamificationCard({required this.gamification, required this.user});

  @override
  Widget build(BuildContext context) {
    final pts = gamification?.totalPoints ?? user?.totalPoints ?? 0;
    final streak = gamification?.currentStreak ?? user?.currentStreak ?? 0;
    final level = gamification?.levelTitle ?? 'Iniciante';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1020), Color(0xFF1A0A14)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _GamStat(
                  icon: '👑',
                  label: 'Nível',
                  value: level,
                  valueColor: AppColors.primary,
                ),
              ),
              Container(
                  width: 1, height: 48, color: AppColors.grey800),
              Expanded(
                child: _GamStat(
                  icon: '⭐',
                  label: 'Pontos',
                  value: pts.toString(),
                  valueColor: AppColors.warning,
                ),
              ),
              Container(
                  width: 1, height: 48, color: AppColors.grey800),
              Expanded(
                child: _GamStat(
                  icon: '🔥',
                  label: 'Sequência',
                  value: '${streak}d',
                  valueColor: const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Next level progress
          if (gamification != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Próximo nível',
                    style:
                        TextStyle(color: AppColors.grey500, fontSize: 12)),
                Text(
                  '${pts}/${_nextLevelPts(level)}pts',
                  style: const TextStyle(
                      color: AppColors.grey300, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            PinkProgressBar(
            progress: _levelProgress(pts, level),
              height: 5,
            ),
          ],
        ],
      ),
    );
  }

  int _nextLevelPts(String level) {
    switch (level.toLowerCase()) {
      case 'iniciante': return 500;
      case 'foco': return 1500;
      case 'evolução': return 3000;
      default: return 5000;
    }
  }

  double _levelProgress(int pts, String level) {
    switch (level.toLowerCase()) {
      case 'iniciante': return pts / 500;
      case 'foco': return (pts - 500) / 1000;
      case 'evolução': return (pts - 1500) / 1500;
      default: return 1.0;
    }
  }
}

class _GamStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color valueColor;
  const _GamStat(
      {required this.icon,
      required this.label,
      required this.value,
      required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: valueColor, fontSize: 16, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.grey500, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Quick Access Grid ─────────────────────────────────────────────────────────
class _QuickAccessGrid extends StatelessWidget {
  final BuildContext context;
  const _QuickAccessGrid({required this.context});

  @override
  Widget build(BuildContext ctx) {
    final items = [
      _QAItem(icon: Icons.accessibility_new, label: 'Avaliação\nFísica',
          color: const Color(0xFF9C27B0),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AssessmentScreen()))),
      _QAItem(icon: Icons.restaurant_menu_outlined, label: 'Meu\nPlano',
          color: const Color(0xFF4CAF50),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const DietScreen()))),
      _QAItem(icon: Icons.calendar_today_outlined, label: 'Agenda',
          color: const Color(0xFF2196F3),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ScheduleScreen()))),
      _QAItem(icon: Icons.emoji_events_outlined, label: 'Conquistas',
          color: AppColors.warning,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const GamificationScreen()))),
      _QAItem(icon: Icons.water_drop_outlined, label: 'Hidratação',
          color: const Color(0xFF29B6F6),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HydrationScreen()))),
      _QAItem(icon: Icons.play_circle_outline, label: 'Vídeos\nOnline',
          color: AppColors.primary,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const VideosScreen()))),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildItem(items[i]),
    );
  }

  Widget _buildItem(_QAItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: item.color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 26),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QAItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QAItem(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});
}
