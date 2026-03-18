import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];

  @override
  void initState() {
    super.initState();
    // Abre no dia atual automaticamente
    final today = DateTime.now().weekday - 1; // 0=Segunda ... 6=Domingo
    final initialIndex = today.clamp(0, 6);
    _tabController = TabController(
      length: _days.length,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final totalWorkouts = appState.workouts
        .where((w) => w.studentId == (appState.currentUser?.id ?? 'student_001'))
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meu Treino 💪',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '$totalWorkouts treinos na semana',
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${appState.currentUser?.totalPoints ?? 0} pts',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 16),

            // ── Tabs dos dias ────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _days.length,
                itemBuilder: (ctx, i) {
                  final isSelected = _tabController.index == i;
                  final today = DateTime.now().weekday - 1;
                  final isToday = i == today;

                  // Verifica se existe treino nesse dia
                  final hasWorkout = appState.workouts.any((w) =>
                      w.dayOfWeek.toLowerCase() == _days[i].toLowerCase() &&
                      w.studentId == (appState.currentUser?.id ?? 'student_001'));

                  return GestureDetector(
                    onTap: () => setState(() => _tabController.index = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: isToday && !isSelected
                            ? Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 1.5)
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _days[i].substring(0, 3),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.grey300,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (hasWorkout && !isSelected) ...[
                            const SizedBox(width: 5),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                          if (isToday) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'hoje',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 12),

            // ── Conteúdo ─────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _days.map((day) => _DayWorkout(day: day)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────
class _DayWorkout extends StatelessWidget {
  final String day;
  const _DayWorkout({required this.day});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final studentId = appState.currentUser?.id ?? 'student_001';

    final workout = appState.workouts
        .where((w) =>
            w.dayOfWeek.toLowerCase() == day.toLowerCase() &&
            w.studentId == studentId)
        .firstOrNull;

    if (workout == null) {
      return _RestDayView(day: day);
    }

    return _WorkoutDetail(workout: workout);
  }
}

// ── Tela de descanso ─────────────────────────────────────────
class _RestDayView extends StatelessWidget {
  final String day;
  const _RestDayView({required this.day});

  static const _tips = [
    '💧 Hidrate-se bastante hoje!',
    '🧘 Alongamento leve ajuda na recuperação',
    '😴 Sono de qualidade é treino também',
    '🥗 Aproveite para caprichar na alimentação',
    '🛁 Uma massagem relaxante faz bem à musculatura',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.grey800),
            ),
            child: Column(
              children: [
                const Text('😴', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'Dia de Descanso',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nenhum treino agendado para $day.\nDescanse, recupere e volte mais forte! 🔥',
                  style: const TextStyle(
                    color: AppColors.grey500,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
              ),

          const SizedBox(height: 24),

          // Dicas do dia
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 3, height: 16,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dicas para o dia de descanso',
                  style: TextStyle(
                    color: AppColors.grey300,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ..._tips.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey800),
            ),
            child: Row(
              children: [
                Text(e.value.substring(0, 2), style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.value.substring(3),
                    style: const TextStyle(
                      color: AppColors.grey300,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ).animate(delay: Duration(milliseconds: 80 * e.key)).fadeIn()),

          const SizedBox(height: 24),

          // Botão: ver treinos da semana
          GestureDetector(
            onTap: () {
              // Navega para o primeiro dia com treino
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Navegue pelos dias acima para ver seus treinos! 💪'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Ver treinos da semana →',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ── Detalhe do treino ────────────────────────────────────────
class _WorkoutDetail extends StatelessWidget {
  final WorkoutModel workout;
  const _WorkoutDetail({required this.workout});

  @override
  Widget build(BuildContext context) {
    final progress = workout.progress;
    final doneCount = workout.exercises.where((e) => e.isDone).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header do treino
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D0A1C), Color(0xFF1A0A14)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        workout.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    if (workout.isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success, size: 14),
                            SizedBox(width: 4),
                            Text('Concluído!',
                                style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: workout.muscleGroups
                      .map((g) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(g,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11,
                                    fontFamily: 'Poppins')),
                          ))
                      .toList(),
                ),
                if (workout.trainerNotes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.grey800.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💬', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            workout.trainerNotes!,
                            style: const TextStyle(
                              color: AppColors.grey300,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      '$doneCount/${workout.exercises.length} exercícios',
                      style: const TextStyle(
                          color: AppColors.grey300, fontSize: 13, fontFamily: 'Poppins'),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.grey800,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          // Título exercícios
          Row(
            children: [
              const Text(
                'Exercícios',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Text(
                '${workout.exercises.length} no total',
                style: const TextStyle(
                    color: AppColors.grey500, fontSize: 12, fontFamily: 'Poppins'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Lista de exercícios
          ...workout.exercises.asMap().entries.map((entry) {
            return _ExerciseCard(
              exercise: entry.value,
              workoutId: workout.id,
              index: entry.key + 1,
            )
                .animate(delay: Duration(milliseconds: 80 * entry.key))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.05, end: 0);
          }),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ── Card de exercício ────────────────────────────────────────
class _ExerciseCard extends StatefulWidget {
  final WorkoutExercise exercise;
  final String workoutId;
  final int index;

  const _ExerciseCard({
    required this.exercise,
    required this.workoutId,
    required this.index,
  });

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _expanded = false;
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.exercise.weight != null) {
      _weightController.text = widget.exercise.weight.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _markDone() {
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    context.read<AppState>().markExerciseDone(
          widget.workoutId,
          widget.exercise.exerciseId,
          weight: weight,
        );
    setState(() {});
    if (!widget.exercise.isDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${widget.exercise.exerciseName} concluído! 🔥',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final isDone = ex.isDone;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDone ? AppColors.success.withValues(alpha: 0.07) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDone
                ? AppColors.success.withValues(alpha: 0.4)
                : (_expanded ? AppColors.primary.withValues(alpha: 0.4) : AppColors.grey800),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Número / check
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: isDone ? null : AppColors.primaryGradient,
                      color: isDone ? AppColors.success.withValues(alpha: 0.15) : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check_rounded, color: AppColors.success, size: 20)
                          : Text(
                              '${widget.index}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppins'),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.exerciseName,
                          style: TextStyle(
                            color: isDone ? AppColors.grey300 : AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            decorationColor: AppColors.grey500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            _chip('${ex.sets}x${ex.reps}', Icons.repeat_rounded),
                            const SizedBox(width: 10),
                            _chip('${ex.restSeconds}s descanso', Icons.timer_outlined),
                            if (ex.weight != null) ...[
                              const SizedBox(width: 10),
                              _chip('${ex.weight}kg', Icons.fitness_center),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: _expanded ? AppColors.primary : AppColors.grey700,
                    size: 22,
                  ),
                ],
              ),
            ),

            // Conteúdo expandido
            if (_expanded)
              Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ex.trainerNote != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🏋️', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ex.trainerNote!,
                                style: const TextStyle(
                                  color: AppColors.grey300,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Poppins',
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Input de carga + botão marcar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(
                                color: AppColors.white, fontSize: 14, fontFamily: 'Poppins'),
                            decoration: InputDecoration(
                              hintText: 'Registrar carga (kg)',
                              hintStyle: const TextStyle(color: AppColors.grey700, fontSize: 13),
                              prefixIcon: const Icon(Icons.fitness_center, color: AppColors.grey500, size: 18),
                              filled: true,
                              fillColor: AppColors.grey800,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.primary, width: 1),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _markDone,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                            decoration: BoxDecoration(
                              gradient: isDone ? null : AppColors.primaryGradient,
                              color: isDone ? AppColors.success.withValues(alpha: 0.15) : null,
                              borderRadius: BorderRadius.circular(10),
                              border: isDone ? Border.all(color: AppColors.success, width: 1) : null,
                              boxShadow: isDone
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDone ? Icons.check_circle_rounded : Icons.check_rounded,
                                  color: isDone ? AppColors.success : Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDone ? 'Feito!' : 'Marcar',
                                  style: TextStyle(
                                    color: isDone ? AppColors.success : Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Histórico de cargas
                    if (ex.weightHistory.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, color: AppColors.grey700, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Histórico: ${ex.weightHistory.map((w) => '${w}kg').join(' → ')}',
                            style: const TextStyle(
                                color: AppColors.grey500, fontSize: 11, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.grey700, size: 12),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
              color: AppColors.grey500, fontSize: 11, fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}
