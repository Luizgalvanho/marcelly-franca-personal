// Models for Marcelly França Personal App

// ==================== USER MODEL ====================
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String role; // 'student' or 'trainer'
  final String? objective;
  final String level; // beginner, focus, evolution, elite
  final int age;
  final double currentWeight;
  final double targetWeight;
  final double height;
  final String? contractedPlan;
  final List<String> activeTrainings;
  final List<String> restrictions;
  final String? trainerNotes;
  final int totalPoints;
  final int currentStreak;
  final List<String> badges;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    this.objective,
    this.level = 'beginner',
    this.age = 0,
    this.currentWeight = 0,
    this.targetWeight = 0,
    this.height = 0,
    this.contractedPlan,
    this.activeTrainings = const [],
    this.restrictions = const [],
    this.trainerNotes,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.badges = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        photoUrl: json['photoUrl'],
        role: json['role'] ?? 'student',
        objective: json['objective'],
        level: json['level'] ?? 'beginner',
        age: json['age'] ?? 0,
        currentWeight: (json['currentWeight'] ?? 0).toDouble(),
        targetWeight: (json['targetWeight'] ?? 0).toDouble(),
        height: (json['height'] ?? 0).toDouble(),
        contractedPlan: json['contractedPlan'],
        activeTrainings: List<String>.from(json['activeTrainings'] ?? []),
        restrictions: List<String>.from(json['restrictions'] ?? []),
        trainerNotes: json['trainerNotes'],
        totalPoints: json['totalPoints'] ?? 0,
        currentStreak: json['currentStreak'] ?? 0,
        badges: List<String>.from(json['badges'] ?? []),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'role': role,
        'objective': objective,
        'level': level,
        'age': age,
        'currentWeight': currentWeight,
        'targetWeight': targetWeight,
        'height': height,
        'contractedPlan': contractedPlan,
        'activeTrainings': activeTrainings,
        'restrictions': restrictions,
        'trainerNotes': trainerNotes,
        'totalPoints': totalPoints,
        'currentStreak': currentStreak,
        'badges': badges,
        'createdAt': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? objective,
    String? level,
    int? age,
    double? currentWeight,
    double? targetWeight,
    double? height,
    String? contractedPlan,
    List<String>? activeTrainings,
    List<String>? restrictions,
    String? trainerNotes,
    int? totalPoints,
    int? currentStreak,
    List<String>? badges,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        photoUrl: photoUrl ?? this.photoUrl,
        role: role,
        objective: objective ?? this.objective,
        level: level ?? this.level,
        age: age ?? this.age,
        currentWeight: currentWeight ?? this.currentWeight,
        targetWeight: targetWeight ?? this.targetWeight,
        height: height ?? this.height,
        contractedPlan: contractedPlan ?? this.contractedPlan,
        activeTrainings: activeTrainings ?? this.activeTrainings,
        restrictions: restrictions ?? this.restrictions,
        trainerNotes: trainerNotes ?? this.trainerNotes,
        totalPoints: totalPoints ?? this.totalPoints,
        currentStreak: currentStreak ?? this.currentStreak,
        badges: badges ?? this.badges,
        createdAt: createdAt,
      );
}

// ==================== EXERCISE MODEL ====================
class ExerciseModel {
  final String id;
  final String name;
  final String muscleGroup;
  final String difficulty; // beginner, intermediate, advanced
  final List<String> equipment;
  final String executionInstructions;
  final String commonMistakes;
  final String? videoUrl;
  final String? imageUrl;
  final int defaultSets;
  final int defaultReps;
  final int defaultRestSeconds;
  final bool isActive;
  final String? trainerNotes;
  final DateTime createdAt;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.difficulty,
    required this.equipment,
    required this.executionInstructions,
    this.commonMistakes = '',
    this.videoUrl,
    this.imageUrl,
    this.defaultSets = 3,
    this.defaultReps = 12,
    this.defaultRestSeconds = 60,
    this.isActive = true,
    this.trainerNotes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        muscleGroup: json['muscleGroup'] ?? '',
        difficulty: json['difficulty'] ?? 'beginner',
        equipment: List<String>.from(json['equipment'] ?? []),
        executionInstructions: json['executionInstructions'] ?? '',
        commonMistakes: json['commonMistakes'] ?? '',
        videoUrl: json['videoUrl'],
        imageUrl: json['imageUrl'],
        defaultSets: json['defaultSets'] ?? 3,
        defaultReps: json['defaultReps'] ?? 12,
        defaultRestSeconds: json['defaultRestSeconds'] ?? 60,
        isActive: json['isActive'] ?? true,
        trainerNotes: json['trainerNotes'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscleGroup': muscleGroup,
        'difficulty': difficulty,
        'equipment': equipment,
        'executionInstructions': executionInstructions,
        'commonMistakes': commonMistakes,
        'videoUrl': videoUrl,
        'imageUrl': imageUrl,
        'defaultSets': defaultSets,
        'defaultReps': defaultReps,
        'defaultRestSeconds': defaultRestSeconds,
        'isActive': isActive,
        'trainerNotes': trainerNotes,
        'createdAt': createdAt.toIso8601String(),
      };
}

// ==================== WORKOUT MODEL ====================
class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  final String muscleGroup;
  int sets;
  int reps;
  int restSeconds;
  double? weight;
  bool isDone;
  String? studentNote;
  String? trainerNote;
  List<double> weightHistory;

  WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    this.weight,
    this.isDone = false,
    this.studentNote,
    this.trainerNote,
    this.weightHistory = const [],
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseId: json['exerciseId'] ?? '',
        exerciseName: json['exerciseName'] ?? '',
        muscleGroup: json['muscleGroup'] ?? '',
        sets: json['sets'] ?? 3,
        reps: json['reps'] ?? 12,
        restSeconds: json['restSeconds'] ?? 60,
        weight: json['weight']?.toDouble(),
        isDone: json['isDone'] ?? false,
        studentNote: json['studentNote'],
        trainerNote: json['trainerNote'],
        weightHistory: List<double>.from(
            (json['weightHistory'] ?? []).map((e) => e.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'muscleGroup': muscleGroup,
        'sets': sets,
        'reps': reps,
        'restSeconds': restSeconds,
        'weight': weight,
        'isDone': isDone,
        'studentNote': studentNote,
        'trainerNote': trainerNote,
        'weightHistory': weightHistory,
      };
}

class WorkoutModel {
  final String id;
  final String studentId;
  final String name;
  final String dayOfWeek;
  final List<String> muscleGroups;
  final List<WorkoutExercise> exercises;
  final String? trainerNotes;
  bool isCompleted;
  DateTime? completedAt;
  int durationMinutes;

  WorkoutModel({
    required this.id,
    required this.studentId,
    required this.name,
    required this.dayOfWeek,
    required this.muscleGroups,
    required this.exercises,
    this.trainerNotes,
    this.isCompleted = false,
    this.completedAt,
    this.durationMinutes = 0,
  });

  double get progress {
    if (exercises.isEmpty) return 0;
    return exercises.where((e) => e.isDone).length / exercises.length;
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
        id: json['id'] ?? '',
        studentId: json['studentId'] ?? '',
        name: json['name'] ?? '',
        dayOfWeek: json['dayOfWeek'] ?? '',
        muscleGroups: List<String>.from(json['muscleGroups'] ?? []),
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) => WorkoutExercise.fromJson(e))
            .toList(),
        trainerNotes: json['trainerNotes'],
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        durationMinutes: json['durationMinutes'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'name': name,
        'dayOfWeek': dayOfWeek,
        'muscleGroups': muscleGroups,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'trainerNotes': trainerNotes,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'durationMinutes': durationMinutes,
      };
}

// ==================== PACKAGE MODEL ====================
class PackageModel {
  final String id;
  final String studentId;
  final String name;
  final int totalClasses;
  int completedClasses;
  final DateTime startDate;
  final DateTime expiryDate;
  final int weeklyFrequency;
  final List<String> scheduledDays;
  final String type; // presencial, online, presencial+online
  final bool isActive;

  PackageModel({
    required this.id,
    required this.studentId,
    required this.name,
    required this.totalClasses,
    this.completedClasses = 0,
    required this.startDate,
    required this.expiryDate,
    required this.weeklyFrequency,
    this.scheduledDays = const [],
    this.type = 'presencial',
    this.isActive = true,
  });

  int get remainingClasses => totalClasses - completedClasses;
  double get progress => totalClasses > 0 ? completedClasses / totalClasses : 0;
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays <= 7;
  bool get isLowClasses => remainingClasses <= 3;

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        id: json['id'] ?? '',
        studentId: json['studentId'] ?? '',
        name: json['name'] ?? '',
        totalClasses: json['totalClasses'] ?? 0,
        completedClasses: json['completedClasses'] ?? 0,
        startDate: DateTime.parse(json['startDate']),
        expiryDate: DateTime.parse(json['expiryDate']),
        weeklyFrequency: json['weeklyFrequency'] ?? 1,
        scheduledDays: List<String>.from(json['scheduledDays'] ?? []),
        type: json['type'] ?? 'presencial',
        isActive: json['isActive'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'name': name,
        'totalClasses': totalClasses,
        'completedClasses': completedClasses,
        'startDate': startDate.toIso8601String(),
        'expiryDate': expiryDate.toIso8601String(),
        'weeklyFrequency': weeklyFrequency,
        'scheduledDays': scheduledDays,
        'type': type,
        'isActive': isActive,
      };
}

// ==================== CLASS SESSION MODEL ====================
class ClassSession {
  final String id;
  final String studentId;
  final String packageId;
  final DateTime date;
  final String status; // agendada, realizada, cancelada, remarcada
  final String? trainerNotes;
  final String? studentNotes;

  ClassSession({
    required this.id,
    required this.studentId,
    required this.packageId,
    required this.date,
    required this.status,
    this.trainerNotes,
    this.studentNotes,
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) => ClassSession(
        id: json['id'] ?? '',
        studentId: json['studentId'] ?? '',
        packageId: json['packageId'] ?? '',
        date: DateTime.parse(json['date']),
        status: json['status'] ?? 'agendada',
        trainerNotes: json['trainerNotes'],
        studentNotes: json['studentNotes'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'packageId': packageId,
        'date': date.toIso8601String(),
        'status': status,
        'trainerNotes': trainerNotes,
        'studentNotes': studentNotes,
      };
}

// ==================== ASSESSMENT MODEL ====================
class PhysicalAssessment {
  final String id;
  final String studentId;
  final DateTime date;
  final double weight;
  final double height;
  final int age;
  final double bodyFatPercentage;
  final double muscleMass;
  final double abdominalCircumference;
  final double armCircumference;
  final double thighCircumference;
  final double hipCircumference;
  final double imc;
  final String? photoUrl;
  final String? trainerNotes;
  final String? goals;

  PhysicalAssessment({
    required this.id,
    required this.studentId,
    required this.date,
    required this.weight,
    required this.height,
    required this.age,
    this.bodyFatPercentage = 0,
    this.muscleMass = 0,
    this.abdominalCircumference = 0,
    this.armCircumference = 0,
    this.thighCircumference = 0,
    this.hipCircumference = 0,
    double? imc,
    this.photoUrl,
    this.trainerNotes,
    this.goals,
  }) : imc = imc ?? (weight / ((height / 100) * (height / 100)));

  String get imcClassification {
    if (imc < 18.5) return 'Abaixo do peso';
    if (imc < 24.9) return 'Peso normal';
    if (imc < 29.9) return 'Sobrepeso';
    if (imc < 34.9) return 'Obesidade grau I';
    if (imc < 39.9) return 'Obesidade grau II';
    return 'Obesidade grau III';
  }

  factory PhysicalAssessment.fromJson(Map<String, dynamic> json) =>
      PhysicalAssessment(
        id: json['id'] ?? '',
        studentId: json['studentId'] ?? '',
        date: DateTime.parse(json['date']),
        weight: (json['weight'] ?? 0).toDouble(),
        height: (json['height'] ?? 0).toDouble(),
        age: json['age'] ?? 0,
        bodyFatPercentage: (json['bodyFatPercentage'] ?? 0).toDouble(),
        muscleMass: (json['muscleMass'] ?? 0).toDouble(),
        abdominalCircumference:
            (json['abdominalCircumference'] ?? 0).toDouble(),
        armCircumference: (json['armCircumference'] ?? 0).toDouble(),
        thighCircumference: (json['thighCircumference'] ?? 0).toDouble(),
        hipCircumference: (json['hipCircumference'] ?? 0).toDouble(),
        imc: (json['imc'] ?? 0).toDouble(),
        photoUrl: json['photoUrl'],
        trainerNotes: json['trainerNotes'],
        goals: json['goals'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'date': date.toIso8601String(),
        'weight': weight,
        'height': height,
        'age': age,
        'bodyFatPercentage': bodyFatPercentage,
        'muscleMass': muscleMass,
        'abdominalCircumference': abdominalCircumference,
        'armCircumference': armCircumference,
        'thighCircumference': thighCircumference,
        'hipCircumference': hipCircumference,
        'imc': imc,
        'photoUrl': photoUrl,
        'trainerNotes': trainerNotes,
        'goals': goals,
      };
}

// ==================== DIET MODEL ====================
class MealItem {
  final String name;
  final double quantityGrams;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final String? substitutions;

  MealItem({
    required this.name,
    required this.quantityGrams,
    this.calories = 0,
    this.proteins = 0,
    this.carbs = 0,
    this.fats = 0,
    this.substitutions,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) => MealItem(
        name: json['name'] ?? '',
        quantityGrams: (json['quantityGrams'] ?? 0).toDouble(),
        calories: (json['calories'] ?? 0).toDouble(),
        proteins: (json['proteins'] ?? 0).toDouble(),
        carbs: (json['carbs'] ?? 0).toDouble(),
        fats: (json['fats'] ?? 0).toDouble(),
        substitutions: json['substitutions'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantityGrams': quantityGrams,
        'calories': calories,
        'proteins': proteins,
        'carbs': carbs,
        'fats': fats,
        'substitutions': substitutions,
      };
}

class Meal {
  final String id;
  final String name;
  final String time;
  final List<MealItem> items;
  final String? notes;
  bool isCompleted;

  Meal({
    required this.id,
    required this.name,
    required this.time,
    required this.items,
    this.notes,
    this.isCompleted = false,
  });

  double get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProteins => items.fold(0, (sum, item) => sum + item.proteins);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFats => items.fold(0, (sum, item) => sum + item.fats);

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        time: json['time'] ?? '',
        items: (json['items'] as List<dynamic>? ?? [])
            .map((e) => MealItem.fromJson(e))
            .toList(),
        notes: json['notes'],
        isCompleted: json['isCompleted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'time': time,
        'items': items.map((e) => e.toJson()).toList(),
        'notes': notes,
        'isCompleted': isCompleted,
      };
}

class DietPlan {
  final String id;
  final String studentId;
  final String objective; // emagrecimento, hipertrofia, manutencao
  final double dailyCalorieGoal;
  final double dailyProteinGoal;
  final double dailyCarbGoal;
  final double dailyFatGoal;
  final double dailyWaterGoal;
  final List<Meal> meals;
  final String? supplementation;
  final String? trainerNotes;
  final DateTime createdAt;

  DietPlan({
    required this.id,
    required this.studentId,
    required this.objective,
    this.dailyCalorieGoal = 0,
    this.dailyProteinGoal = 0,
    this.dailyCarbGoal = 0,
    this.dailyFatGoal = 0,
    this.dailyWaterGoal = 2.5,
    required this.meals,
    this.supplementation,
    this.trainerNotes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get totalCalories => meals.fold(0, (sum, m) => sum + m.totalCalories);

  factory DietPlan.fromJson(Map<String, dynamic> json) => DietPlan(
        id: json['id'] ?? '',
        studentId: json['studentId'] ?? '',
        objective: json['objective'] ?? '',
        dailyCalorieGoal: (json['dailyCalorieGoal'] ?? 0).toDouble(),
        dailyProteinGoal: (json['dailyProteinGoal'] ?? 0).toDouble(),
        dailyCarbGoal: (json['dailyCarbGoal'] ?? 0).toDouble(),
        dailyFatGoal: (json['dailyFatGoal'] ?? 0).toDouble(),
        dailyWaterGoal: (json['dailyWaterGoal'] ?? 2.5).toDouble(),
        meals: (json['meals'] as List<dynamic>? ?? [])
            .map((e) => Meal.fromJson(e))
            .toList(),
        supplementation: json['supplementation'],
        trainerNotes: json['trainerNotes'],
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'objective': objective,
        'dailyCalorieGoal': dailyCalorieGoal,
        'dailyProteinGoal': dailyProteinGoal,
        'dailyCarbGoal': dailyCarbGoal,
        'dailyFatGoal': dailyFatGoal,
        'dailyWaterGoal': dailyWaterGoal,
        'meals': meals.map((e) => e.toJson()).toList(),
        'supplementation': supplementation,
        'trainerNotes': trainerNotes,
        'createdAt': createdAt.toIso8601String(),
      };
}

// ==================== VIDEO MODEL ====================
class VideoModel {
  final String id;
  final String title;
  final String category;
  final String youtubeUrl;
  final String? thumbnailUrl;
  final int durationMinutes;
  final String level;
  final String objective;
  bool isSaved;
  bool isCompleted;

  VideoModel({
    required this.id,
    required this.title,
    required this.category,
    required this.youtubeUrl,
    this.thumbnailUrl,
    this.durationMinutes = 0,
    this.level = 'intermediario',
    this.objective = '',
    this.isSaved = false,
    this.isCompleted = false,
  });

  String get youtubeId {
    final uri = Uri.tryParse(youtubeUrl);
    if (uri != null) {
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.first;
      }
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  String get thumbnailFromYoutube =>
      thumbnailUrl ??
      'https://img.youtube.com/vi/$youtubeId/maxresdefault.jpg';

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        category: json['category'] ?? '',
        youtubeUrl: json['youtubeUrl'] ?? '',
        thumbnailUrl: json['thumbnailUrl'],
        durationMinutes: json['durationMinutes'] ?? 0,
        level: json['level'] ?? 'intermediario',
        objective: json['objective'] ?? '',
        isSaved: json['isSaved'] ?? false,
        isCompleted: json['isCompleted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'youtubeUrl': youtubeUrl,
        'thumbnailUrl': thumbnailUrl,
        'durationMinutes': durationMinutes,
        'level': level,
        'objective': objective,
        'isSaved': isSaved,
        'isCompleted': isCompleted,
      };
}

// ==================== GAMIFICATION MODEL ====================
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int pointsRequired;
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    this.isUnlocked = false,
    this.unlockedAt,
  });
}

class GamificationData {
  final String studentId;
  int totalPoints;
  int currentStreak;
  int longestStreak;
  int trainingsCompleted;
  int waterGoalsReached;
  int dietGoalsFollowed;
  String currentLevel; // iniciante, foco, evolucao, elite
  List<Achievement> achievements;
  List<String> motivationalMessages;

  GamificationData({
    required this.studentId,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.trainingsCompleted = 0,
    this.waterGoalsReached = 0,
    this.dietGoalsFollowed = 0,
    this.currentLevel = 'iniciante',
    this.achievements = const [],
    this.motivationalMessages = const [],
  });

  String get levelTitle {
    switch (currentLevel) {
      case 'iniciante':
        return 'Iniciante';
      case 'foco':
        return 'Foco';
      case 'evolucao':
        return 'Evolução';
      case 'elite':
        return 'Elite';
      default:
        return 'Iniciante';
    }
  }

  int get pointsToNextLevel {
    switch (currentLevel) {
      case 'iniciante':
        return 500 - totalPoints;
      case 'foco':
        return 1500 - totalPoints;
      case 'evolucao':
        return 3000 - totalPoints;
      default:
        return 0;
    }
  }

  void updateLevel() {
    if (totalPoints >= 3000) {
      currentLevel = 'elite';
    } else if (totalPoints >= 1500) {
      currentLevel = 'evolucao';
    } else if (totalPoints >= 500) {
      currentLevel = 'foco';
    } else {
      currentLevel = 'iniciante';
    }
  }
}

// ==================== HYDRATION MODEL ====================
class HydrationRecord {
  final String id;
  final String studentId;
  final DateTime date;
  double consumedLiters;
  final double goalLiters;
  List<Map<String, dynamic>> entries;

  HydrationRecord({
    required this.id,
    required this.studentId,
    required this.date,
    this.consumedLiters = 0,
    this.goalLiters = 2.5,
    this.entries = const [],
  });

  double get progress => goalLiters > 0 ? (consumedLiters / goalLiters).clamp(0, 1) : 0;
  bool get goalReached => consumedLiters >= goalLiters;
}
