import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/core/theme/app_dimens.dart';
import 'package:sportify/core/widgets/sportify_button.dart';
import 'package:sportify/core/widgets/sportify_text_field.dart';
import 'package:sportify/features/auth/domain/entities/user_role.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sportify/features/auth/presentation/widgets/auth_modals.dart';
import 'package:sportify/features/auth/presentation/widgets/register_step_header.dart';
import 'package:sportify/features/auth/presentation/widgets/role_card.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _detailsKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _orgOrClub = TextEditingController();
  final _roleMeta = TextEditingController();
  final _companyCode = TextEditingController();

  int _step = 0;
  UserRole? _role;
  bool _consent = false;
  bool _aiAnalyticsConsent = true;
  bool _marketingConsent = false;
  bool _obscure = true;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _orgOrClub.dispose();
    _roleMeta.dispose();
    _companyCode.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_step) {
        0 => _role != null,
        2 => _consent,
        _ => true,
      };

  void _next() {
    if (_step == 1 && !(_detailsKey.currentState?.validate() ?? false)) return;
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    context.read<AuthBloc>().add(
          AuthRegisterSubmitted(
            email: _email.text.trim(),
            password: _password.text,
            role: _role!,
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            gdprConsent: _consent,
          ),
        );
  }

  void _back() {
    if (_step == 0) {
      context.go(AppRoutes.login);
    } else {
      setState(() => _step--);
    }
  }

  (String, String) _roleFieldLabels() => switch (_role) {
        UserRole.player => ('Current Club / Academy', 'Primary Position (e.g. CAM, ST, CB)'),
        UserRole.club => ('Official Club Name', 'League / Division (e.g. Bundesliga)'),
        UserRole.agent => ('Agency Name', 'FIFA Agent License ID'),
        UserRole.scout => ('Club / Scouting Organization', 'Scouting Region (e.g. DACH / Europe)'),
        UserRole.coach => ('Club / Academy Name', 'Coaching License (e.g. UEFA Pro / A)'),
        UserRole.companyHr => ('Company Legal Name', 'HR Department / Industry'),
        _ => ('Favorite Club (Optional)', 'Preferred League'),
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthFailureState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: _back),
          title: Text(l10n.authCreateAccount),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  RegisterStepHeader(
                    current: _step,
                    labels: [l10n.authStepRole, l10n.authStepDetails, l10n.authStepConsent],
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: KeyedSubtree(
                        key: ValueKey(_step),
                        child: switch (_step) {
                          0 => _roleStep(l10n),
                          1 => _detailsStep(l10n),
                          _ => _consentStep(l10n),
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) => SizedBox(
                        width: double.infinity,
                        child: SportifyButton(
                          text: _step == 2 ? l10n.authRegister : l10n.authNext,
                          isLoading: state is AuthLoading,
                          onPressed: _canContinue ? _next : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleStep(AppLocalizations l10n) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(l10n.authChooseRole, style: text.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(l10n.authChooseRoleSubtitle, style: text.bodyMedium),
        const SizedBox(height: AppSpacing.lg),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.95,
          children: [
            for (final role in UserRole.values)
              RoleCard(
                role: role,
                selected: role == _role,
                onTap: () => setState(() => _role = role),
              ),
          ],
        ),
      ],
    );
  }

  Widget _detailsStep(AppLocalizations l10n) {
    String? required(String? v) => (v == null || v.trim().isEmpty) ? l10n.authFieldRequired : null;
    final (orgLabel, metaLabel) = _roleFieldLabels();

    return Form(
      key: _detailsKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Expanded(child: SportifyTextField(controller: _firstName, label: l10n.authFirstName, validator: required)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: SportifyTextField(controller: _lastName, label: l10n.authLastName, validator: required)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SportifyTextField(
            controller: _email,
            label: l10n.authEmail,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (v) {
              final value = v?.trim() ?? '';
              if (value.isEmpty) return l10n.authFieldRequired;
              if (!value.contains('@') || !value.contains('.')) return l10n.authInvalidEmail;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          SportifyTextField(
            controller: _password,
            label: l10n.authPassword,
            obscureText: _obscure,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.authFieldRequired;
              if (v.length < 8) return l10n.authPasswordShort;
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          SportifyTextField(controller: _orgOrClub, label: orgLabel, prefixIcon: const Icon(Icons.shield_outlined)),
          const SizedBox(height: AppSpacing.lg),
          SportifyTextField(controller: _roleMeta, label: metaLabel, prefixIcon: const Icon(Icons.badge_outlined)),
          const SizedBox(height: AppSpacing.lg),
          SportifyTextField(controller: _companyCode, label: 'Company FIT-Pass Invite Code (Optional)', prefixIcon: const Icon(Icons.qr_code_rounded)),
        ],
      ),
    );
  }

  Widget _consentStep(AppLocalizations l10n) {
    final text = Theme.of(context).textTheme;
    const green = AppColors.green2;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(l10n.authConsentTitle, style: text.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        const Text('Sportify complies with EU GDPR regulations. Review and control how your professional and wellness data is used.', style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4)),
        const SizedBox(height: AppSpacing.md),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, activeColor: green,
          value: _consent, onChanged: (v) => setState(() => _consent = v ?? false),
          title: Text('${l10n.authGdprConsent} (Required)', style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          subtitle: const Text('Terms of Service, Privacy Policy & GDPR Art. 6 data processing.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, activeColor: green,
          value: _aiAnalyticsConsent, onChanged: (v) => setState(() => _aiAnalyticsConsent = v ?? true),
          title: Text('AI Scouting & Fit-Score Matching (Optional)', style: text.bodyMedium),
          subtitle: const Text('Allow clubs and scouts to discover your profile via Sportify AI.', style: TextStyle(color: Colors.white54, fontSize: 12)),
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, activeColor: green,
          value: _marketingConsent, onChanged: (v) => setState(() => _marketingConsent = v ?? false),
          title: Text('FIT-Pass Partner Offers & News (Optional)', style: text.bodyMedium),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => showGdprPolicySheet(context),
            icon: const Icon(Icons.policy_outlined, color: green, size: 18),
            label: const Text('Read Full EU GDPR & Privacy Policy', style: TextStyle(color: green, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}
