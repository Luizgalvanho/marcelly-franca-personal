import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final sessions = state.sessions.where((s) =>
        s.studentId ==
        (state.isTrainer ? 'student_001' : state.currentUser?.id)).toList();

    final daysSessions = sessions
        .where((s) =>
            s.date.day == _selectedDate.day &&
            s.date.month == _selectedDate.month &&
            s.date.year == _selectedDate.year)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Agenda'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Calendar header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Month navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: AppColors.white),
                      onPressed: () => setState(() {
                        _currentMonth = DateTime(
                            _currentMonth.year, _currentMonth.month - 1);
                      }),
                    ),
                    Text(
                      _monthLabel(_currentMonth),
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right,
                          color: AppColors.white),
                      onPressed: () => setState(() {
                        _currentMonth = DateTime(
                            _currentMonth.year, _currentMonth.month + 1);
                      }),
                    ),
                  ],
                ),
                // Days of week header
                Row(
                  children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
                      .map((d) => Expanded(
                            child: Center(
                              child: Text(d,
                                  style: const TextStyle(
                                      color: AppColors.grey500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),
                // Calendar grid
                _buildCalendarGrid(sessions),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Selected day sessions
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dia ${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  if (daysSessions.isEmpty)
                    DarkCard(
                      child: Row(
                        children: [
                          const Text('😴', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          const Text('Nenhuma aula neste dia',
                              style: TextStyle(
                                  color: AppColors.grey500, fontSize: 14)),
                        ],
                      ),
                    )
                  else
                    ...daysSessions.map((s) => _SessionTile(session: s)),
                  const SizedBox(height: 20),
                  // Upcoming sessions
                  const SectionHeader(title: 'Próximas Aulas'),
                  const SizedBox(height: 12),
                  ...sessions
                      .where((s) =>
                          s.date.isAfter(DateTime.now()) &&
                          s.status == 'agendada')
                      .take(5)
                      .map((s) => _SessionTile(session: s)),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List sessions) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startOffset = firstDay.weekday % 7;
    final totalDays = lastDay.day;

    final sessionDates = sessions
        .where((s) =>
            (s.date as DateTime).month == _currentMonth.month &&
            (s.date as DateTime).year == _currentMonth.year)
        .map((s) => (s.date as DateTime).day)
        .toSet();

    final cells = <Widget>[];
    for (int i = 0; i < startOffset; i++) {
      cells.add(const SizedBox());
    }
    for (int d = 1; d <= totalDays; d++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, d);
      final isToday = date.day == DateTime.now().day &&
          date.month == DateTime.now().month &&
          date.year == DateTime.now().year;
      final isSelected = date.day == _selectedDate.day &&
          date.month == _selectedDate.month &&
          date.year == _selectedDate.year;
      final hasSession = sessionDates.contains(d);

      cells.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary, width: 1)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$d',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.white,
                    fontSize: 13,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                if (hasSession)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      children: cells,
    );
  }

  String _monthLabel(DateTime dt) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

class _SessionTile extends StatelessWidget {
  final dynamic session;
  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final status = session.status as String;
    final color = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aula Presencial',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  _fmtDate(session.date as DateTime),
                  style: const TextStyle(
                      color: AppColors.grey500, fontSize: 12),
                ),
                if ((session.trainerNotes as String?) != null)
                  Text(
                    session.trainerNotes as String,
                    style: const TextStyle(
                        color: AppColors.grey500, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _statusLabel(status),
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
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

  String _statusLabel(String s) {
    switch (s) {
      case 'realizada': return 'Realizada';
      case 'agendada': return 'Agendada';
      case 'cancelada': return 'Cancelada';
      case 'remarcada': return 'Remarcada';
      default: return s;
    }
  }

  String _fmtDate(DateTime dt) {
    const months = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}. ${dt.year}';
  }
}
