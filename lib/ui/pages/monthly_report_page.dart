import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Map<String, dynamic>? report;
  bool loading = false;
  String? error;

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
        _monthScrollController.jumpTo(
          _monthScrollController.position.maxScrollExtent,
        );
      }
    });

    _loadMonth(_selectedMonth);
  }

  Future<void> _loadMonth(DateTime month) async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final supabase = Supabase.instance.client;
      final map = {
        'p_user_id': supabase.auth.currentUser!.id,
        'p_year': month.year,
        'p_month': month.month,
      };
      final Map<String, dynamic> res = await supabase.rpc(
        'get_user_monthly_stats',
        params: map,
      );

      setState(() {
        report = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'Report mensile',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 141, 90, 35),
          ),
        ),
        foregroundColor: const Color.fromARGB(255, 141, 90, 35),
        backgroundColor: const Color(0xFFFFF8E8),
      ),
      body: Container(
        color: const Color(0xFFFFF8E8),
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
                _loadMonth(m);
              },
            ),

            const SizedBox(height: 24),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Text(
          'Errore: $error',
          style: const TextStyle(color: Colors.black54),
        ),
      );
    }
    if (report == null) {
      return const Center(child: Text('Nessun dato'));
    }

    // Placeholder: per ora solo testo
    return SingleChildScrollView(
      child: Text(
        report.toString(),
        style: const TextStyle(fontFamily: 'Nunito Sans'),
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
    return SizedBox(
      height: 90,
      child: ListView.separated(
        controller: controller, // 👈 QUI
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: months.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final m = months[index];
          final isSelected = m.year == selected.year && m.month == selected.month;

          return GestureDetector(
            onTap: () => onChanged(m),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              decoration: BoxDecoration(
                color: isSelected ? const Color.fromARGB(255, 141, 90, 35) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(255, 141, 90, 35).withOpacity(isSelected ? 0 : 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM(
                      Localizations.localeOf(context).toString(),
                    ).format(m).toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    '${m.year}',
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      color: isSelected ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
