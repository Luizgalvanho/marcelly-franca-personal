import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final gam = state.gamification;
    final user = state.currentUser;
    final pts = gam?.totalPoints ?? user?.totalPoints ?? 0;
    final streak = gam?.currentStreak ?? user?.currentStreak ?? 0;
    final level = gam?.levelTitle ?? 'Iniciante';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Conquistas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3D0020), Color(0xFF1A0A14), Color(0xFF0A0A0A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const Text('👑', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    'Nível $level',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BigStat(
                          icon: '⭐',
                          value: '$pts',
                          label: 'Pontos'),
                      Container(
                          width: 1, height: 48, color: AppColors.grey800),
                      _BigStat(
                          icon: '🔥',
                          value: '${streak}d',
                          label: 'Sequência'),
                      Container(
                          width: 1, height: 48, color: AppColors.grey800),
                      _BigStat(
                          icon: '💪',
                          value: '${gam?.trainingsCompleted ?? 0}',
                          label: 'Treinos'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (gam != null && gam.currentLevel != 'elite') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Próximo nível',
                          style: const TextStyle(
                              color: AppColors.grey500, fontSize: 12),
                        ),
                        Text(
                          '${_ptsFaltam(pts, gam.currentLevel)} pts restantes',
                          style: const TextStyle(
                              color: AppColors.grey300, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    PinkProgressBar(
                        value: _levelProg(pts, gam.currentLevel),
                        height: 6),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Levels overview
            const SectionHeader(title: 'Níveis'),
            const SizedBox(height: 12),
            _LevelsRow(currentLevel: gam?.currentLevel ?? 'iniciante'),
            const SizedBox(height: 24),
            // Achievements
            const SectionHeader(title: 'Conquistas'),
            const SizedBox(height: 12),
            if (gam?.achievements.isNotEmpty == true)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: gam!.achievements.length,
                itemBuilder: (_, i) =>
                    _AchievementCard(achievement: gam.achievements[i]),
              ),
            const SizedBox(height: 24),
            // Motivational message
            if (gam?.motivationalMessages.isNotEmpty == true) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A0A14), Color(0xFF0A0A0A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    const Text('💬',
                        style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 10),
                    Text(
                      gam!.motivationalMessages[
                          DateTime.now().day % gam.motivationalMessages.length],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '— Marcelly França Personal',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  int _ptsFaltam(int pts, String level) {
    switch (level) {
      case 'iniciante': return 500 - pts;
      case 'foco': return 1500 - pts;
      case 'evolucao': return 3000 - pts;
      default: return 0;
    }
  }

  double _levelProg(int pts, String level) {
    switch (level) {
      case 'iniciante': return pts / 500;
      case 'foco': return (pts - 500) / 1000;
      case 'evolucao': return (pts - 1500) / 1500;
      default: return 1.0;
    }
  }
}

class _BigStat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  const _BigStat(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(
                color: AppColors.grey500, fontSize: 11)),
      ],
    );
  }
}

class _LevelsRow extends StatelessWidget {
  final String currentLevel;
  const _LevelsRow({required this.currentLevel});

  @override
  Widget build(BuildContext context) {
    final levels = [
      {'id': 'iniciante', 'label': 'Iniciante', 'icon': '🌱', 'pts': '0'},
      {'id': 'foco', 'label': 'Foco', 'icon': '🎯', 'pts': '500'},
      {'id': 'evolucao', 'label': 'Evolução', 'icon': '⚡', 'pts': '1.500'},
      {'id': 'elite', 'label': 'Elite', 'icon': '👑', 'pts': '3.000'},
    ];
    final currentIdx =
        levels.indexWhere((l) => l['id'] == currentLevel);

    return Row(
      children: levels.asMap().entries.map((entry) {
        final i = entry.key;
        final level = entry.value;
        final isUnlocked = i <= currentIdx;
        final isCurrent = i == currentIdx;

        return Expanded(
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : isUnlocked
                          ? AppColors.grey800
                          : AppColors.grey900,
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.primary
                        : isUnlocked
                            ? AppColors.grey700
                            : AppColors.grey900,
                    width: isCurrent ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    level['icon']!,
                    style: TextStyle(
                        fontSize: isUnlocked ? 22 : 16,
                        color: isUnlocked ? null : Colors.transparent),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                level['label']!,
                style: TextStyle(
                  color: isCurrent
                      ? AppColors.primary
                      : isUnlocked
                          ? AppColors.grey300
                          : AppColors.grey700,
                  fontSize: 10,
                  fontWeight: isCurrent
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
              Text(
                '${level['pts']} pts',
                style: const TextStyle(
                    color: AppColors.grey700, fontSize: 9),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.grey900,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.grey800,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                achievement.icon,
                style: TextStyle(
                    fontSize: 24,
                    color: achievement.isUnlocked ? null : Colors.transparent),
              ),
              if (!achievement.isUnlocked)
                const Icon(Icons.lock_outline,
                    color: AppColors.grey700, size: 16),
            ],
          ),
          const Spacer(),
          Text(
            achievement.title,
            style: TextStyle(
              color: achievement.isUnlocked
                  ? AppColors.white
                  : AppColors.grey700,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            achievement.description,
            style: const TextStyle(
              color: AppColors.grey500,
              fontSize: 10,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
