import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/theme/app_colors.dart';

/// Opens the Forgot Password / Reset Link modal bottom sheet.
Future<void> showForgotPasswordSheet(BuildContext context) {
  final emailCtrl = TextEditingController();
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
  var sent = false;
  String? errorText;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 14,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 26,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
                  child: Icon(sent ? Icons.mark_email_read_rounded : Icons.lock_reset_rounded, color: green, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    sent ? 'Check Your Inbox' : 'Reset Your Password',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sent) ...[
              Text(
                'We sent a password reset link to ${emailCtrl.text.trim()}. Follow the link in the email to set a new password.',
                style: const TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.45),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(sheetCtx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back to Sign In', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ] else ...[
              const Text(
                'Enter the email address associated with your Sportify account and we will send you a secure reset link.',
                style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'name@club-or-company.com',
                  hintStyle: const TextStyle(color: Colors.white38),
                  errorText: errorText,
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                  filled: true,
                  fillColor: surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final v = emailCtrl.text.trim();
                    if (v.isEmpty || !v.contains('@') || !v.contains('.')) {
                      setSheetState(() => errorText = 'Please enter a valid email address');
                      return;
                    }
                    setSheetState(() {
                      errorText = null;
                      sent = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Send Reset Link', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Opens the Company FIT-Pass Code / Invitation Link redemption sheet.
Future<void> showCompanyInviteSheet(BuildContext context) {
  final codeCtrl = TextEditingController();
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
  String? errorText;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => StatefulBuilder(
      builder: (ctx, setSheetState) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 14,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 26,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 18),
            const Row(
              children: [
                Icon(Icons.business_center_rounded, color: green, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Redeem Company FIT-Pass Invite',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your employer\'s Company Code or paste your FIT-Pass invitation link to unlock corporate gym & wellness benefits.',
              style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: codeCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'e.g. WERDER-FIT-2026 or invite link',
                hintStyle: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w500),
                errorText: errorText,
                prefixIcon: const Icon(Icons.qr_code_rounded, color: green),
                filled: true,
                fillColor: surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  final raw = codeCtrl.text.trim();
                  if (raw.length < 4) {
                    setSheetState(() => errorText = 'Please enter a valid company code or invite link');
                    return;
                  }
                  Navigator.pop(sheetCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Company code "$raw" verified! Complete your registration to activate FIT-Pass.')),
                  );
                  context.go(AppRoutes.register);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & Continue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Displays the full EU GDPR (Art. 6 & Art. 17) data protection summary.
Future<void> showGdprPolicySheet(BuildContext context) {
  const card = Color(0xFF0E1822), green = AppColors.green2;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: green, size: 20),
              SizedBox(width: 8),
              Text('EU GDPR & Data Protection (v2.4)', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Lawful Processing (Art. 6 GDPR): Your football CV, match statistics, and video highlights are processed to provide talent discovery and club/scout matching.\n'
            '• FIT-Pass Check-ins: Location and QR check-in timestamps are shared only with the partner gym you visit.\n'
            '• Right to Erasure (Art. 17 GDPR): You can export your personal data or permanently delete your account at any time from Profile → Settings.',
            style: TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.5),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(sheetCtx),
              style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('I Understand', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ],
      ),
    ),
  );
}

