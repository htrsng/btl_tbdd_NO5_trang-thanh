import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../models/skin_analysis_model.dart';
import '../l10n/app_localizations.dart';
import '../providers/navigation_provider.dart';
import '../providers/history_provider.dart'; // Import provider mới
import 'steps/results_step.dart'; // Import ResultsStep để tái sử dụng

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  // Hàm helper để hiển thị dialog xác nhận, giúp tái sử dụng code
  Future<bool> _showConfirmationDialog(
      BuildContext context, AppLocalizations l10n,
      {required String content}) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deleteHistoryTitle),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancelButton),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.deleteButton),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return confirmed ?? false; // Trả về false nếu người dùng đóng dialog
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyList = ref.watch(historyProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: [
          // Nút "Xóa tất cả" chỉ hiện khi có lịch sử
          if (historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () async {
                final confirmed = await _showConfirmationDialog(context, l10n,
                    content: l10n.deleteAllHistoryConfirmation);
                if (confirmed) {
                  ref.read(historyProvider.notifier).state = [];
                }
              },
              tooltip: l10n.deleteAll,
            ),
        ],
      ),
      body: historyList.isEmpty
          ? _buildEmptyState(context, ref, l10n)
          : _buildHistoryContent(context, historyList, l10n, ref),
    );
  }

  // --- WIDGET CON ĐƯỢC TÁCH RA CHO GỌN GÀNG ---

  Widget _buildEmptyState(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              l10n.noHistoryMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(l10n.startAnalysisButton),
              onPressed: () {
                // Chuyển người dùng về tab Trang chủ (index 0)
                ref.read(mainTabIndexProvider.notifier).state = 0;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContent(BuildContext context,
      List<SkinAnalysis> historyList, AppLocalizations l10n, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(l10n.skinProgressionChartTitle,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 24.0, 0),
            child: LineChart(_buildChartData(historyList, theme, l10n)),
          ),
        ),
        const Divider(height: 32),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final item = historyList[index];
              return _buildHistoryCard(context, item, theme, l10n, ref);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(BuildContext context, SkinAnalysis item,
      ThemeData theme, AppLocalizations l10n, WidgetRef ref) {
    final formattedDate = DateFormat('dd/MM/yyyy, HH:mm').format(item.date!);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: theme.colorScheme.primary.withAlpha(30),
          child: Text(item.skinScore.toStringAsFixed(1),
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ),
        title:
            Text('${l10n.skinScore}: ${item.skinScore.toStringAsFixed(1)}/10'),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${l10n.analysisDate}: $formattedDate'),
          Text('${l10n.skinType}: ${item.skinType}'),
        ]),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () async {
            final confirmed = await _showConfirmationDialog(context, l10n,
                content: l10n.deleteSingleHistoryConfirmation);
            if (confirmed) {
              final currentList = ref.read(historyProvider);
              // Lọc ra danh sách mới không chứa item cần xóa
              ref.read(historyProvider.notifier).state = currentList
                  .where((analysis) => analysis.date != item.date)
                  .toList();
            }
          },
        ),
        onTap: () {
          // Điều hướng đến màn hình chi tiết, tái sử dụng ResultsStep
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => HistoryDetailScreen(analysis: item),
          ));
        },
      ),
    );
  }

  LineChartData _buildChartData(
      List<SkinAnalysis> history, ThemeData theme, AppLocalizations l10n) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => theme.colorScheme.primary,
          getTooltipItems: (touchedSpots) => touchedSpots
              .map((spot) => LineTooltipItem(
                    '${l10n.skinScore}: ${spot.y.toStringAsFixed(1)}',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
              .toList(),
        ),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < history.length) {
                final date = history[index].date!;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 4,
                  child: Text(DateFormat('dd/MM').format(date),
                      style: const TextStyle(fontSize: 10)),
                );
              }
              return const Text('');
            },
          ))),
      lineBarsData: [
        LineChartBarData(
            spots: history
                .asMap()
                .entries
                .map((entry) =>
                    FlSpot(entry.key.toDouble(), entry.value.skinScore))
                .toList(),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
                show: true, color: theme.colorScheme.primary.withAlpha(50)),
            dotData: const FlDotData(show: true)),
      ],
      minY: 0,
      maxY: 10.5,
    );
  }
}

// Màn hình đơn giản để "host" ResultsStep khi xem lại lịch sử
class HistoryDetailScreen extends ConsumerWidget {
  final SkinAnalysis analysis;
  const HistoryDetailScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyDetailTitle)),
      body: ResultsStep(
          analysis: analysis), // Tái sử dụng ResultsStep một cách thông minh
    );
  }
}
