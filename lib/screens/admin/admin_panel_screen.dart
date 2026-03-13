import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Alunos'),
            Tab(text: 'Treinos'),
            Tab(text: 'Exercícios'),
            Tab(text: 'Relatórios'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: const [
          _StudentsTab(),
          _TrainingsTab(),
          _ExercisesTab(),
          _ReportsTab(),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final labels = ['Aluno', 'Treino', 'Exercício', 'Relatório'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adicionar ${labels[_tabCtrl.index]}'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

class _StudentsTab extends StatelessWidget {
  const _StudentsTab();

  @override
  Widget build(BuildContext context) {
    final students = context.watch<AppState>().students;

    return Column(
      children: [
        // Summary cards
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Total',
                  value: '${students.length}',
                  icon: Icons.people_outline,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Ativos',
                  value: '${students.length}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Online',
                  value: '2',
                  icon: Icons.wifi,
                  color: const Color(0xFF29B6F6),
                ),
              ),
            ],
          ),
        ),
        // Students list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: students.length,
            itemBuilder: (_, i) => _StudentAdminCard(student: students[i]),
          ),
        ),
      ],
    );
  }
}

class _StudentAdminCard extends StatelessWidget {
  final dynamic student;
  const _StudentAdminCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey800),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              (student.name as String).substring(0, 1),
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name as String,
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  student.objective as String? ?? '—',
                  style: const TextStyle(
                      color: AppColors.grey500, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LevelBadge(level: student.level as String),
              const SizedBox(height: 4),
              Text(
                student.contractedPlan as String? ?? '—',
                style: const TextStyle(
                    color: AppColors.grey500, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: AppColors.grey500, size: 18),
            color: AppColors.surface,
            onSelected: (val) => _handleAction(context, val, student),
            itemBuilder: (_) => [
              _menuItem('edit', Icons.edit, 'Editar'),
              _menuItem('workout', Icons.fitness_center, 'Treinos'),
              _menuItem('assessment', Icons.accessibility_new, 'Avaliação'),
              _menuItem('diet', Icons.restaurant_menu, 'Dieta'),
              _menuItem('message', Icons.message, 'Mensagem'),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.white)),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, String action, dynamic student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: ${student.name}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _TrainingsTab extends StatelessWidget {
  const _TrainingsTab();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final workouts = state.workouts;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Treinos',
                  value: '${workouts.length}',
                  icon: Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Ativos',
                  value: '${workouts.length}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: workouts.length,
            itemBuilder: (_, i) {
              final w = workouts[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey800),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fitness_center,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(w.name,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          Text(
                            '${w.dayOfWeek} • ${w.exercises.length} exercícios',
                            style: const TextStyle(
                                color: AppColors.grey500, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 4,
                      children: w.muscleGroups
                          .take(2)
                          .map((m) => MuscleGroupBadge(label: m))
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ExercisesTab extends StatelessWidget {
  const _ExercisesTab();

  @override
  Widget build(BuildContext context) {
    final exercises = context.watch<AppState>().exercises;
    final groups = exercises.map((e) => e.muscleGroup).toSet().toList()..sort();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  title: 'Exercícios',
                  value: '${exercises.length}',
                  icon: Icons.sports_gymnastics,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryCard(
                  title: 'Grupos',
                  value: '${groups.length}',
                  icon: Icons.category_outlined,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: exercises.length,
            itemBuilder: (_, i) {
              final ex = exercises[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey800),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ex.name,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              MuscleGroupBadge(label: ex.muscleGroup),
                              const SizedBox(width: 6),
                              LevelBadge(level: ex.difficulty),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: ex.isActive,
                      activeColor: AppColors.primary,
                      onChanged: (_) {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final students = state.students;
    final totalTrainings = state.workouts.where((w) => w.isCompleted).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Resumo Geral'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _SummaryCard(
                  title: 'Alunos Ativos',
                  value: '${students.length}',
                  icon: Icons.people,
                  color: AppColors.primary),
              _SummaryCard(
                  title: 'Treinos Feitos',
                  value: '$totalTrainings',
                  icon: Icons.fitness_center,
                  color: AppColors.success),
              _SummaryCard(
                  title: 'Aulas Esta Semana',
                  value: '4',
                  icon: Icons.calendar_today,
                  color: const Color(0xFF2196F3)),
              _SummaryCard(
                  title: 'Engajamento',
                  value: '87%',
                  icon: Icons.trending_up,
                  color: AppColors.warning),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Top Alunos'),
          const SizedBox(height: 12),
          ...students.asMap().entries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: e.key == 0
                            ? AppColors.warning.withValues(alpha: 0.2)
                            : AppColors.grey800,
                      ),
                      child: Center(
                        child: Text(
                          '${e.key + 1}',
                          style: TextStyle(
                            color: e.key == 0
                                ? AppColors.warning
                                : AppColors.grey500,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(e.value.name as String,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 13)),
                    ),
                    Text(
                      '${e.value.totalPoints} pts',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(title,
              style:
                  const TextStyle(color: AppColors.grey500, fontSize: 11)),
        ],
      ),
    );
  }
}
