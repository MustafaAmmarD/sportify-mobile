/// Represents an employee assigned to a company FIT-Pass corporate plan.
class CompanyEmployee {
  const CompanyEmployee({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.plan,
    required this.status,
    required this.lastActive,
    required this.checkIns,
  });

  final String id;
  final String name;
  final String role;
  final String email;
  final String plan;
  final String status; // active | pending | inactive
  final String lastActive;
  final int checkIns;
}

/// Represents a corporate billing invoice.
class CompanyInvoice {
  const CompanyInvoice({
    required this.month,
    required this.seats,
    required this.amount,
    required this.paid,
  });

  final String month;
  final int seats;
  final double amount;
  final bool paid;
}

const List<String> kCompanyPlans = [
  'Bronze',
  'Silver',
  'Gold',
  'Scout',
  'Platinum',
  'Digital',
];

const List<CompanyEmployee> kMockEmployees = [
  CompanyEmployee(
    id: '1',
    name: 'Marco Rossi',
    role: 'Player',
    email: 'marco@sportify.de',
    plan: 'Silver',
    status: 'active',
    lastActive: '2d ago',
    checkIns: 14,
  ),
  CompanyEmployee(
    id: '2',
    name: 'Sophia Bauer',
    role: 'Coach',
    email: 'sophia@sportify.de',
    plan: 'Gold',
    status: 'active',
    lastActive: '1d ago',
    checkIns: 9,
  ),
  CompanyEmployee(
    id: '3',
    name: 'Luca Meier',
    role: 'Player',
    email: 'luca@sportify.de',
    plan: 'Bronze',
    status: 'pending',
    lastActive: '—',
    checkIns: 0,
  ),
  CompanyEmployee(
    id: '4',
    name: 'Aisha Ndoye',
    role: 'Scout',
    email: 'aisha@sportify.de',
    plan: 'Scout',
    status: 'active',
    lastActive: '3h ago',
    checkIns: 22,
  ),
  CompanyEmployee(
    id: '5',
    name: 'Thomas Klein',
    role: 'Player',
    email: 'thomas@sportify.de',
    plan: 'Silver',
    status: 'active',
    lastActive: '5d ago',
    checkIns: 6,
  ),
  CompanyEmployee(
    id: '6',
    name: 'Hannah Wolf',
    role: 'Player',
    email: 'hannah@sportify.de',
    plan: 'Digital',
    status: 'inactive',
    lastActive: '30d ago',
    checkIns: 1,
  ),
  CompanyEmployee(
    id: '7',
    name: 'Carlos Suárez',
    role: 'Agent',
    email: 'carlos@sportify.de',
    plan: 'Platinum',
    status: 'active',
    lastActive: 'Today',
    checkIns: 18,
  ),
  CompanyEmployee(
    id: '8',
    name: 'Yuki Tanaka',
    role: 'Player',
    email: 'yuki@sportify.de',
    plan: 'Silver',
    status: 'active',
    lastActive: 'Today',
    checkIns: 11,
  ),
];

const List<CompanyInvoice> kMockInvoices = [
  CompanyInvoice(month: 'October 2026', seats: 8, amount: 312.0, paid: false),
  CompanyInvoice(month: 'September 2026', seats: 8, amount: 312.0, paid: true),
  CompanyInvoice(month: 'August 2026', seats: 7, amount: 276.5, paid: true),
  CompanyInvoice(month: 'July 2026', seats: 7, amount: 276.5, paid: true),
];
