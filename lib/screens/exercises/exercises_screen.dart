import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  String _selectedGroup = 'Todos';
  String _searchQuery = '';

  final List<String> _muscleGroups = [
    'Todos',
    'Glúteos',
    'Quadríceps',
    'Posterior de Coxa',
    'Panturrilha',
    'Costas',
    'Peito',
    'Ombros',
    'Bíceps',
    'Tríceps',
    'Abdômen',
    'Cardio',
    'Funcional',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    var exercises = appState.exercises;

    if (_selectedGroup != 'Todos') {
      exercises = exercises
          .where((e) => e.muscleGroup == _selectedGroup)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      exercises = exercises
          .where((e) =>
              e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Biblioteca de Exercícios',
        showBack: true,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextFormField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(
                  color: AppColors.white, fontFamily: 'Poppins'),
              decoration: InputDecoration(
                hintText: 'Buscar exercício...',
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.grey500, size: 20),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          // Filter chips
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _muscleGroups.length,
              itemBuilder: (ctx, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MuscleGroupChip(
                  label: _muscleGroups[i],
                  isSelected: _selectedGroup == _muscleGroups[i],
                  onTap: () =>
                      setState(() => _selectedGroup = _muscleGroups[i]),
                ),
              ),
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 8),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${exercises.length} exercícios',
                style: const TextStyle(
                  color: AppColors.grey500,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Exercises list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: exercises.length,
              itemBuilder: (ctx, i) => _ExerciseListTile(
                exercise: exercises[i],
                index: i,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseListTile extends StatelessWidget {
  final ExerciseModel exercise;
  final int index;

  const _ExerciseListTile({required this.exercise, required this.index});

  Color get _difficultyColor {
    switch (exercise.difficulty) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  String get _difficultyLabel {
    switch (exercise.difficulty) {
      case 'beginner':
        return 'Iniciante';
      case 'intermediate':
        return 'Intermediário';
      case 'advanced':
        return 'Avançado';
      default:
        return exercise.difficulty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (_) => _ExerciseDetailSheet(exercise: exercise),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.grey700.withValues(alpha: 0.4), width: 0.5),
        ),
        child: Row(
          children: [
            // Muscle group icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _getMuscleEmoji(exercise.muscleGroup),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        exercise.muscleGroup,
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _difficultyColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _difficultyLabel,
                          style: TextStyle(
                            color: _difficultyColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (exercise.equipment.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      exercise.equipment.join(', '),
                      style: const TextStyle(
                        color: AppColors.grey500,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  '${exercise.defaultSets}x${exercise.defaultReps}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right,
                    color: AppColors.grey500, size: 20),
              ],
            ),
          ],
        ),
      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms),
    );
  }

  String _getMuscleEmoji(String group) {
    switch (group) {
      case 'Glúteos':
        return '🍑';
      case 'Quadríceps':
        return '🦵';
      case 'Posterior de Coxa':
        return '🦿';
      case 'Panturrilha':
        return '🦶';
      case 'Costas':
        return '🔙';
      case 'Peito':
        return '💪';
      case 'Ombros':
        return '⚡';
      case 'Bíceps':
        return '💪';
      case 'Tríceps':
        return '🏋️';
      case 'Abdômen':
        return '🎯';
      case 'Cardio':
        return '🏃';
      default:
        return '💪';
    }
  }
}

class _ExerciseDetailSheet extends StatelessWidget {
  final ExerciseModel exercise;

  const _ExerciseDetailSheet({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    exercise.muscleGroup,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('Séries', '${exercise.defaultSets}'),
                _stat('Reps', '${exercise.defaultReps}'),
                _stat('Descanso', '${exercise.defaultRestSeconds}s'),
              ],
            ),

            const SizedBox(height: 20),

            // Equipment
            if (exercise.equipment.isNotEmpty) ...[
              const Text(
                'Equipamentos',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: exercise.equipment
                    .map((eq) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.grey800,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            eq,
                            style: const TextStyle(
                              color: AppColors.grey300,
                              fontSize: 13,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Execution
            const Text(
              'Como Executar',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                exercise.executionInstructions,
                style: const TextStyle(
                  color: AppColors.grey300,
                  fontSize: 14,
                  height: 1.6,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            if (exercise.commonMistakes.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Erros Comuns',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.2), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        exercise.commonMistakes,
                        style: const TextStyle(
                          color: AppColors.grey300,
                          fontSize: 14,
                          height: 1.6,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return DarkCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.grey500,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
