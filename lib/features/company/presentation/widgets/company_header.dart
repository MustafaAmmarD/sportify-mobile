import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/company_models.dart';

/// Top header banner for Company HR dashboard.
class CompanyHeader extends StatelessWidget {
  const CompanyHeader({
    super.key,
    required this.employees,
    required this.onAddEmployee,
  });

  final List<CompanyEmployee> employees;
  final VoidCallback onAddEmployee;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    const amber = Color(0xFFF59E0B);
    const blue = Color(0xFF38BDF8);

    final active = employees.where((e) => e.status == 'active').length;
    final pending = employees.where((e) => e.status == 'pending').length;
    final total = employees.length;
    final checkIns = employees.fold(0, (s, e) => s + e.checkIns);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (Navigator.canPop(context)) ...[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: green.withOpacity(0.4)),
                ),
                child: const Text(
                  'COMPANY HR',
                  style: TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onAddEmployee,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '+ Add Employee',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Sportify FC',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Club+ Plan · $total seats',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _QuickStat(label: 'Employees', value: '$total', color: Colors.white, card: card, border: border),
              const SizedBox(width: 10),
              _QuickStat(label: 'Active', value: '$active', color: green, card: card, border: border),
              const SizedBox(width: 10),
              _QuickStat(label: 'Pending', value: '$pending', color: amber, card: card, border: border),
              const SizedBox(width: 10),
              _QuickStat(label: 'Check-ins', value: '$checkIns', color: blue, card: card, border: border),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.label,
    required this.value,
    required this.color,
    required this.card,
    required this.border,
  });

  final String label;
  final String value;
  final Color color;
  final Color card;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
