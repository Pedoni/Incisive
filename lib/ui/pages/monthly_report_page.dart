import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/reports/user_monthly_stats.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/mood_tracker/mood_tracker_bloc.dart';
import 'package:incisive/state_management/blocs/user_monthly_stats/user_monthly_stats_bloc.dart';
import 'package:incisive/ui/components/mood_calendar.dart';
import 'package:incisive/ui/widgets/empty_widget.dart';
import 'package:intl/intl.dart';

List<DateTime> buildMonths({required DateTime from, required DateTime to}) {
  final months = <DateTime>[];
  var current = DateTime(from.year, from.month);
  final end = DateTime(to.year, to.month);

  while (!current.isAfter(end)) {
    months.add(current);
    current = DateTime(current.year, current.month + 1);
  }
  return months;
}

class MonthlyReportPage extends StatefulWidget {
  static const routeName = '/monthlyReportPage';

  const MonthlyReportPage({super.key});

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  late final List<DateTime> _months;
  late DateTime _selectedMonth;
  late final ScrollController _monthScrollController;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _months = buildMonths(
      from: DateTime(2025, 8),
      to: DateTime(now.year, now.month),
    );

    _selectedMonth = _months.last;
    _monthScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_monthScrollController.hasClients) {
        _monthScrollController.jumpTo(_monthScrollController.position.maxScrollExtent);
      }
    });

    context.read<UserMonthlyStatsBloc>().getUserMonthlyStats(_selectedMonth);
    context.read<MoodTrackerBloc>().getMood();
  }

  Widget _buildMyDataTab() {
    const accentColor = Color.fromARGB(255, 141, 90, 35);

    return BlocBuilder<UserMonthlyStatsBloc, BaseState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        } else if (state is Error) {
          return Center(
            child: Text('Errore: ${state.errorString}'),
          );
        } else if (state is Empty) {
          return const Center(
            child: EmptyWidget(text: 'Nessun dato per questo mese'),
          );
        } else if (state is Success<UserMonthlyStats>) {
          return _buildReportContent(state.data);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGlobalDataTab() {
    return const Center(
      child: Text(
        'Dati globali\n(in arrivo)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Nunito Sans',
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    const accentColor = Color.fromARGB(255, 141, 90, 35);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),

          MonthPicker(
            months: _months,
            selected: _selectedMonth,
            controller: _monthScrollController,
            onChanged: (m) {
              setState(() => _selectedMonth = m);
              context.read<UserMonthlyStatsBloc>().getUserMonthlyStats(m);
            },
          ),

          const SizedBox(height: 12),

          const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: accentColor,
            labelColor: accentColor,
            unselectedLabelColor: Colors.black45,
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: 'I miei dati'),
              Tab(text: 'Dati globali'),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildMyDataTab(),
                _buildGlobalDataTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color.fromARGB(255, 141, 90, 35);
    const bgColor = Color(0xFFFFF8E8);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text(
            'Statistiche',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          foregroundColor: accentColor,
          backgroundColor: bgColor,
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildReportContent(UserMonthlyStats stats) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          MoodCalendar(year: _selectedMonth.year, month: _selectedMonth.month),
          _sectionTitle('Mood del mese'),
          const SizedBox(height: 20),
          _buildMoodPie(positiveRatio: stats.positiveRatio),
          const SizedBox(height: 20),
          _buildMoodSummaryText(stats.positiveRatio),
          const SizedBox(height: 40),
          _sectionTitle('Emozioni positive'),
          const SizedBox(height: 20),
          _buildBarChart(
            data: stats.emotionsPositive,
            barColor: const Color(0xFF2E7D32),
          ),

          const SizedBox(height: 40),

          _sectionTitle('Aree della vita positive'),
          const SizedBox(height: 20),
          _buildBarChart(
            data: stats.areasPositive,
            barColor: const Color(0xFF2E7D32),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color.fromARGB(255, 141, 90, 35),
    ),
  );
}

Widget _buildMoodSummaryText(double positiveRatio) {
  final positive = (positiveRatio * 100).round();
  final negative = 100 - positive;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _legendRow(
        color: const Color(0xFF2E7D32),
        label: 'Mood positivo',
        value: '$positive%',
      ),
      const SizedBox(height: 8),
      _legendRow(
        color: const Color(0xFFC62828),
        label: 'Mood negativo',
        value: '$negative%',
      ),
    ],
  );
}

Widget _legendRow({
  required Color color,
  required String label,
  required String value,
}) {
  return Row(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito Sans',
            fontSize: 14,
          ),
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontFamily: 'Nunito Sans',
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildMoodPie({
  required double positiveRatio,
}) {
  final negativeRatio = 1 - positiveRatio;

  return SizedBox(
    height: 200,
    child: PieChart(
      PieChartData(
        centerSpaceRadius: 45,
        sectionsSpace: 4,
        sections: [
          PieChartSectionData(
            value: positiveRatio * 100,
            color: const Color(0xFF2E7D32),
            title: '',
            radius: 60,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          PieChartSectionData(
            value: negativeRatio * 100,
            color: const Color(0xFFC62828),
            title: '',
            radius: 50,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 600),
    ),
  );
}

Widget _buildBarChart({
  required List<Map<String, dynamic>> data,
  required Color barColor,
}) {
  if (data.isEmpty) {
    return const Text(
      'Nessun dato disponibile',
      style: TextStyle(color: Colors.black45),
    );
  }

  final maxY = data.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b).toDouble();
  final chartWidth = data.length * 60.0; // 1 barra ≈ 60px
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    child: SizedBox(
      height: 220,
      width: chartWidth,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY + 1,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine:
                (value) => FlLine(
                  color: Colors.black.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget:
                    (value, _) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index]['name'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(data.length, (index) {
            final value = (data[index]['count'] as int).toDouble();

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: barColor,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY + 1,
                    color: barColor.withValues(alpha: 0.1),
                  ),
                ),
              ],
            );
          }),
        ),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      ),
    ),
  );
}

class MonthPicker extends StatelessWidget {
  final List<DateTime> months;
  final DateTime selected;
  final ValueChanged<DateTime> onChanged;
  final ScrollController controller;

  const MonthPicker({
    super.key,
    required this.months,
    required this.selected,
    required this.onChanged,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color.fromARGB(255, 141, 90, 35);

    return SizedBox(
      height: 100,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: months.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final m = months[index];
          final isSelected = m.year == selected.year && m.month == selected.month;

          return GestureDetector(
            onTap: () {
              if (!isSelected) onChanged(m);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 85,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? accentColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: Border.all(
                  color: isSelected ? accentColor : accentColor.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM(Localizations.localeOf(context).languageCode).format(m).toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: isSelected ? Colors.white : accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${m.year}',
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.black45,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
