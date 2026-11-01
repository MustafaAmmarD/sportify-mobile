import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_booking_and_training.dart';

/// Wallet-style digital FIT-Pass card with active tier status and QR check-in.
class FitPassDigitalCard extends StatelessWidget {
  const FitPassDigitalCard({
    super.key,
    required this.onScanQr,
  });

  final VoidCallback onScanQr;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;

    return ValueListenableBuilder<int>(
      valueListenable: FitPassSessionStore.version,
      builder: (context, _, __) {
        final used = FitPassSessionStore.checkInsUsed;
        final quota = FitPassSessionStore.checkInsQuota;
        final plan = FitPassSessionStore.activePlanName;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0E291D), Color(0xFF0B1622)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: green.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: green.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: green.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: green, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          '$plan · ACTIVE',
                          style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text('ID #SP-8492', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('All-Access Fitness & Club Pass', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text('$used of $quota monthly check-ins used · Renews Nov 28', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onScanQr,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.qr_code_scanner_rounded, color: Colors.black, size: 18),
                          SizedBox(width: 6),
                          Text('Check In', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (used / quota).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation(green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Modal bottom sheet displaying the user's digital QR check-in pass.
class FitPassQrSheet extends StatelessWidget {
  const FitPassQrSheet({super.key, this.venueName});

  final String? venueName;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    const border = Color(0xFF1B2A38);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              venueName != null ? 'Check in at $venueName' : 'FIT-Pass Digital QR',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Scan this pass at the partner reception desk',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              width: 190,
              height: 190,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: green, width: 3),
              ),
              child: const FittedBox(
                child: Icon(
                  Icons.qr_code_2_rounded,
                  color: Color(0xFF070D14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF070D14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: border),
              ),
              child: const Text(
                'PASS CODE: SP-8492-BER',
                style: TextStyle(
                  color: green,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FitPassSessionStore.recordCheckIn(venueName);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        venueName != null
                            ? 'Checked in at $venueName! Enjoy your session.'
                            : 'QR Pass verified! Check-in recorded.',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Confirm Check-In',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

