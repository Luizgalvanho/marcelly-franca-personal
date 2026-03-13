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
  final List<String> _days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

  @override
  void initState() {
    super.initState();
    final today = DateTime.now().weekday;
    final initialIndex = (today - 1).clamp(0, 5);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meu Treino',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Sua ficha personalizada',
                        style: TextStyle(
                          color: AppColors.grey500,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fitness_center,
                        color: AppColors.primary, size: 24),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // Tab bar - days of week
            Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (ctx, i) {
                  final isSelected = _tabController.index == i;
                  final today = DateTime.now().weekday - 1;
                  final isToday = i == today;
                  return GestureDetector(
                    onTap: () => setState(() => _tabController.index = i),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: isToday && !isSelected
                            ? Border.all(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                width: 1)
                            : null,
                      ),
                      child: Text(
                        _days[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.grey300,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 16),

            // Content
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

class _DayWorkout extends StatelessWidget {
  final String day;
  const _DayWorkout({required this.day});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final workout = appState.workouts.where((w) =>
        w.dayOfWeek.toLowerCase() == day.toLowerCase() &&
        w.studentId == (appState.currentUser?.id ?? 'student_001')).firstOrNull;

    if (workout == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😴', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Dia de descanso',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Descanse, hidrate-se e\nprepare-se para amanhã!',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1, 1),
            ),
      );
    }

    return _WorkoutDetail(workout: workout);
  }
}

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
          // Workout header card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D0A1C), Color(0xFF1A0A14)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: AppColors.success, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Concluído',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: workout.muscleGroups
                      .map((g) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              g,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontFamily: 'Poppins',
                              ),
                            ),
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
                        color: AppColors.grey300,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.grey800,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 20),

          const Text(
            'Exercícios',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          // Exercises list
          ...workout.exercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;
            return _ExerciseCard(
              exercise: exercise,
              workoutId: workout.id,
              index: index + 1,
            )
                .animate(delay: Duration(milliseconds: 100 * index))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.05, end: 0);
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

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
    final appState = context.read<AppState>();
    final weight = double.tryParse(_weightController.text);
    appState.markExerciseDone(
      widget.workoutId,
      widget.exercise.exerciseId,
      weight: weight,
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final isDone = ex.isDone;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: 200.ms,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.success.withValues(alpha: 0.08)
              : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDone
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.grey700.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Number badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: isDone ? null : AppColors.primaryGradient,
                      color: isDone ? AppColors.success.withValues(alpha: 0.2) : null,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check,
                              color: AppColors.success, size: 18)
                          : Text(
                              '${widget.index}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.exerciseName,
                          style: TextStyle(
                            color: isDone
                                ? AppColors.grey300
                                : AppColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _exInfo(
                                '${ex.sets}x${ex.reps}',
                                Icons.repeat),
                            const SizedBox(width: 12),
                            _exInfo(
                                '${ex.restSeconds}s',
                                Icons.timer_outlined),
                            if (ex.weight != null) ...[
                              const SizedBox(width: 12),
                              _exInfo(
                                  '${ex.weight}kg',
                                  Icons.fitness_center),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.grey500,
                    size: 20,
                  ),
                ],
              ),
            ),
            // Expanded content
            if (_expanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.grey800.withValues(alpha: 0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ex.trainerNote != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🏋️',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ex.trainerNote!,
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
                      const SizedBox(height: 10),
                    ],
                    // Weight input
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Carga (kg)',
                              hintStyle: const TextStyle(
                                  color: AppColors.grey500, fontSize: 13),
                              prefixIcon: const Icon(
                                Icons.fitness_center,
                                color: AppColors.grey500,
                                size: 18,
                              ),
                              filled: true,
                              fillColor: AppColors.grey800,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _markDone,
                          child: AnimatedContainer(
                            duration: 200.ms,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isDone ? null : AppColors.primaryGradient,
                              color: isDone
                                  ? AppColors.success.withValues(alpha: 0.2)
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              border: isDone
                                  ? Border.all(
                                      color: AppColors.success, width: 1)
                                  : null,
                            ),
                            child: Text(
                              isDone ? 'Feito ✓' : 'Marcar',
                              style: TextStyle(
                                color: isDone
                                    ? AppColors.success
                                    : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (ex.weightHistory.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Histórico: ${ex.weightHistory.map((w) => '${w}kg').join(' → ')}',
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 11,
                          fontFamily: 'Poppins',
                        ),
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

  Widget _exInfo(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.grey500, size: 12),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.grey500,
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
