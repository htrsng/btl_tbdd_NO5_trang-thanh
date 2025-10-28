import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/skin_analysis_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Mock history (lưu local sau, tạm random 3 entries)
  final List<SkinAnalysis> _history = [
    SkinAnalysis(
      skinScore: 7.5,
      skinType: 'da dầu',
      analysis: {},
      improvements: {},
      products: {},
    ),
    SkinAnalysis(
      skinScore: 8.2,
      skinType: 'da thường',
      analysis: {},
      improvements: {},
      products: {},
    ),
    SkinAnalysis(
      skinScore: 6.8,
      skinType: 'da khô',
      analysis: {},
      improvements: {},
      products: {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử phân tích')),
      body: Column(
        children: [
          // Line chart so sánh score
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tiến bộ da (Score qua thời gian)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _history
                        .asMap()
                        .entries
                        .map((e) => FlSpot(e.key.toDouble(), e.value.skinScore))
                        .toList(),
                    isCurved: true,
                    color: Colors.green,
                  ),
                ],
                titlesData: FlTitlesData(show: true),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // List history cards
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${item.skinScore.toStringAsFixed(1)}'),
                    ),
                    title: Text(
                      'Phân tích ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}',
                    ),
                    subtitle: Text('Loại da: ${item.skinType}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => print('Xem chi tiết history $index'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
