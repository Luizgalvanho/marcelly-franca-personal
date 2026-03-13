import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final diet = state.dietPlan;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Meu Plano'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: diet == null
          ? const EmptyState(
              icon: Icons.restaurant_menu,
              title: 'Plano alimentar não cadastrado',
              subtitle:
                  'Aguarde sua personal cadastrar seu plano alimentar personalizado.')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Objective badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🎯', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          'Objetivo: ${_objectiveLabel(diet.objective)}',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Macros summary
                  const SectionHeader(title: 'Metas Diárias'),
                  const SizedBox(height: 12),
                  _MacrosCard(diet: diet),
                  const SizedBox(height: 24),
                  // Meals
                  SectionHeader(
                    title: 'Refeições do Dia',
                    onAction: () {},
                    actionLabel:
                        '${diet.meals.where((m) => m.isCompleted).length}/${diet.meals.length}',
                  ),
                  const SizedBox(height: 12),
                  ...diet.meals.map((meal) => _MealCard(
                        meal: meal,
                        onToggle: () {},
                      )),
                  const SizedBox(height: 24),
                  // Supplementation
                  if (diet.supplementation != null) ...[
                    const SectionHeader(title: 'Suplementação'),
                    const SizedBox(height: 12),
                    DarkCard(
                      hasBorder: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text('💊', style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              Text('Protocolo de suplementos',
                                  style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...diet.supplementation!.split('\n').map(
                                (s) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: AppColors.success,
                                          size: 14),
                                      const SizedBox(width: 8),
                                      Text(s,
                                          style: const TextStyle(
                                              color: AppColors.grey300,
                                              fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  // Trainer notes
                  if (diet.trainerNotes != null) ...[
                    const SectionHeader(
                        title: 'Orientações da Personal'),
                    const SizedBox(height: 12),
                    DarkCard(
                      hasBorder: true,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.tips_and_updates,
                              color: AppColors.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(diet.trainerNotes!,
                                style: const TextStyle(
                                    color: AppColors.grey300,
                                    fontSize: 14,
                                    height: 1.5)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  String _objectiveLabel(String obj) {
    switch (obj) {
      case 'emagrecimento': return 'Emagrecimento';
      case 'hipertrofia': return 'Hipertrofia';
      case 'manutencao': return 'Manutenção';
      default: return obj;
    }
  }
}

class _MacrosCard extends StatelessWidget {
  final DietPlan diet;
  const _MacrosCard({required this.diet});

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _MacroItem(
                      label: 'Calorias',
                      value: '${diet.dailyCalorieGoal.toInt()}',
                      unit: 'kcal',
                      color: AppColors.warning)),
              Container(width: 1, height: 50, color: AppColors.grey800),
              Expanded(
                  child: _MacroItem(
                      label: 'Proteínas',
                      value: '${diet.dailyProteinGoal.toInt()}',
                      unit: 'g',
                      color: AppColors.primary)),
            ],
          ),
          const Divider(color: AppColors.grey800, height: 1),
          Row(
            children: [
              Expanded(
                  child: _MacroItem(
                      label: 'Carboidratos',
                      value: '${diet.dailyCarbGoal.toInt()}',
                      unit: 'g',
                      color: const Color(0xFF29B6F6))),
              Container(width: 1, height: 50, color: AppColors.grey800),
              Expanded(
                  child: _MacroItem(
                      label: 'Gorduras',
                      value: '${diet.dailyFatGoal.toInt()}',
                      unit: 'g',
                      color: const Color(0xFF4CAF50))),
            ],
          ),
          const Divider(color: AppColors.grey800, height: 1),
          _MacroItem(
              label: 'Água',
              value: '${diet.dailyWaterGoal}',
              unit: 'L',
              color: const Color(0xFF29B6F6)),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  const _MacroItem(
      {required this.label,
      required this.value,
      required this.unit,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Container(
              width: 4,
              height: 36,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.grey500, fontSize: 11)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value,
                      style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(width: 2),
                  Text(unit,
                      style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 11,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatefulWidget {
  final Meal meal;
  final VoidCallback onToggle;
  const _MealCard({required this.meal, required this.onToggle});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: meal.isCompleted
            ? AppColors.success.withValues(alpha: 0.05)
            : AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: meal.isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.grey800,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Text(
                        _mealEmoji(meal.name),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meal.name,
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        Text(
                          '${meal.time} • ${meal.totalCalories.toInt()} kcal',
                          style: const TextStyle(
                              color: AppColors.grey500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${meal.items.length} alimentos',
                        style: const TextStyle(
                            color: AppColors.grey500, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _expanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: AppColors.grey500,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  const Divider(color: AppColors.grey800),
                  ...meal.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                          color: AppColors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  if (item.substitutions != null)
                                    Text(
                                      '↔ ${item.substitutions}',
                                      style: const TextStyle(
                                          color: AppColors.grey500,
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${item.quantityGrams}g',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MacroTag('P: ${meal.totalProteins.toInt()}g',
                          AppColors.primary),
                      _MacroTag('C: ${meal.totalCarbs.toInt()}g',
                          const Color(0xFF29B6F6)),
                      _MacroTag('G: ${meal.totalFats.toInt()}g',
                          const Color(0xFF4CAF50)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _mealEmoji(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('café') || lower.contains('manhã')) return '🌅';
    if (lower.contains('almoço')) return '🍽️';
    if (lower.contains('jantar')) return '🌙';
    if (lower.contains('lanche')) return '🥪';
    if (lower.contains('pré')) return '⚡';
    if (lower.contains('pós')) return '💪';
    return '🥗';
  }
}

class _MacroTag extends StatelessWidget {
  final String label;
  final Color color;
  const _MacroTag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
