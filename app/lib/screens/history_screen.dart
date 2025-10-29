import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/skin_analysis_model.dart';

// Sử dụng Riverpod để cung cấp dữ liệu lịch sử
final historyProvider = Provider<List<SkinAnalysis>>((ref) {
  return [
    SkinAnalysis.empty().copyWith(
        skinScore: 7.5,
        skinType: 'Da dầu',
        date: DateTime.now().subtract(const Duration(days: 60))),
    SkinAnalysis.empty().copyWith(
        skinScore: 8.2,
        skinType: 'Da hỗn hợp',
        date: DateTime.now().subtract(const Duration(days: 30))),
    SkinAnalysis.empty().copyWith(
        skinScore: 8.5,
        skinType: 'Da thường',
        date: DateTime.now().subtract(const Duration(days: 7))),
  ];
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyList = ref.watch(historyProvider);
    final theme = Theme.of(context);

    // Lightweight localization helper — dùng thay cho AppLocalizations khi file generated không có
    String t(String en, String vi) {
      try {
        final code = Localizations.localeOf(context).languageCode;
        return code == 'vi' ? vi : en;
      } catch (_) {
        return en;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(t('History', 'Lịch sử'))),
      body: historyList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(t('No history yet', 'Không có lịch sử')),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(t('Skin progression', 'Tiến trình da'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child:
                        LineChart(_buildChartData(context, historyList, theme)),
                  ),
                ),
                const Divider(height: 32),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final item = historyList[index];
                      final formattedDate =
                          DateFormat('dd/MM/yyyy').format(item.date!);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primary.withAlpha(30),
                            child: Text(
                              item.skinScore.toStringAsFixed(1),
                              style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                              '${t('Score', 'Điểm')}: ${item.skinScore.toStringAsFixed(1)}/10'),
                          subtitle: Text(
                              '${t('Date', 'Ngày phân tích')}: $formattedDate'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            // TODO: Điều hướng đến màn hình chi tiết kết quả phân tích cũ
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Hàm _buildChartData không thay đổi, giữ nguyên như cũ...
  LineChartData _buildChartData(
      BuildContext context, List<SkinAnalysis> history, ThemeData theme) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => theme.colorScheme.primary,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                'Điểm: ${spot.y.toStringAsFixed(1)}',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            }).toList();
          },
        ),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < history.length) {
                final date = history[value.toInt()].date!;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(DateFormat('dd/MM').format(date),
                      style: const TextStyle(fontSize: 10)),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: history.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value.skinScore);
          }).toList(),
          isCurved: true,
          color: theme.colorScheme.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: theme.colorScheme.primary.withAlpha(50),
          ),
          dotData: const FlDotData(show: true),
        ),
      ],
      minY: 0,
      maxY: 10.5,
    );
  }
}
