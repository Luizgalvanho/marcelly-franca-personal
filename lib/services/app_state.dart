import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // Current user
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isTrainer = false;
  bool get isTrainer => _isTrainer;

  // Mock data - Students
  final List<UserModel> _students = [];
  List<UserModel> get students => _students;

  // Workouts
  final List<WorkoutModel> _workouts = [];
  List<WorkoutModel> get workouts => _workouts;

  WorkoutModel? get todayWorkout {
    final weekday = _weekdayName(DateTime.now().weekday);
    try {
      return _workouts.firstWhere(
        (w) => w.studentId == _currentUser?.id &&
            w.dayOfWeek.toLowerCase() == weekday.toLowerCase(),
      );
    } catch (_) {
      return _workouts.isNotEmpty ? _workouts.first : null;
    }
  }

  String _weekdayName(int weekday) {
    switch (weekday) {
      case 1: return 'Segunda';
      case 2: return 'Terça';
      case 3: return 'Quarta';
      case 4: return 'Quinta';
      case 5: return 'Sexta';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return 'Segunda';
    }
  }

  // Exercises library
  final List<ExerciseModel> _exercises = [];
  List<ExerciseModel> get exercises => _exercises;

  // Videos
  final List<VideoModel> _videos = [];
  List<VideoModel> get videos => _videos;

  // Packages
  final List<PackageModel> _packages = [];
  List<PackageModel> get packages => _packages;

  PackageModel? get activePackage {
    try {
      return _packages.firstWhere(
        (p) => p.studentId == _currentUser?.id && p.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  // Sessions
  final List<ClassSession> _sessions = [];
  List<ClassSession> get sessions => _sessions;

  // Assessments
  final List<PhysicalAssessment> _assessments = [];
  List<PhysicalAssessment> get assessments => _assessments;

  List<PhysicalAssessment> get myAssessments =>
      _assessments.where((a) => a.studentId == _currentUser?.id).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  // Diet
  DietPlan? _dietPlan;
  DietPlan? get dietPlan => _dietPlan;

  // Hydration
  HydrationRecord? _todayHydration;
  HydrationRecord? get todayHydration => _todayHydration;

  // Gamification
  GamificationData? _gamification;
  GamificationData? get gamification => _gamification;

  // Weekly progress
  int get weeklyCompletedWorkouts {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _workouts
        .where((w) =>
            w.studentId == _currentUser?.id &&
            w.isCompleted &&
            w.completedAt != null &&
            w.completedAt!.isAfter(weekStart))
        .length;
  }

  // Bottom nav index
  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  // Login / Logout
  Future<void> login(String email, String password) async {
    // Mock login
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.toLowerCase().contains('personal') ||
        email.toLowerCase() == 'marcelly@personal.com') {
      _currentUser = UserModel(
        id: 'trainer_001',
        name: 'Marcelly França',
        email: email,
        role: 'trainer',
        objective: 'Transformar vidas através do fitness',
        level: 'elite',
        photoUrl: null,
      );
      _isTrainer = true;
    } else {
      _currentUser = _getMockStudent(email);
      _isTrainer = false;
    }

    _isLoggedIn = true;
    _initMockData();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _currentUser!.id);
    await prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  UserModel _getMockStudent(String email) {
    return UserModel(
      id: 'student_001',
      name: 'Maria Silva',
      email: email,
      role: 'student',
      objective: 'Emagrecer e definir o corpo',
      level: 'foco',
      age: 28,
      currentWeight: 65.0,
      targetWeight: 58.0,
      height: 165.0,
      contractedPlan: 'Acompanhamento Premium',
      totalPoints: 1250,
      currentStreak: 5,
    );
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    _isTrainer = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      _currentUser = _getMockStudent('aluna@email.com');
      _isLoggedIn = true;
      _initMockData();
      notifyListeners();
    }
  }

  void _initMockData() {
    _loadExercises();
    _loadWorkouts();
    _loadVideos();
    _loadPackages();
    _loadSessions();
    _loadAssessments();
    _loadDiet();
    _loadHydration();
    _loadGamification();
    _loadStudents();
  }

  void _loadStudents() {
    _students.clear();
    _students.addAll([
      UserModel(
        id: 'student_001',
        name: 'Maria Silva',
        email: 'maria@email.com',
        role: 'student',
        objective: 'Emagrecer e definir o corpo',
        level: 'foco',
        age: 28,
        currentWeight: 65.0,
        targetWeight: 58.0,
        height: 165.0,
        contractedPlan: 'Acompanhamento Premium',
        totalPoints: 1250,
        currentStreak: 5,
      ),
      UserModel(
        id: 'student_002',
        name: 'Ana Costa',
        email: 'ana@email.com',
        role: 'student',
        objective: 'Ganho de massa muscular',
        level: 'evolucao',
        age: 32,
        currentWeight: 58.0,
        targetWeight: 62.0,
        height: 162.0,
        contractedPlan: '12 aulas mensais',
        totalPoints: 2100,
        currentStreak: 12,
      ),
      UserModel(
        id: 'student_003',
        name: 'Juliana Mendes',
        email: 'juliana@email.com',
        role: 'student',
        objective: 'Condicionamento físico',
        level: 'iniciante',
        age: 25,
        currentWeight: 72.0,
        targetWeight: 65.0,
        height: 168.0,
        contractedPlan: '8 aulas mensais',
        totalPoints: 380,
        currentStreak: 3,
      ),
      UserModel(
        id: 'student_004',
        name: 'Fernanda Lima',
        email: 'fernanda@email.com',
        role: 'student',
        objective: 'Tonificação e definição',
        level: 'foco',
        age: 35,
        currentWeight: 61.0,
        targetWeight: 57.0,
        height: 160.0,
        contractedPlan: 'Consultoria Online',
        totalPoints: 890,
        currentStreak: 7,
      ),
    ]);
  }

  void _loadExercises() {
    _exercises.clear();
    _exercises.addAll([
      ExerciseModel(
        id: 'ex001',
        name: 'Agachamento Livre',
        muscleGroup: 'Quadríceps',
        difficulty: 'intermediate',
        equipment: ['Barra', 'Suporte de barra'],
        executionInstructions:
            'Posicione os pés na largura dos ombros. Desça até as coxas ficarem paralelas ao chão. Mantenha o peito erguido e o core ativado. Empurre o chão ao subir.',
        commonMistakes: 'Joelhos para dentro, costas arredondadas, calcanhar saindo do chão.',
        defaultSets: 4,
        defaultReps: 12,
        defaultRestSeconds: 90,
        videoUrl: 'https://www.youtube.com/watch?v=ultWZbUMPL8',
      ),
      ExerciseModel(
        id: 'ex002',
        name: 'Leg Press 45°',
        muscleGroup: 'Quadríceps',
        difficulty: 'beginner',
        equipment: ['Leg Press'],
        executionInstructions:
            'Sente na máquina com as costas apoiadas. Posicione os pés na plataforma na largura dos ombros. Empurre a plataforma e retorne controlado.',
        commonMistakes: 'Tirar as costas do apoio, não descer até 90° nos joelhos.',
        defaultSets: 4,
        defaultReps: 15,
        defaultRestSeconds: 90,
        videoUrl: 'https://www.youtube.com/watch?v=IZxyjW7MPJQ',
      ),
      ExerciseModel(
        id: 'ex003',
        name: 'Hip Thrust',
        muscleGroup: 'Glúteos',
        difficulty: 'intermediate',
        equipment: ['Barra', 'Banco'],
        executionInstructions:
            'Apoie as costas no banco. Coloque a barra na pelve. Empurre os quadris para cima contraindo os glúteos. Segure 1 segundo no topo.',
        commonMistakes: 'Extensão lombar excessiva, não contrair o glúteo no pico.',
        defaultSets: 4,
        defaultReps: 12,
        defaultRestSeconds: 90,
        videoUrl: 'https://www.youtube.com/watch?v=xDmFkJxPzeM',
      ),
      ExerciseModel(
        id: 'ex004',
        name: 'Stiff com Halteres',
        muscleGroup: 'Posterior de Coxa',
        difficulty: 'intermediate',
        equipment: ['Halteres'],
        executionInstructions:
            'Em pé, halteres na frente. Incline o tronco para frente mantendo as costas neutras e joelhos levemente flexionados. Sinta o alongamento no posterior.',
        commonMistakes: 'Costas arredondadas, joelhos completamente estendidos.',
        defaultSets: 3,
        defaultReps: 12,
        defaultRestSeconds: 60,
        videoUrl: 'https://www.youtube.com/watch?v=1uDiW5--rAE',
      ),
      ExerciseModel(
        id: 'ex005',
        name: 'Remada Baixa na Polia',
        muscleGroup: 'Costas',
        difficulty: 'beginner',
        equipment: ['Polia', 'Remada Baixa'],
        executionInstructions:
            'Sente na máquina. Puxe o cabo em direção ao abdômen. Mantenha os cotovelos próximos ao corpo. Contraia as escapulas.',
        commonMistakes: 'Balançar o tronco, ombros elevados.',
        defaultSets: 3,
        defaultReps: 12,
        defaultRestSeconds: 60,
        videoUrl: 'https://www.youtube.com/watch?v=GZbfZ033f74',
      ),
      ExerciseModel(
        id: 'ex006',
        name: 'Abdominal Crunch',
        muscleGroup: 'Abdômen',
        difficulty: 'beginner',
        equipment: [],
        executionInstructions:
            'Deitado de costas, joelhos flexionados. Eleve o tronco contraindo o abdômen. Não puxe o pescoço.',
        commonMistakes: 'Puxar o pescoço, balançar o corpo.',
        defaultSets: 3,
        defaultReps: 20,
        defaultRestSeconds: 45,
      ),
      ExerciseModel(
        id: 'ex007',
        name: 'Supino Reto com Halteres',
        muscleGroup: 'Peito',
        difficulty: 'intermediate',
        equipment: ['Halteres', 'Banco Reto'],
        executionInstructions:
            'Deitado no banco, halteres à altura do peito. Empurre os halteres para cima até os braços ficarem estendidos. Desça controlado.',
        commonMistakes: 'Arco excessivo nas costas, cotovelos muito abertos.',
        defaultSets: 3,
        defaultReps: 12,
        defaultRestSeconds: 90,
        videoUrl: 'https://www.youtube.com/watch?v=VmB1G1K7v94',
      ),
      ExerciseModel(
        id: 'ex008',
        name: 'Desenvolvimento com Halteres',
        muscleGroup: 'Ombros',
        difficulty: 'intermediate',
        equipment: ['Halteres'],
        executionInstructions:
            'Sentado ou em pé. Halteres na altura dos ombros. Empurre para cima até os braços ficarem estendidos. Desça controlado.',
        commonMistakes: 'Jogar os quadris, cotovelos para trás.',
        defaultSets: 3,
        defaultReps: 12,
        defaultRestSeconds: 60,
      ),
      ExerciseModel(
        id: 'ex009',
        name: 'Rosca Direta com Barra',
        muscleGroup: 'Bíceps',
        difficulty: 'beginner',
        equipment: ['Barra'],
        executionInstructions:
            'Em pé, segure a barra com pegada supinada. Flexione os cotovelos trazendo a barra até os ombros. Desça controlado.',
        commonMistakes: 'Movimentar os cotovelos, balançar o corpo.',
        defaultSets: 3,
        defaultReps: 12,
        defaultRestSeconds: 60,
      ),
      ExerciseModel(
        id: 'ex010',
        name: 'Tríceps Pulley',
        muscleGroup: 'Tríceps',
        difficulty: 'beginner',
        equipment: ['Polia'],
        executionInstructions:
            'Em pé, frente à polia alta. Puxe o cabo para baixo estendendo os cotovelos. Mantenha os cotovelos fixos ao lado do corpo.',
        commonMistakes: 'Movimentar os cotovelos, inclinar o tronco.',
        defaultSets: 3,
        defaultReps: 15,
        defaultRestSeconds: 60,
      ),
      ExerciseModel(
        id: 'ex011',
        name: 'Panturrilha no Smith',
        muscleGroup: 'Panturrilha',
        difficulty: 'beginner',
        equipment: ['Smith'],
        executionInstructions:
            'Posicione a barra nos ombros. Coloque a ponta dos pés em um step. Suba na ponta dos pés e desça controlado.',
        commonMistakes: 'Movimento muito rápido, não descer completamente.',
        defaultSets: 4,
        defaultReps: 20,
        defaultRestSeconds: 45,
      ),
      ExerciseModel(
        id: 'ex012',
        name: 'Abdução com Elástico',
        muscleGroup: 'Glúteos',
        difficulty: 'beginner',
        equipment: ['Elásticos'],
        executionInstructions:
            'Em pé, elástico acima dos joelhos. Afaste as pernas lateralmente contra a resistência do elástico. Contraia os glúteos.',
        commonMistakes: 'Inclinar o tronco, não controlar o retorno.',
        defaultSets: 3,
        defaultReps: 20,
        defaultRestSeconds: 45,
      ),
    ]);
  }

  void _loadWorkouts() {
    _workouts.clear();
    final studentId = _currentUser?.role == 'student'
        ? _currentUser!.id
        : 'student_001';

    _workouts.addAll([
      WorkoutModel(
        id: 'wk001',
        studentId: studentId,
        name: 'Treino A - Glúteos e Pernas',
        dayOfWeek: 'Segunda',
        muscleGroups: ['Glúteos', 'Quadríceps', 'Posterior de Coxa'],
        exercises: [
          WorkoutExercise(
            exerciseId: 'ex003',
            exerciseName: 'Hip Thrust',
            muscleGroup: 'Glúteos',
            sets: 4,
            reps: 12,
            restSeconds: 90,
            trainerNote: 'Foque na contração no topo. Use carga progressiva!',
          ),
          WorkoutExercise(
            exerciseId: 'ex001',
            exerciseName: 'Agachamento Livre',
            muscleGroup: 'Quadríceps',
            sets: 4,
            reps: 12,
            restSeconds: 90,
          ),
          WorkoutExercise(
            exerciseId: 'ex002',
            exerciseName: 'Leg Press 45°',
            muscleGroup: 'Quadríceps',
            sets: 3,
            reps: 15,
            restSeconds: 75,
          ),
          WorkoutExercise(
            exerciseId: 'ex004',
            exerciseName: 'Stiff com Halteres',
            muscleGroup: 'Posterior de Coxa',
            sets: 3,
            reps: 12,
            restSeconds: 60,
          ),
          WorkoutExercise(
            exerciseId: 'ex012',
            exerciseName: 'Abdução com Elástico',
            muscleGroup: 'Glúteos',
            sets: 3,
            reps: 20,
            restSeconds: 45,
          ),
        ],
        trainerNotes: 'Treino focado em glúteos e pernas. Mantenha a técnica em todos os exercícios!',
      ),
      WorkoutModel(
        id: 'wk002',
        studentId: studentId,
        name: 'Treino B - Costas e Bíceps',
        dayOfWeek: 'Quarta',
        muscleGroups: ['Costas', 'Bíceps'],
        exercises: [
          WorkoutExercise(
            exerciseId: 'ex005',
            exerciseName: 'Remada Baixa na Polia',
            muscleGroup: 'Costas',
            sets: 4,
            reps: 12,
            restSeconds: 75,
          ),
          WorkoutExercise(
            exerciseId: 'ex009',
            exerciseName: 'Rosca Direta com Barra',
            muscleGroup: 'Bíceps',
            sets: 3,
            reps: 12,
            restSeconds: 60,
          ),
        ],
        trainerNotes: 'Foco em costas! Sinta cada repetição.',
      ),
      WorkoutModel(
        id: 'wk003',
        studentId: studentId,
        name: 'Treino C - Peito, Ombros e Tríceps',
        dayOfWeek: 'Sexta',
        muscleGroups: ['Peito', 'Ombros', 'Tríceps'],
        exercises: [
          WorkoutExercise(
            exerciseId: 'ex007',
            exerciseName: 'Supino Reto com Halteres',
            muscleGroup: 'Peito',
            sets: 3,
            reps: 12,
            restSeconds: 90,
          ),
          WorkoutExercise(
            exerciseId: 'ex008',
            exerciseName: 'Desenvolvimento com Halteres',
            muscleGroup: 'Ombros',
            sets: 3,
            reps: 12,
            restSeconds: 75,
          ),
          WorkoutExercise(
            exerciseId: 'ex010',
            exerciseName: 'Tríceps Pulley',
            muscleGroup: 'Tríceps',
            sets: 3,
            reps: 15,
            restSeconds: 60,
          ),
          WorkoutExercise(
            exerciseId: 'ex006',
            exerciseName: 'Abdominal Crunch',
            muscleGroup: 'Abdômen',
            sets: 3,
            reps: 20,
            restSeconds: 45,
          ),
        ],
        trainerNotes: 'Finalize com abdômen. Ótimo treino!',
      ),
    ]);
  }

  void _loadVideos() {
    _videos.clear();
    _videos.addAll([
      VideoModel(
        id: 'v001',
        title: 'Treino Intenso de Glúteos - 30min',
        category: 'Glúteos',
        youtubeUrl: 'https://www.youtube.com/watch?v=DyoAHTmhBaE',
        durationMinutes: 30,
        level: 'intermediario',
        objective: 'Hipertrofia de glúteos',
      ),
      VideoModel(
        id: 'v002',
        title: 'Cardio Emagrecimento - HIIT 20min',
        category: 'Cardio',
        youtubeUrl: 'https://www.youtube.com/watch?v=Mvo2snJGhtM',
        durationMinutes: 20,
        level: 'avancado',
        objective: 'Queima de gordura',
      ),
      VideoModel(
        id: 'v003',
        title: 'Treino de Pernas Completo',
        category: 'Pernas',
        youtubeUrl: 'https://www.youtube.com/watch?v=dQqApCGd5Ss',
        durationMinutes: 45,
        level: 'intermediario',
        objective: 'Força e definição',
      ),
      VideoModel(
        id: 'v004',
        title: 'Mobilidade e Flexibilidade',
        category: 'Mobilidade',
        youtubeUrl: 'https://www.youtube.com/watch?v=g_tea8ZNk5A',
        durationMinutes: 25,
        level: 'iniciante',
        objective: 'Mobilidade e prevenção',
      ),
      VideoModel(
        id: 'v005',
        title: 'Abdominal Completo - 15min',
        category: 'Abdômen',
        youtubeUrl: 'https://www.youtube.com/watch?v=DHD1-2P94DI',
        durationMinutes: 15,
        level: 'intermediario',
        objective: 'Definição abdominal',
      ),
      VideoModel(
        id: 'v006',
        title: 'Desafio da Semana - Full Body',
        category: 'Desafio',
        youtubeUrl: 'https://www.youtube.com/watch?v=ml6cT4AZdqI',
        durationMinutes: 40,
        level: 'avancado',
        objective: 'Condicionamento total',
      ),
    ]);
  }

  void _loadPackages() {
    _packages.clear();
    _packages.add(PackageModel(
      id: 'pkg001',
      studentId: _currentUser?.role == 'student'
          ? _currentUser!.id
          : 'student_001',
      name: 'Acompanhamento Premium',
      totalClasses: 12,
      completedClasses: 7,
      startDate: DateTime.now().subtract(const Duration(days: 21)),
      expiryDate: DateTime.now().add(const Duration(days: 9)),
      weeklyFrequency: 3,
      scheduledDays: ['Segunda', 'Quarta', 'Sexta'],
      type: 'presencial',
      isActive: true,
    ));
  }

  void _loadSessions() {
    _sessions.clear();
    final now = DateTime.now();
    _sessions.addAll([
      ClassSession(
        id: 'ses001',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        packageId: 'pkg001',
        date: now.subtract(const Duration(days: 14)),
        status: 'realizada',
        trainerNotes: 'Excelente desempenho! Aumentou carga no leg press.',
      ),
      ClassSession(
        id: 'ses002',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        packageId: 'pkg001',
        date: now.subtract(const Duration(days: 12)),
        status: 'realizada',
        trainerNotes: 'Treino focado em glúteos. Ótima execução.',
      ),
      ClassSession(
        id: 'ses003',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        packageId: 'pkg001',
        date: now.subtract(const Duration(days: 7)),
        status: 'realizada',
      ),
      ClassSession(
        id: 'ses004',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        packageId: 'pkg001',
        date: now.add(const Duration(days: 1)),
        status: 'agendada',
      ),
      ClassSession(
        id: 'ses005',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        packageId: 'pkg001',
        date: now.add(const Duration(days: 3)),
        status: 'agendada',
      ),
    ]);
  }

  void _loadAssessments() {
    _assessments.clear();
    _assessments.addAll([
      PhysicalAssessment(
        id: 'aval001',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        date: DateTime.now().subtract(const Duration(days: 60)),
        weight: 68.5,
        height: 165.0,
        age: 28,
        bodyFatPercentage: 28.5,
        muscleMass: 42.0,
        abdominalCircumference: 78.0,
        armCircumference: 29.0,
        thighCircumference: 57.0,
        hipCircumference: 98.0,
        goals: 'Reduzir % gordura para 22%, ganhar massa muscular',
        trainerNotes: 'Aluna com bom potencial. Foco em reeducação alimentar e treino resistido.',
      ),
      PhysicalAssessment(
        id: 'aval002',
        studentId: _currentUser?.role == 'student'
            ? _currentUser!.id
            : 'student_001',
        date: DateTime.now().subtract(const Duration(days: 15)),
        weight: 65.2,
        height: 165.0,
        age: 28,
        bodyFatPercentage: 25.2,
        muscleMass: 44.5,
        abdominalCircumference: 74.0,
        armCircumference: 30.5,
        thighCircumference: 55.0,
        hipCircumference: 95.0,
        goals: 'Continuar reduzindo % gordura. Meta: 22%',
        trainerNotes: 'Evolução excelente! -3.2kg de gordura, +2.5kg de massa muscular.',
      ),
    ]);
  }

  void _loadDiet() {
    _dietPlan = DietPlan(
      id: 'diet001',
      studentId: _currentUser?.role == 'student'
          ? _currentUser!.id
          : 'student_001',
      objective: 'emagrecimento',
      dailyCalorieGoal: 1800,
      dailyProteinGoal: 135,
      dailyCarbGoal: 180,
      dailyFatGoal: 60,
      dailyWaterGoal: 2.5,
      meals: [
        Meal(
          id: 'meal001',
          name: 'Café da Manhã',
          time: '07:00',
          items: [
            MealItem(
              name: 'Ovos mexidos',
              quantityGrams: 150,
              calories: 215,
              proteins: 19,
              carbs: 2,
              fats: 14,
              substitutions: 'Pode substituir por omelete com legumes',
            ),
            MealItem(
              name: 'Tapioca',
              quantityGrams: 60,
              calories: 93,
              proteins: 0.3,
              carbs: 23,
              fats: 0.1,
              substitutions: 'Pode substituir por 2 fatias de pão integral',
            ),
            MealItem(
              name: 'Frutas vermelhas',
              quantityGrams: 100,
              calories: 57,
              proteins: 0.7,
              carbs: 14,
              fats: 0.3,
            ),
          ],
          isCompleted: true,
        ),
        Meal(
          id: 'meal002',
          name: 'Lanche da Manhã',
          time: '10:00',
          items: [
            MealItem(
              name: 'Whey Protein',
              quantityGrams: 30,
              calories: 120,
              proteins: 24,
              carbs: 3,
              fats: 1.5,
              substitutions: 'Pode substituir por iogurte grego',
            ),
            MealItem(
              name: 'Banana',
              quantityGrams: 100,
              calories: 89,
              proteins: 1.1,
              carbs: 23,
              fats: 0.3,
            ),
          ],
        ),
        Meal(
          id: 'meal003',
          name: 'Almoço',
          time: '12:30',
          items: [
            MealItem(
              name: 'Frango grelhado',
              quantityGrams: 180,
              calories: 198,
              proteins: 41,
              carbs: 0,
              fats: 4,
              substitutions: 'Pode substituir por peixe ou carne vermelha magra',
            ),
            MealItem(
              name: 'Arroz integral',
              quantityGrams: 100,
              calories: 130,
              proteins: 2.7,
              carbs: 28,
              fats: 1,
            ),
            MealItem(
              name: 'Salada variada com azeite',
              quantityGrams: 200,
              calories: 80,
              proteins: 2,
              carbs: 8,
              fats: 5,
            ),
          ],
        ),
        Meal(
          id: 'meal004',
          name: 'Pré-Treino',
          time: '16:00',
          items: [
            MealItem(
              name: 'Batata doce',
              quantityGrams: 150,
              calories: 130,
              proteins: 3,
              carbs: 30,
              fats: 0.1,
              substitutions: 'Pode substituir por mandioca ou inhame',
            ),
            MealItem(
              name: 'Peito de frango',
              quantityGrams: 100,
              calories: 110,
              proteins: 23,
              carbs: 0,
              fats: 2,
            ),
          ],
        ),
        Meal(
          id: 'meal005',
          name: 'Pós-Treino / Jantar',
          time: '20:00',
          items: [
            MealItem(
              name: 'Salmão',
              quantityGrams: 150,
              calories: 234,
              proteins: 31,
              carbs: 0,
              fats: 12,
              substitutions: 'Pode substituir por atum ou frango',
            ),
            MealItem(
              name: 'Legumes assados',
              quantityGrams: 200,
              calories: 60,
              proteins: 3,
              carbs: 12,
              fats: 0.5,
            ),
          ],
        ),
      ],
      supplementation:
          'Whey Protein (pós-treino)\nCreatina 5g (diariamente)\nVitamina D3 2000UI\nÔmega 3 2g',
      trainerNotes:
          'Dieta balanceada para emagrecimento saudável. Priorize hidratação e qualidade do sono!',
    );
  }

  void _loadHydration() {
    _todayHydration = HydrationRecord(
      id: 'hyd_today',
      studentId: _currentUser?.role == 'student'
          ? _currentUser!.id
          : 'student_001',
      date: DateTime.now(),
      consumedLiters: 1.5,
      goalLiters: 2.5,
      entries: [
        {'amount': 0.3, 'time': '07:30'},
        {'amount': 0.5, 'time': '10:00'},
        {'amount': 0.3, 'time': '12:30'},
        {'amount': 0.4, 'time': '16:00'},
      ],
    );
  }

  void _loadGamification() {
    _gamification = GamificationData(
      studentId: _currentUser?.role == 'student'
          ? _currentUser!.id
          : 'student_001',
      totalPoints: _currentUser?.totalPoints ?? 1250,
      currentStreak: _currentUser?.currentStreak ?? 5,
      longestStreak: 14,
      trainingsCompleted: 47,
      waterGoalsReached: 23,
      dietGoalsFollowed: 18,
      currentLevel: _currentUser?.level ?? 'foco',
      achievements: [
        Achievement(
          id: 'ach001',
          title: 'Primeira Vitória',
          description: 'Completou seu primeiro treino',
          icon: '🏆',
          pointsRequired: 0,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Achievement(
          id: 'ach002',
          title: 'Semana de Fogo',
          description: 'Treinou 5 dias seguidos',
          icon: '🔥',
          pointsRequired: 500,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Achievement(
          id: 'ach003',
          title: 'Hidratada',
          description: 'Atingiu a meta de água por 7 dias',
          icon: '💧',
          pointsRequired: 500,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Achievement(
          id: 'ach004',
          title: 'Guerreira',
          description: 'Completou 30 treinos',
          icon: '⚔️',
          pointsRequired: 1000,
          isUnlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Achievement(
          id: 'ach005',
          title: 'Elite',
          description: 'Atingiu o nível Elite',
          icon: '👑',
          pointsRequired: 3000,
          isUnlocked: false,
        ),
        Achievement(
          id: 'ach006',
          title: 'Rainha da Consistência',
          description: 'Treinou 30 dias seguidos',
          icon: '💎',
          pointsRequired: 3000,
          isUnlocked: false,
        ),
      ],
      motivationalMessages: [
        'Você é mais forte do que pensa! 💪',
        'Cada treino é um passo em direção ao seu melhor self!',
        'O shape dos seus sonhos está sendo construído agora! 🔥',
        'Consistência é o seu superpoder! ⚡',
        'Você está arrasando! Continue assim! 🏆',
      ],
    );
  }

  // Actions
  void addWaterSimple(double liters) {
    if (_todayHydration != null) {
      _todayHydration!.consumedLiters =
          (_todayHydration!.consumedLiters + liters)
              .clamp(0, _todayHydration!.goalLiters * 2);
      notifyListeners();
    }
  }

  void markExerciseDone(String workoutId, String exerciseId, {double? weight}) {
    final workout = _workouts.firstWhere((w) => w.id == workoutId,
        orElse: () => throw Exception('Workout not found'));
    final exerciseIndex =
        workout.exercises.indexWhere((e) => e.exerciseId == exerciseId);
    if (exerciseIndex != -1) {
      workout.exercises[exerciseIndex].isDone = true;
      if (weight != null) {
        workout.exercises[exerciseIndex].weight = weight;
        workout.exercises[exerciseIndex].weightHistory.add(weight);
      }
      if (workout.progress == 1.0) {
        workout.isCompleted = true;
        workout.completedAt = DateTime.now();
        addPoints(100, 'Treino completo!');
      }
      notifyListeners();
    }
  }

  void addPoints(int points, String reason) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        totalPoints: (_currentUser!.totalPoints) + points,
      );
      _gamification?.totalPoints += points;
      _gamification?.updateLevel();
      notifyListeners();
    }
  }

  void updateStudentWeight(double weight) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(currentWeight: weight);
      notifyListeners();
    }
  }

  // ==================== STUDENT MANAGEMENT ====================
  void addStudent(UserModel student) {
    _students.add(student);
    notifyListeners();
  }

  void removeStudent(String studentId) {
    _students.removeWhere((s) => s.id == studentId);
    notifyListeners();
  }

  void updateStudent(UserModel updatedStudent) {
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }
}
