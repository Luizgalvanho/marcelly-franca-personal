import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pkg = state.activePackage;
    final sessions = state.sessions
        .where((s) =>
            s.studentId ==
            (state.isTrainer ? 'student_001' : state.currentUser?.id))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Minhas Aulas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: pkg == null
          ? const EmptyState(
              icon: Icons.calendar_today,
              title: 'Nenhum pacote ativo',
              subtitle: 'Entre em contato com a Marcelly para contratar seu pacote.')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active package
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3D0020), Color(0xFF1A0A14)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Pacote Ativo',
                                    style: TextStyle(
                                        color: AppColors.grey500,
                                        fontSize: 11)),
                                const SizedBox(height: 2),
                                Text(
                                  pkg.name,
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.success.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.success
                                        .withValues(alpha: 0.4)),
                              ),
                              child: const Text('Ativo',
                                  style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _PackageStat(
                                label: 'Total',
                                value: '${pkg.totalClasses}',
                                color: AppColors.white,
                              ),
                            ),
                            Expanded(
                              child: _PackageStat(
                                label: 'Realizadas',
                                value: '${pkg.completedClasses}',
                                color: AppColors.success,
                              ),
                            ),
                            Expanded(
                              child: _PackageStat(
                                label: 'Restantes',
                                value: '${pkg.remainingClasses}',
                                color: pkg.isLowClasses
                                    ? AppColors.error
                                    : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        PinkProgressBar(value: pkg.progress, height: 8),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: AppColors.grey500, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  'Validade: ${_fmtDate(pkg.expiryDate)}',
                                  style: const TextStyle(
                                      color: AppColors.grey500,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.repeat,
                                    color: AppColors.grey500, size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  '${pkg.weeklyFrequency}x por semana',
                                  style: const TextStyle(
                                      color: AppColors.grey500,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (pkg.isExpiringSoon || pkg.isLowClasses) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded,
                                    color: AppColors.warning, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  pkg.isLowClasses
                                      ? '⚠️ Apenas ${pkg.remainingClasses} aula(s) restante(s). Renove!'
                                      : '⏰ Pacote expira em breve!',
                                  style: const TextStyle(
                                      color: AppColors.warning,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (pkg.scheduledDays.isNotEmpty) ...[
                    const SectionHeader(title: 'Dias Agendados'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: pkg.scheduledDays
                          .map((d) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Text(d,
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const SectionHeader(title: 'Histórico de Aulas'),
                  const SizedBox(height: 12),
                  ...sessions.map((s) => _SessionCard(session: s)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _PackageStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _PackageStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(
                color: AppColors.grey500, fontSize: 11)),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final dynamic session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(session.status as String);
    final statusLabel = _statusLabel(session.status as String);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon(session.status as String),
                color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fmtDate(session.date as DateTime),
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                if ((session.trainerNotes as String?) != null)
                  Text(
                    session.trainerNotes as String,
                    style: const TextStyle(
                        color: AppColors.grey500, fontSize: 11, height: 1.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(statusLabel,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'realizada': return AppColors.success;
      case 'agendada': return AppColors.primary;
      case 'cancelada': return AppColors.error;
      case 'remarcada': return AppColors.warning;
      default: return AppColors.grey500;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'realizada': return Icons.check_circle_outline;
      case 'agendada': return Icons.schedule;
      case 'cancelada': return Icons.cancel_outlined;
      case 'remarcada': return Icons.update;
      default: return Icons.circle_outlined;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'realizada': return 'Realizada';
      case 'agendada': return 'Agendada';
      case 'cancelada': return 'Cancelada';
      case 'remarcada': return 'Remarcada';
      default: return s;
    }
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}
