import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../auth/login_screen.dart';
import '../exercises/exercises_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _AdminHome(),
    const _StudentsTab(),
    const _AdminWorkoutsTab(),
    const _AdminSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.grey700, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.grey500,
            selectedLabelStyle: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
            unselectedLabelStyle:
                const TextStyle(fontSize: 10, fontFamily: 'Poppins'),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Painel',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outlined),
                activeIcon: Icon(Icons.people_rounded),
                label: 'Alunos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center_outlined),
                activeIcon: Icon(Icons.fitness_center_rounded),
                label: 'Treinos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Config',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ADMIN HOME ====================
class _AdminHome extends StatelessWidget {
  const _AdminHome();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Painel Marcelly',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Personal Trainer',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'MF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Stats overview
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _adminStat(
                      '${appState.students.length}',
                      'Alunos Ativos',
                      Icons.people_rounded,
                      AppColors.primary),
                  _adminStat(
                      '${appState.workouts.length}',
                      'Treinos Criados',
                      Icons.fitness_center_rounded,
                      AppColors.info),
                  _adminStat(
                      '${appState.sessions.where((s) => s.status == 'realizada').length}',
                      'Aulas Realizadas',
                      Icons.check_circle_rounded,
                      AppColors.success),
                  _adminStat(
                      '${appState.exercises.length}',
                      'Exercícios',
                      Icons.list_alt_rounded,
                      AppColors.warning),
                ],
              ).animate(delay: 100.ms).fadeIn(),

              const SizedBox(height: 24),

              // Quick actions
              const SectionHeader(title: 'Ações Rápidas'),
              const SizedBox(height: 14),
              _buildQuickActions(context),

              const SizedBox(height: 24),

              // Recent students
              SectionHeader(
                title: 'Alunos Recentes',
                actionText: 'Ver todos',
                onAction: () {},
              ),
              const SizedBox(height: 12),

              ...appState.students.take(3).map((student) => GestureDetector(
                    onTap: () => _showStudentDetail(context, student),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                student.name
                                    .split(' ')
                                    .map((n) => n[0])
                                    .take(2)
                                    .join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                                  student.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  student.objective ?? student.contractedPlan ?? '',
                                  style: const TextStyle(
                                    color: AppColors.grey500,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          LevelBadge(level: student.level),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adminStat(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 26),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
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
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.9,
      children: [
        _adminAction(context, '👤', 'Novo Aluno',
            () => _showAddStudentDialog(context)),
        _adminAction(context, '🏋️', 'Novo Treino',
            () => _showAddWorkoutDialog(context)),
        _adminAction(context, '📚', 'Exercícios',
            () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ExercisesScreen()))),
        _adminAction(context, '📅', 'Agendar Aula', () {}),
        _adminAction(context, '📊', 'Avaliação', () {}),
        _adminAction(context, '🥗', 'Dieta', () {}),
      ],
    );
  }

  Widget _adminAction(
      BuildContext context, String emoji, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: DarkCard(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.grey300,
                fontSize: 11,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showStudentDetail(BuildContext context, dynamic student) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => _StudentDetailSheet(student: student),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddStudentForm(),
    );
  }

  void _showAddWorkoutDialog(BuildContext context) {
    final appState = context.read<AppState>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _AddWorkoutForm(students: appState.students),
    );
  }
}

// ==================== STUDENTS TAB ====================
class _StudentsTab extends StatelessWidget {
  const _StudentsTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final students = appState.students;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alunos',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: ctx,
                        backgroundColor: AppColors.surface,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => _AddStudentForm(),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: students.length,
                itemBuilder: (ctx, i) {
                  final student = students[i];
                  return GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.surface,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => _StudentDetailSheet(student: student),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                student.name
                                    .split(' ')
                                    .map((n) => n[0])
                                    .take(2)
                                    .join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
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
                                  student.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  student.contractedPlan ?? 'Sem plano ativo',
                                  style: const TextStyle(
                                    color: AppColors.grey500,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    LevelBadge(level: student.level),
                                    const SizedBox(width: 6),
                                    const Text('🔥',
                                        style: TextStyle(fontSize: 12)),
                                    Text(
                                      ' ${student.currentStreak}d',
                                      style: const TextStyle(
                                        color: AppColors.warning,
                                        fontSize: 11,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${student.totalPoints} pts',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.chevron_right,
                                  color: AppColors.grey500, size: 18),
                            ],
                          ),
                        ],
                      ),
                    ).animate(
                      delay: Duration(milliseconds: 80 * i),
                    ).fadeIn(duration: 300.ms),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== STUDENT DETAIL SHEET ====================
class _StudentDetailSheet extends StatelessWidget {
  final dynamic student;
  const _StudentDetailSheet({required this.student});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) => SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            // Student header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      student.name.split(' ').map((n) => n[0]).take(2).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
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
                        student.name,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        student.email,
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      LevelBadge(level: student.level, large: true),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _detailRow('Objetivo', student.objective ?? 'Não definido'),
            _detailRow('Plano', student.contractedPlan ?? 'Sem plano'),
            _detailRow('Peso atual', '${student.currentWeight}kg'),
            _detailRow('Meta', '${student.targetWeight}kg'),
            _detailRow('Sequência', '🔥 ${student.currentStreak} dias'),
            _detailRow('Pontos', '⚡ ${student.totalPoints} pts'),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: PinkButton(
                    text: 'Ver Treino',
                    isOutlined: true,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PinkButton(
                    text: 'Mensagem',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.grey500,
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ADMIN WORKOUTS TAB ====================
class _AdminWorkoutsTab extends StatelessWidget {
  const _AdminWorkoutsTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final workouts = appState.workouts;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton.extended(
          onPressed: () {
            final appState = ctx.read<AppState>();
            showModalBottomSheet(
              context: ctx,
              backgroundColor: AppColors.surface,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => _AddWorkoutForm(students: appState.students),
            );
          },
          backgroundColor: AppColors.primary,
          label: const Text('Novo Treino',
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
          icon: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Treinos',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (ctx, i) {
                    final workout = workouts[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.fitness_center,
                                color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  '${workout.dayOfWeek} · ${workout.exercises.length} exercícios',
                                  style: const TextStyle(
                                    color: AppColors.grey500,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_outlined,
                                    color: AppColors.grey500, size: 18),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.copy_outlined,
                                    color: AppColors.grey500, size: 18),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== ADMIN SETTINGS TAB ====================
class _AdminSettingsTab extends StatelessWidget {
  const _AdminSettingsTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Configurações',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),

              _settingsItem(
                  context, Icons.person_outlined, 'Meu Perfil', 'Personal Trainer'),
              _settingsItem(context, Icons.notifications_outlined,
                  'Notificações', 'Enviar alertas aos alunos'),
              _settingsItem(context, Icons.video_library_outlined,
                  'Biblioteca de Vídeos', 'Gerenciar vídeos'),
              _settingsItem(context, Icons.bar_chart_rounded,
                  'Relatórios', 'Ver estatísticas'),
              _settingsItem(context, Icons.help_outline_rounded,
                  'Suporte', 'Central de ajuda'),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () async {
                  await appState.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            color: AppColors.error, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Sair da conta',
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsItem(
      BuildContext context, IconData icon, String label, String subtitle) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.grey500,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.grey500, size: 20),
          ],
        ),
      ),
    );
  }
}

// ==================== FORMULÁRIO CADASTRO DE ALUNO ====================
class _AddStudentForm extends StatefulWidget {
  const _AddStudentForm();

  @override
  State<_AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<_AddStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _goalWeightCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _selectedObjective = 'Emagrecimento';
  String _selectedPlan = 'Mensal';
  bool _isLoading = false;

  final List<String> _objectives = [
    'Emagrecimento',
    'Hipertrofia',
    'Condicionamento',
    'Saúde e Bem-estar',
    'Reabilitação',
    'Performance',
  ];

  final List<String> _plans = [
    'Avulso',
    'Mensal',
    'Trimestral',
    'Semestral',
    'Anual',
    'Online',
    'Presencial + Online',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    _goalWeightCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400));

    final newStudent = UserModel(
      id: 'student_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      role: 'student',
      objective: _selectedObjective,
      contractedPlan: _selectedPlan,
      age: int.tryParse(_ageCtrl.text) ?? 0,
      currentWeight: double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0,
      targetWeight: double.tryParse(_goalWeightCtrl.text.replaceAll(',', '.')) ?? 0,
      height: double.tryParse(_heightCtrl.text.replaceAll(',', '.')) ?? 0,
      trainerNotes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      level: 'beginner',
      totalPoints: 0,
      currentStreak: 0,
      createdAt: DateTime.now(),
    );

    if (mounted) {
      context.read<AppState>().addStudent(newStudent);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                '✅ ${newStudent.name} cadastrada com sucesso!',
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.grey500, fontFamily: 'Poppins', fontSize: 13),
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primary, size: 20) : null,
      filled: true,
      fillColor: AppColors.cardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grey800, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.97,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => Form(
          key: _formKey,
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '👤 Cadastrar Aluna',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.grey800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close, color: AppColors.grey500, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.grey800, height: 1),

              // Form fields
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // Seção: Dados Pessoais
                    _sectionTitle('Dados Pessoais'),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration('Nome completo *', icon: Icons.person_outline),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('E-mail *', icon: Icons.email_outlined),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                        if (!v.contains('@')) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _phoneCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration('Telefone / WhatsApp', icon: Icons.phone_outlined),
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _ageCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Idade', icon: Icons.cake_outlined),
                    ),
                    const SizedBox(height: 24),

                    // Seção: Dados Físicos
                    _sectionTitle('Dados Físicos'),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightCtrl,
                            style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration('Peso atual (kg)', icon: Icons.monitor_weight_outlined),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _heightCtrl,
                            style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration('Altura (m)', icon: Icons.height_rounded),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _goalWeightCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration('Peso meta (kg)', icon: Icons.flag_outlined),
                    ),
                    const SizedBox(height: 24),

                    // Seção: Objetivo e Plano
                    _sectionTitle('Objetivo e Plano'),
                    const SizedBox(height: 12),

                    // Objetivo
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey800),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedObjective,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 14),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          items: _objectives.map((o) => DropdownMenuItem(
                            value: o,
                            child: Row(
                              children: [
                                const Icon(Icons.track_changes_rounded, color: AppColors.primary, size: 18),
                                const SizedBox(width: 10),
                                Text(o),
                              ],
                            ),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedObjective = v!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Plano
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey800),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedPlan,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 14),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          items: _plans.map((p) => DropdownMenuItem(
                            value: p,
                            child: Row(
                              children: [
                                const Icon(Icons.card_membership_rounded, color: AppColors.primary, size: 18),
                                const SizedBox(width: 10),
                                Text(p),
                              ],
                            ),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedPlan = v!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Seção: Observações
                    _sectionTitle('Observações (opcional)'),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _notesCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                      maxLines: 3,
                      decoration: _inputDecoration('Restrições, lesões, informações importantes...').copyWith(
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botão Salvar
                    GestureDetector(
                      onTap: _isLoading ? null : _salvar,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text(
                                      'Cadastrar Aluna',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Botão cancelar
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.grey800,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppColors.grey500,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.grey300,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ==================== FORMULÁRIO NOVO TREINO ====================
class _AddWorkoutForm extends StatefulWidget {
  final List<UserModel> students;
  const _AddWorkoutForm({required this.students});

  @override
  State<_AddWorkoutForm> createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<_AddWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _selectedDay = 'Segunda';
  String? _selectedStudentId;
  final List<String> _selectedMuscles = [];
  bool _isLoading = false;

  final List<String> _days = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];
  final List<String> _muscleGroups = [
    'Glúteos', 'Quadríceps', 'Posterior de Coxa', 'Panturrilha',
    'Peito', 'Costas', 'Ombros', 'Bíceps', 'Tríceps', 'Abdômen', 'Lombar',
  ];

  // Exercícios adicionados ao treino
  final List<Map<String, dynamic>> _exercises = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      _exercises.add({
        'name': '',
        'sets': '3',
        'reps': '12',
        'rest': '60',
        'nameCtrl': TextEditingController(),
        'setsCtrl': TextEditingController(text: '3'),
        'repsCtrl': TextEditingController(text: '12'),
        'restCtrl': TextEditingController(text: '60'),
        'noteCtrl': TextEditingController(),
      });
    });
  }

  void _removeExercise(int index) {
    setState(() {
      (_exercises[index]['nameCtrl'] as TextEditingController).dispose();
      (_exercises[index]['setsCtrl'] as TextEditingController).dispose();
      (_exercises[index]['repsCtrl'] as TextEditingController).dispose();
      (_exercises[index]['restCtrl'] as TextEditingController).dispose();
      (_exercises[index]['noteCtrl'] as TextEditingController).dispose();
      _exercises.removeAt(index);
    });
  }

  void _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Selecione uma aluna para o treino!'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Adicione pelo menos 1 exercício!'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));

    final exerciseList = _exercises.asMap().entries.map((e) {
      final ex = e.value;
      final name = (ex['nameCtrl'] as TextEditingController).text.trim();
      return WorkoutExercise(
        exerciseId: 'ex_custom_${DateTime.now().millisecondsSinceEpoch}_${e.key}',
        exerciseName: name.isEmpty ? 'Exercício ${e.key + 1}' : name,
        muscleGroup: _selectedMuscles.isNotEmpty ? _selectedMuscles.first : 'Geral',
        sets: int.tryParse((ex['setsCtrl'] as TextEditingController).text) ?? 3,
        reps: int.tryParse((ex['repsCtrl'] as TextEditingController).text) ?? 12,
        restSeconds: int.tryParse((ex['restCtrl'] as TextEditingController).text) ?? 60,
        trainerNote: (ex['noteCtrl'] as TextEditingController).text.trim().isEmpty
            ? null
            : (ex['noteCtrl'] as TextEditingController).text.trim(),
      );
    }).toList();

    final workout = WorkoutModel(
      id: 'wk_custom_${DateTime.now().millisecondsSinceEpoch}',
      studentId: _selectedStudentId!,
      name: _nameCtrl.text.trim(),
      dayOfWeek: _selectedDay,
      muscleGroups: _selectedMuscles.isEmpty ? ['Geral'] : List.from(_selectedMuscles),
      exercises: exerciseList,
      trainerNotes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    if (mounted) {
      context.read<AppState>().addWorkout(workout);
      Navigator.pop(context);
      final studentName = widget.students
          .firstWhere((s) => s.id == _selectedStudentId, orElse: () => widget.students.first)
          .name;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.fitness_center, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '✅ Treino "${workout.name}" criado para $studentName!',
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ));
    }
  }

  InputDecoration _input(String label, {IconData? icon}) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey500, fontFamily: 'Poppins', fontSize: 13),
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primary, size: 18) : null,
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey800)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.94,
        maxChildSize: 0.97,
        minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => Form(
          key: _formKey,
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.grey700, borderRadius: BorderRadius.circular(2)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('🏋️ Criar Treino',
                        style: TextStyle(color: AppColors.white, fontSize: 20,
                            fontWeight: FontWeight.w800, fontFamily: 'Poppins')),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: AppColors.grey800, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.close, color: AppColors.grey500, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: AppColors.grey800, height: 1),

              // Campos
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  children: [
                    // Aluna
                    _sectionLabel('Para qual aluna?'),
                    const SizedBox(height: 10),
                    widget.students.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_rounded, color: AppColors.error, size: 18),
                                SizedBox(width: 10),
                                Text('Nenhuma aluna cadastrada ainda.\nCadastre uma aluna primeiro!',
                                    style: TextStyle(color: AppColors.grey300, fontSize: 13, fontFamily: 'Poppins')),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.grey800),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedStudentId,
                                isExpanded: true,
                                hint: const Text('Selecionar aluna...',
                                    style: TextStyle(color: AppColors.grey500, fontFamily: 'Poppins', fontSize: 14)),
                                dropdownColor: AppColors.surface,
                                style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 14),
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                items: widget.students.map((s) => DropdownMenuItem(
                                  value: s.id,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                                        child: Text(s.name[0],
                                            style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(s.name),
                                    ],
                                  ),
                                )).toList(),
                                onChanged: (v) => setState(() => _selectedStudentId = v),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),

                    // Nome do treino
                    _sectionLabel('Nome do Treino'),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins'),
                      textCapitalization: TextCapitalization.words,
                      decoration: _input('Ex: Treino A - Glúteos e Pernas', icon: Icons.fitness_center_outlined),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome do treino' : null,
                    ),
                    const SizedBox(height: 16),

                    // Dia da semana
                    _sectionLabel('Dia da Semana'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _days.map((d) {
                        final isSelected = _selectedDay == d;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = d),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.primaryGradient : null,
                              color: isSelected ? null : AppColors.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: isSelected ? Colors.transparent : AppColors.grey700),
                            ),
                            child: Text(d,
                                style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.grey300,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                    fontFamily: 'Poppins')),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Grupos musculares
                    _sectionLabel('Grupos Musculares'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _muscleGroups.map((m) {
                        final isSelected = _selectedMuscles.contains(m);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (isSelected) _selectedMuscles.remove(m);
                            else _selectedMuscles.add(m);
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.2)
                                  : AppColors.cardBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.grey700),
                            ),
                            child: Text(m,
                                style: TextStyle(
                                    color: isSelected ? AppColors.primary : AppColors.grey300,
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    fontFamily: 'Poppins')),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Exercícios
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionLabel('Exercícios (${_exercises.length})'),
                        GestureDetector(
                          onTap: _addExercise,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text('Adicionar', style: TextStyle(color: Colors.white, fontSize: 12,
                                    fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (_exercises.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey800, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          children: [
                            Text('🏋️', style: TextStyle(fontSize: 36)),
                            SizedBox(height: 8),
                            Text('Nenhum exercício ainda',
                                style: TextStyle(color: AppColors.grey500, fontSize: 13, fontFamily: 'Poppins')),
                            Text('Toque em "+ Adicionar" para incluir',
                                style: TextStyle(color: AppColors.grey700, fontSize: 11, fontFamily: 'Poppins')),
                          ],
                        ),
                      )
                    else
                      ..._exercises.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ex = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey800),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 28, height: 28,
                                    decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                                    child: Center(child: Text('${i + 1}',
                                        style: const TextStyle(color: Colors.white, fontSize: 12,
                                            fontWeight: FontWeight.w700))),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text('Exercício',
                                      style: TextStyle(color: AppColors.grey300, fontSize: 13,
                                          fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => _removeExercise(i),
                                    child: const Icon(Icons.delete_outline_rounded,
                                        color: AppColors.error, size: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: ex['nameCtrl'] as TextEditingController,
                                style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                                textCapitalization: TextCapitalization.words,
                                decoration: _input('Nome do exercício *', icon: Icons.sports_gymnastics),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(child: TextField(
                                    controller: ex['setsCtrl'] as TextEditingController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                                    decoration: _input('Séries'),
                                  )),
                                  const SizedBox(width: 8),
                                  Expanded(child: TextField(
                                    controller: ex['repsCtrl'] as TextEditingController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                                    decoration: _input('Reps'),
                                  )),
                                  const SizedBox(width: 8),
                                  Expanded(child: TextField(
                                    controller: ex['restCtrl'] as TextEditingController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                                    decoration: _input('Descanso(s)'),
                                  )),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: ex['noteCtrl'] as TextEditingController,
                                style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 12),
                                decoration: _input('Observação para a aluna (opcional)', icon: Icons.chat_bubble_outline),
                              ),
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 16),

                    // Observações gerais
                    _sectionLabel('Observações do Treino (opcional)'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesCtrl,
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Poppins', fontSize: 13),
                      maxLines: 2,
                      decoration: _input('Mensagem motivacional ou instruções gerais...', icon: Icons.edit_note_rounded),
                    ),
                    const SizedBox(height: 28),

                    // Botão salvar
                    GestureDetector(
                      onTap: _isLoading ? null : _salvar,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(width: 22, height: 22,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.fitness_center, color: Colors.white, size: 20),
                                    SizedBox(width: 10),
                                    Text('Criar Treino', style: TextStyle(color: Colors.white, fontSize: 16,
                                        fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(color: AppColors.grey800, borderRadius: BorderRadius.circular(14)),
                        child: const Center(child: Text('Cancelar',
                            style: TextStyle(color: AppColors.grey500, fontSize: 14,
                                fontWeight: FontWeight.w600, fontFamily: 'Poppins'))),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) => Row(
    children: [
      Container(width: 3, height: 14,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(color: AppColors.grey300, fontSize: 13,
          fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
    ],
  );
}
