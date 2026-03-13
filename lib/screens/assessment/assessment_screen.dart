import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common_widgets.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final assessments = state.myAssessments;
    final latest = assessments.isNotEmpty ? assessments.first : null;
    final previous = assessments.length > 1 ? assessments[1] : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Avaliação Física'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (state.isTrainer)
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () => _showAddAssessment(context),
            ),
        ],
      ),
      body: assessments.isEmpty
          ? const EmptyState(
              icon: Icons.accessibility_new,
              title: 'Nenhuma avaliação registrada',
              subtitle:
                  'Aguarde sua personal registrar sua primeira avaliação física.')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Latest assessment date
                  _AssessmentDateBadge(
                      date: latest!.date, isLatest: true),
                  const SizedBox(height: 16),
                  // Key metrics
                  _KeyMetricsRow(
                      latest: latest, previous: previous),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Composição Corporal'),
                  const SizedBox(height: 12),
                  _BodyCompositionCard(latest: latest, previous: previous),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Circunferências'),
                  const SizedBox(height: 12),
                  _CircumferenceCard(latest: latest, previous: previous),
                  const SizedBox(height: 24),
                  if (latest.goals != null) ...[
                    const SectionHeader(title: 'Metas'),
                    const SizedBox(height: 12),
                    DarkCard(
                      hasBorder: true,
                      child: Row(
                        children: [
                          const Icon(Icons.flag_outlined,
                              color: AppColors.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(latest.goals!,
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
                  if (latest.trainerNotes != null) ...[
                    const SectionHeader(title: 'Observações da Personal'),
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
                            child: Text(latest.trainerNotes!,
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
                  // History
                  if (assessments.length > 1) ...[
                    const SectionHeader(title: 'Histórico'),
                    const SizedBox(height: 12),
                    ...assessments.asMap().entries.map((e) =>
                        _HistoryItem(
                            assessment: e.value, isLatest: e.key == 0)),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  void _showAddAssessment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade disponível no painel administrativo'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _AssessmentDateBadge extends StatelessWidget {
  final DateTime date;
  final bool isLatest;
  const _AssessmentDateBadge(
      {required this.date, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isLatest
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isLatest
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.grey700),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today,
              color: isLatest ? AppColors.primary : AppColors.grey500,
              size: 14),
          const SizedBox(width: 6),
          Text(
            isLatest
                ? 'Última Avaliação: ${_formatDate(date)}'
                : _formatDate(date),
            style: TextStyle(
              color: isLatest ? AppColors.primary : AppColors.grey300,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}

class _KeyMetricsRow extends StatelessWidget {
  final PhysicalAssessment latest;
  final PhysicalAssessment? previous;
  const _KeyMetricsRow({required this.latest, this.previous});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Peso',
            value: '${latest.weight}',
            unit: 'kg',
            delta: previous != null ? latest.weight - previous!.weight : null,
            isGoodWhenNegative: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            label: '% Gordura',
            value: '${latest.bodyFatPercentage}',
            unit: '%',
            delta: previous != null
                ? latest.bodyFatPercentage - previous!.bodyFatPercentage
                : null,
            isGoodWhenNegative: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricCard(
            label: 'Massa',
            value: '${latest.muscleMass}',
            unit: 'kg',
            delta: previous != null
                ? latest.muscleMass - previous!.muscleMass
                : null,
            isGoodWhenNegative: false,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double? delta;
  final bool isGoodWhenNegative;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    this.delta,
    required this.isGoodWhenNegative,
  });

  Color get _deltaColor {
    if (delta == null) return AppColors.grey500;
    final isPositive = delta! > 0;
    final isGood = isGoodWhenNegative ? !isPositive : isPositive;
    return isGood ? AppColors.success : AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      hasBorder: true,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.grey500, fontSize: 11)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 2),
              Text(unit,
                  style: const TextStyle(
                      color: AppColors.grey500, fontSize: 12)),
            ],
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Text(
              '${delta! > 0 ? '+' : ''}${delta!.toStringAsFixed(1)}$unit',
              style: TextStyle(
                color: _deltaColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BodyCompositionCard extends StatelessWidget {
  final PhysicalAssessment latest;
  final PhysicalAssessment? previous;
  const _BodyCompositionCard({required this.latest, this.previous});

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      child: Column(
        children: [
          StatRow(
              label: 'Peso',
              value: '${latest.weight} kg',
              valueColor: AppColors.white),
          const Divider(height: 1, color: AppColors.grey800),
          StatRow(
              label: 'Altura',
              value: '${latest.height} cm',
              valueColor: AppColors.white),
          const Divider(height: 1, color: AppColors.grey800),
          StatRow(
              label: 'IMC',
              value: latest.imc.toStringAsFixed(1),
              valueColor: AppColors.primary),
          const Divider(height: 1, color: AppColors.grey800),
          StatRow(
              label: 'Classificação IMC',
              value: latest.imcClassification,
              valueColor: AppColors.grey300),
          const Divider(height: 1, color: AppColors.grey800),
          StatRow(
              label: '% Gordura Corporal',
              value: '${latest.bodyFatPercentage}%',
              valueColor: AppColors.warning),
          const Divider(height: 1, color: AppColors.grey800),
          StatRow(
              label: 'Massa Muscular',
              value: '${latest.muscleMass} kg',
              valueColor: AppColors.success),
        ],
      ),
    );
  }
}

class _CircumferenceCard extends StatelessWidget {
  final PhysicalAssessment latest;
  final PhysicalAssessment? previous;
  const _CircumferenceCard({required this.latest, this.previous});

  @override
  Widget build(BuildContext context) {
    return DarkCard(
      child: Column(
        children: [
          _CircRow('Abdômen', latest.abdominalCircumference,
              previous?.abdominalCircumference),
          const Divider(height: 1, color: AppColors.grey800),
          _CircRow('Braço', latest.armCircumference,
              previous?.armCircumference),
          const Divider(height: 1, color: AppColors.grey800),
          _CircRow('Coxa', latest.thighCircumference,
              previous?.thighCircumference),
          const Divider(height: 1, color: AppColors.grey800),
          _CircRow('Quadril', latest.hipCircumference,
              previous?.hipCircumference),
        ],
      ),
    );
  }

  Widget _CircRow(String label, double current, double? prev) {
    final delta = prev != null ? current - prev : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.grey300, fontSize: 14)),
          Row(
            children: [
              Text('$current cm',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              if (delta != null) ...[
                const SizedBox(width: 8),
                Text(
                  '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: delta < 0 ? AppColors.success : AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final PhysicalAssessment assessment;
  final bool isLatest;
  const _HistoryItem(
      {required this.assessment, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.grey800,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLatest ? AppColors.primary : AppColors.grey700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${assessment.date.day.toString().padLeft(2, '0')}/${assessment.date.month.toString().padLeft(2, '0')}/${assessment.date.year}',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text('${assessment.weight} kg',
                    style: const TextStyle(
                        color: AppColors.grey300, fontSize: 13)),
                Text('${assessment.bodyFatPercentage}% gordura',
                    style: const TextStyle(
                        color: AppColors.grey500, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
