import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/company/domain/entities/company_models.dart';
import 'package:sportify/features/company/presentation/widgets/company_overview_widgets.dart';

/// Overview tab displaying usage charts, plan distribution, and top performers.
class CompanyOverviewTab extends StatelessWidget {
  const CompanyOverviewTab({super.key, required this.employees});

  final List<CompanyEmployee> employees;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    const amber = Color(0xFFF59E0B);

    final planCounts = <String, int>{};
    for (final e in employees) {
      planCounts[e.plan] = (planCounts[e.plan] ?? 0) + 1;
    }
    final totalCheckIns = employees.fold(0, (s, e) => s + e.checkIns);
    final activePct = (employees.where((e) => e.status == 'active').length /
            employees.length *
            100)
        .round();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CompanySectionCard(
          title: 'Monthly Usage',
          card: card,
          border: border,
          green: green,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CompanyUsageStat(
                    'Total check-ins',
                    '$totalCheckIns',
                    Icons.qr_code_scanner,
                    green,
                  ),
                  CompanyUsageStat(
                    'Active members',
                    '$activePct%',
                    Icons.people_outline,
                    green,
                  ),
                  const CompanyUsageStat(
                    'Partner gyms',
                    '23',
                    Icons.location_on_outlined,
                    green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Check-in activity (mock)',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
              const SizedBox(height: 8),
              const CompanyActivityBars(green: green),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CompanySectionCard(
          title: 'Plan Distribution',
          card: card,
          border: border,
          green: green,
          child: Column(
            children: planCounts.entries.map((e) {
              final pct = e.value / employees.length;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.key,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${e.value} seat${e.value > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 7,
                        backgroundColor: const Color(0xFF14222E),
                        valueColor: const AlwaysStoppedAnimation(green),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        CompanySectionCard(
          title: '🏆 Top Performers (Check-ins)',
          card: card,
          border: border,
          green: green,
          child: Column(
            children: ([...employees]..sort((a, b) => b.checkIns.compareTo(a.checkIns)))
                .take(5)
                .toList()
                .asMap()
                .entries
                .map((entry) {
              final rank = entry.key + 1;
              final emp = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Text(
                      '$rank',
                      style: TextStyle(
                        color: rank == 1 ? amber : Colors.white38,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        emp.name,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    CompanyPlanBadge(emp.plan),
                    const SizedBox(width: 10),
                    Text(
                      '${emp.checkIns}×',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
