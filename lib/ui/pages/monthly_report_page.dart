import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:incisive/models/reports/user_monthly_stats.dart';
import 'package:incisive/state_management/blocs/base/base_bloc.dart';
import 'package:incisive/state_management/blocs/user_monthly_stats/user_monthly_stats_bloc.dart';
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
            child: Text('Nessun dato per questo mese 🍃'),
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
        children: [
          _buildSummaryCard(stats),
          const SizedBox(height: 20),
          Text("Totale inserimenti: ${stats.totalEmotions}"),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(UserMonthlyStats stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: stats.positiveRatio,
            color: Colors.green,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
          ),
          const SizedBox(width: 20),
          Text(
            "Mood Positivo: ${(stats.positiveRatio * 100).toInt()}%",
            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
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
