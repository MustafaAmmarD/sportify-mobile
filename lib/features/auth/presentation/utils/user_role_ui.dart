import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';

/// UI metadata (icon + localized text) for each [UserRole].
extension UserRoleUi on UserRole {
  IconData get icon => switch (this) {
        UserRole.player => Icons.sports_soccer,
        UserRole.club => Icons.shield_outlined,
        UserRole.agent => Icons.handshake_outlined,
        UserRole.scout => Icons.travel_explore,
        UserRole.coach => Icons.sports,
        UserRole.fan => Icons.favorite_border,
        UserRole.companyHr => Icons.business_center_outlined,
      };

  String label(AppLocalizations l10n) => switch (this) {
        UserRole.player => l10n.rolePlayer,
        UserRole.club => l10n.roleClub,
        UserRole.agent => l10n.roleAgent,
        UserRole.scout => l10n.roleScout,
        UserRole.coach => l10n.roleCoach,
        UserRole.fan => l10n.roleFan,
        UserRole.companyHr => l10n.roleCompanyHr,
      };

  String description(AppLocalizations l10n) => switch (this) {
        UserRole.player => l10n.rolePlayerDesc,
        UserRole.club => l10n.roleClubDesc,
        UserRole.agent => l10n.roleAgentDesc,
        UserRole.scout => l10n.roleScoutDesc,
        UserRole.coach => l10n.roleCoachDesc,
        UserRole.fan => l10n.roleFanDesc,
        UserRole.companyHr => l10n.roleCompanyHrDesc,
      };
}
