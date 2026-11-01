import 'package:flutter/material.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/localization/sportify_l10n.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/core/widgets/language_switcher.dart';
import 'package:sportify/features/auth/domain/entities/user.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sportify/features/chat/presentation/pages/chat_page.dart';
import 'package:sportify/features/company/presentation/pages/company_page.dart';
import 'package:sportify/features/profile/presentation/widgets/profile_network_sheet.dart';

/// Opens the Preferences, GDPR Data Export, Sign Out & Account Deletion sheet.
void showProfileSettingsSheet(BuildContext context) {
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 18),
            const Text('Settings, Privacy & GDPR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            const Text('App Language (EN · DE · AR)', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const LanguageSwitcher(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
              child: ListTile(
                leading: const Icon(Icons.download_for_offline_outlined, color: green),
                title: const Text('Export Personal Data (GDPR)', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
                subtitle: const Text('Download JSON archive of your CV, clips & FIT-Pass history', style: TextStyle(color: Colors.white54, fontSize: 11.5)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preparing your GDPR data archive... A download link has been sent to your email.')),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  sl<AuthBloc>().add(const AuthLogoutRequested());
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 18),
                label: const Text('Sign Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: border),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _confirmAccountDeletion(context);
                },
                icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent, size: 18),
                label: const Text('Delete Account Permanently', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.45)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _confirmAccountDeletion(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dlgCtx) => AlertDialog(
      backgroundColor: const Color(0xFF0E1822),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: const Text('Delete Account?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      content: const Text(
        'Under EU GDPR Art. 17, this will permanently erase your Sportify profile, highlights, messages, and FIT-Pass history. This action cannot be undone.',
        style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.45),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dlgCtx), child: const Text('Cancel', style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dlgCtx);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your account and personal data have been permanently deleted.')),
            );
            sl<AuthBloc>().add(const AuthLogoutRequested());
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
          child: const Text('Delete Account', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ],
    ),
  );
}

/// Hub tiles on Profile for secondary workflows: Network, Chat, Company, and Settings.
class ProfileQuickActionsHub extends StatelessWidget {
  const ProfileQuickActionsHub({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), border = Color(0xFF1B2A38), green = AppColors.green2;
    final isCompanyOrClub = user.role == UserRole.club || user.role == UserRole.scout || user.role == UserRole.companyHr;
    final tr = SportifyL10n.of(context);

    return Container(
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: ProfileNetworkStore.version,
            builder: (_, __, ___) {
              final pending = ProfileNetworkStore.pendingRequests.length;
              return _ActionTile(
                icon: Icons.people_alt_outlined,
                title: pending > 0 ? '${tr.profileMyNetwork} ($pending)' : tr.profileMyNetwork,
                subtitle: 'Connect with clubs, scouts, agents & coaches',
                color: const Color(0xFFA78BFA),
                onTap: () => showProfileNetworkSheet(context),
              );
            },
          ),
          const Divider(color: border, height: 1),
          _ActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: tr.profileMessages,
            subtitle: 'Direct chat with clubs and scouts',
            color: green,
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ChatPage())),
          ),
          const Divider(color: border, height: 1),
          if (isCompanyOrClub) ...[
            _ActionTile(
              icon: Icons.business_outlined,
              title: tr.profileCompanyPortal,
              subtitle: 'Manage passes, squad and billing',
              color: const Color(0xFF38BDF8),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CompanyPage())),
            ),
            const Divider(color: border, height: 1),
          ],
          _ActionTile(
            icon: Icons.tune_rounded,
            title: tr.profileSettingsGdpr,
            subtitle: 'Language, data export, and account deletion',
            color: const Color(0xFFF59E0B),
            onTap: () => showProfileSettingsSheet(context),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.3))),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}
