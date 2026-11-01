import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/core/theme/app_dimens.dart';
import 'package:sportify/core/widgets/language_switcher.dart';
import 'package:sportify/core/widgets/sportify_button.dart';
import 'package:sportify/core/widgets/sportify_text_field.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sportify/features/auth/presentation/widgets/auth_modals.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            email: _email.text.trim(),
            password: _password.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    const green = AppColors.green2;

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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => context.go(AppRoutes.home),
                            icon: const Icon(Icons.explore_outlined, color: green, size: 18),
                            label: const Text(
                              'Guest Mode',
                              style: TextStyle(color: green, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 180, child: LanguageSwitcher()),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(l10n.authWelcomeBack, style: text.headlineMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(l10n.authLoginSubtitle, style: text.bodyMedium),
                      const SizedBox(height: AppSpacing.xl),
                      SportifyTextField(
                        controller: _email,
                        label: l10n.authEmail,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) return l10n.authFieldRequired;
                          if (!value.contains('@') || !value.contains('.')) {
                            return l10n.authInvalidEmail;
                          }
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
                        validator: (v) => (v == null || v.isEmpty) ? l10n.authFieldRequired : null,
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => showForgotPasswordSheet(context),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(color: green, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) => SportifyButton(
                          text: l10n.authLogin,
                          isLoading: state is AuthLoading,
                          onPressed: _submit,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: () => showCompanyInviteSheet(context),
                        icon: const Icon(Icons.qr_code_scanner_rounded, color: green, size: 18),
                        label: const Text(
                          'Have a Company FIT-Pass Code / Invite Link?',
                          style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: green.withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Center(child: Text(l10n.authOrContinueWith)),
                      const SizedBox(height: AppSpacing.md),
                      const _SocialButtons(),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.authNoAccount),
                          SportifyButton(
                            text: l10n.authRegister,
                            type: SportifyButtonType.text,
                            onPressed: () => context.go(AppRoutes.register),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    Widget button(SocialProvider p, IconData icon, String label) => Expanded(
          child: OutlinedButton.icon(
            onPressed: () => bloc.add(AuthSocialLoginRequested(p)),
            icon: Icon(icon, size: 20),
            label: Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        );

    return Column(
      children: [
        Row(
          children: [
            button(SocialProvider.google, Icons.g_mobiledata_rounded, 'Google'),
            const SizedBox(width: AppSpacing.sm),
            button(SocialProvider.apple, Icons.apple_rounded, 'Apple'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            button(SocialProvider.facebook, Icons.facebook_rounded, 'Facebook'),
            const SizedBox(width: AppSpacing.sm),
            button(SocialProvider.tiktok, Icons.music_note_rounded, 'TikTok'),
          ],
        ),
      ],
    );
  }
}
