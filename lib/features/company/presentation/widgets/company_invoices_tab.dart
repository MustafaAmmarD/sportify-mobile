import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/company_models.dart';

/// Invoices tab listing billing history, payment statuses, and mock PDF download.
class CompanyInvoicesTab extends StatelessWidget {
  const CompanyInvoicesTab({super.key, required this.invoices});

  final List<CompanyInvoice> invoices;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    const amber = Color(0xFFF59E0B);

    final outstanding = invoices.where((i) => !i.paid).fold(0.0, (s, i) => s + i.amount);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (outstanding > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: amber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: amber.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Due',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '€${outstanding.toStringAsFixed(2)} outstanding',
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Pay Now',
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
          ),
        ...invoices.map((inv) => _InvoiceRow(inv: inv, card: card, border: border, green: green, amber: amber)),
      ],
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  const _InvoiceRow({
    required this.inv,
    required this.card,
    required this.border,
    required this.green,
    required this.amber,
  });

  final CompanyInvoice inv;
  final Color card;
  final Color border;
  final Color green;
  final Color amber;

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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: inv.paid ? green.withOpacity(0.1) : amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              inv.paid ? Icons.receipt_long_outlined : Icons.receipt_outlined,
              color: inv.paid ? green : amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv.month,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${inv.seats} seats · Club+ Plan',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '€${inv.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: inv.paid ? green.withOpacity(0.1) : amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: inv.paid ? green.withOpacity(0.4) : amber.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  inv.paid ? 'Paid' : 'Due',
                  style: TextStyle(
                    color: inv.paid ? green : amber,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.download_outlined,
              color: Colors.white38,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
