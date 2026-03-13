import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_state.dart';
import '../../widgets/common_widgets.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hydration = state.todayHydration;
    final consumed = hydration?.consumedLiters ?? 0.0;
    final goal = hydration?.goalLiters ?? 2.5;
    final progress = (consumed / goal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hidratação'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main water display
            GradientCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D2137), Color(0xFF0A1520)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                children: [
                  // Animated water bottle
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Water fill animation
                        Container(
                          width: 90,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFF29B6F6).withValues(alpha: 0.1),
                            border: Border.all(
                              color: const Color(0xFF29B6F6).withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                height: 160 * progress,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(10),
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0D47A1),
                                      Color(0xFF29B6F6),
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${consumed.toStringAsFixed(1)}L',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'de ${goal}L',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hydration?.goalReached == true
                        ? '🎉 Meta atingida! Você é incrível!'
                        : '${((goal - consumed).clamp(0, goal)).toStringAsFixed(1)}L para atingir sua meta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: hydration?.goalReached == true
                          ? AppColors.success
                          : const Color(0xFF29B6F6),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PinkProgressBar(value: progress, height: 8),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}% da meta diária',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick add buttons
            const SectionHeader(title: 'Registrar Consumo'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
              children: [
                _WaterAddButton(
                    emoji: '🥤', label: 'Copo\n200ml', amount: 0.2),
                _WaterAddButton(
                    emoji: '🍶', label: 'Caneca\n300ml', amount: 0.3),
                _WaterAddButton(
                    emoji: '💧', label: 'Copo\n500ml', amount: 0.5),
                _WaterAddButton(
                    emoji: '🍼', label: 'Garrafinha\n600ml', amount: 0.6),
                _WaterAddButton(
                    emoji: '🫙', label: 'Garrafa\n1L', amount: 1.0),
                _WaterAddButton(
                    emoji: '🧃', label: 'Garrafa\n1.5L', amount: 1.5),
              ],
            ),
            const SizedBox(height: 24),
            // Tips
            const SectionHeader(title: 'Dicas de Hidratação'),
            const SizedBox(height: 12),
            ..._tips.map((tip) => _TipCard(tip: tip)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, String>> _tips = [
    {
      'icon': '⏰',
      'title': 'Hidrate-se ao acordar',
      'desc': 'Beba 300-500ml de água assim que acordar para reidratar o corpo.'
    },
    {
      'icon': '💪',
      'title': 'Antes do treino',
      'desc': 'Beba 500ml de água 30 minutos antes do treino para otimizar o desempenho.'
    },
    {
      'icon': '🍋',
      'title': 'Água com limão',
      'desc': 'Adicione limão à água para facilitar a hidratação e obter vitamina C.'
    },
    {
      'icon': '📱',
      'title': 'Use lembretes',
      'desc': 'Configure lembretes a cada 2 horas para não esquecer de se hidratar.'
    },
  ];
}

class _WaterAddButton extends StatelessWidget {
  final String emoji;
  final String label;
  final double amount;
  const _WaterAddButton(
      {required this.emoji, required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AppState>().addWaterSimple(amount);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '+${(amount * 1000).toInt()}ml registrado! 💧'),
            backgroundColor: const Color(0xFF29B6F6),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF29B6F6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFF29B6F6).withValues(alpha: 0.25),
              width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final Map<String, String> tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(tip['icon']!, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip['title']!,
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(tip['desc']!,
                    style: const TextStyle(
                        color: AppColors.grey500, fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
