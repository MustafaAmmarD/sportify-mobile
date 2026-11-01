import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/company_models.dart';
import '../widgets/company_employees_tab.dart';
import '../widgets/company_header.dart';
import '../widgets/company_invoices_tab.dart';
import '../widgets/company_overview_tab.dart';
import '../widgets/company_sheets.dart';

/// Entry page for Company HR dashboard featuring 3 segments:
/// Overview, Employees directory, and Billing invoices.
class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  void _showAddEmployeeSheet(BuildContext ctx) {
    showModalBottomSheet<void>(
      context: ctx,
      backgroundColor: const Color(0xFF0E1822),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddEmployeeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const green = AppColors.green2;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            CompanyHeader(
              employees: kMockEmployees,
              onAddEmployee: () => _showAddEmployeeSheet(context),
            ),
            Container(
              color: bg,
              child: TabBar(
                controller: _tabs,
                labelColor: green,
                unselectedLabelColor: Colors.white38,
                indicatorColor: green,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Employees'),
                  Tab(text: 'Invoices'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  const CompanyOverviewTab(employees: kMockEmployees),
                  CompanyEmployeesTab(
                    employees: kMockEmployees,
                    search: _search,
                    query: _query,
                    onQuery: (q) => setState(() => _query = q),
                  ),
                  const CompanyInvoicesTab(invoices: kMockInvoices),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
