import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/company_models.dart';
import 'company_sheets.dart';

/// Employees tab with searchable directory and plan modifier action sheet.
class CompanyEmployeesTab extends StatelessWidget {
  const CompanyEmployeesTab({
    super.key,
    required this.employees,
    required this.search,
    required this.query,
    required this.onQuery,
  });

  final List<CompanyEmployee> employees;
  final TextEditingController search;
  final String query;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    final filtered = employees.where((e) {
      if (query.isEmpty) return true;
      return e.name.toLowerCase().contains(query) ||
          e.email.toLowerCase().contains(query) ||
          e.plan.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: search,
            onChanged: (v) => onQuery(v.toLowerCase()),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search employees...',
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
              filled: true,
              fillColor: card,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: green),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _EmployeeCard(
              emp: filtered[i],
              card: card,
              border: border,
              green: green,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.emp,
    required this.card,
    required this.border,
    required this.green,
  });

  final CompanyEmployee emp;
  final Color card;
  final Color border;
  final Color green;

  Color get _statusColor => switch (emp.status) {
        'active' => green,
        'pending' => const Color(0xFFF59E0B),
        _ => Colors.white24,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _statusColor.withOpacity(0.12),
              border: Border.all(color: _statusColor.withOpacity(0.5)),
            ),
            child: Text(
              emp.name[0].toUpperCase(),
              style: TextStyle(
                color: _statusColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        emp.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _PlanBadge(emp.plan),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${emp.role} · ${emp.email}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      emp.status[0].toUpperCase() + emp.status.substring(1),
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${emp.checkIns} check-ins',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      emp.lastActive,
                      style: const TextStyle(color: Colors.white24, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          PopupMenuButton<String>(
            color: card,
            icon: const Icon(Icons.more_vert, color: Colors.white38, size: 18),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'plan',
                child: Text('Change Plan', style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
              const PopupMenuItem(
                value: 'remove',
                child: Text('Remove', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
              ),
            ],
            onSelected: (v) {
              if (v == 'plan') {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: card,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => ChangePlanSheet(emp: emp),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  const _PlanBadge(this.plan);
  final String plan;

  Color get _color => switch (plan) {
        'Silver' => const Color(0xFF94A3B8),
        'Gold' => const Color(0xFFF59E0B),
        'Scout' => const Color(0xFF818CF8),
        'Platinum' => const Color(0xFFA78BFA),
        'Bronze' => const Color(0xFFF97316),
        'Digital' => const Color(0xFF38BDF8),
        _ => AppColors.green2,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        plan,
        style: TextStyle(color: _color, fontSize: 10, fontWeight: FontWeight.w800),
      ),
    );
  }
}
