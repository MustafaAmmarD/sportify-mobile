import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/presentation/widgets/video_launcher.dart';
import 'package:sportify/features/fitpass/domain/entities/fitpass_entities.dart';

/// Reactive store for active FIT-Pass tier, check-in count, and booked slots.
class FitPassSessionStore {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);
  static String activePlanName = 'SILVER PASS';
  static int checkInsUsed = 8;
  static int checkInsQuota = 12;
  static final Set<String> completedCourseIds = {'course_1'};
  static final List<String> bookedSummaries = [
    'Today · 18:30 — Pro Football Conditioning @ Berlin Elite Gym',
  ];

  static void recordCheckIn(String? venueName) {
    if (checkInsUsed < checkInsQuota) checkInsUsed++;
    version.value++;
  }
  static void activatePlan(String planName) {
    activePlanName = '${planName.toUpperCase()} PASS';
    checkInsQuota = planName.toLowerCase().contains('gold') || planName.toLowerCase().contains('club') ? 20 : 12;
    version.value++;
  }
  static void addBooking(String summary) {
    bookedSummaries.insert(0, summary);
    version.value++;
  }
  static void toggleCourseCompleted(String id) {
    if (!completedCourseIds.remove(id)) completedCourseIds.add(id);
    version.value++;
  }
}

/// Interactive Partner Discovery Map card with tappable venue pins.
class FitPassDiscoveryMapCard extends StatefulWidget {
  const FitPassDiscoveryMapCard({super.key, required this.partners, required this.onBookPartner});
  final List<FitPassPartner> partners;
  final ValueChanged<FitPassPartner> onBookPartner;
  @override
  State<FitPassDiscoveryMapCard> createState() => _FitPassDiscoveryMapCardState();
}

class _FitPassDiscoveryMapCardState extends State<FitPassDiscoveryMapCard> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF0B1622), border = Color(0xFF1B2A38), green = AppColors.green2;
    if (widget.partners.isEmpty) return const SizedBox.shrink();
    final idx = _selectedIndex.clamp(0, widget.partners.length - 1);
    final selected = widget.partners[idx];

    return Container(
      height: 195,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        CustomPaint(size: const Size(double.infinity, 195), painter: _MapGridPainter()),
        for (var i = 0; i < widget.partners.length; i++)
          Positioned(
            left: 36.0 + (i * 78) % 240,
            top: 28.0 + (i * 42) % 85,
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: i == idx ? green : const Color(0xFF0E1822),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: green, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 8)],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.location_on_rounded, size: 13, color: i == idx ? Colors.black : green),
                  const SizedBox(width: 4),
                  Text(widget.partners[i].name.split(' ').first, style: TextStyle(color: i == idx ? Colors.black : Colors.white, fontSize: 10.5, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ),
        Positioned(
          left: 10, right: 10, bottom: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(color: const Color(0xFF0E1822).withValues(alpha: 0.95), borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(selected.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                  Text('${selected.type} · ${selected.distanceKm.toStringAsFixed(1)} km · ★ ${selected.rating.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ]),
              ),
              ElevatedButton(
                onPressed: () => widget.onBookPartner(selected),
                style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), minimumSize: Size.zero),
                child: const Text('Book Slot', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()..color = Colors.white.withValues(alpha: 0.04)..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final road = Paint()..color = AppColors.green2.withValues(alpha: 0.08)..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path()..moveTo(0, size.height * 0.65)..quadraticBezierTo(size.width * 0.45, size.height * 0.2, size.width, size.height * 0.55);
    canvas.drawPath(path, road);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Opens the Booking Calendar & Slot Reservation modal bottom sheet.
Future<void> showFitPassBookingSheet(BuildContext context, FitPassPartner partner) {
  const days = ['Today', 'Tomorrow', 'Wed 04', 'Thu 05', 'Fri 06'];
  const slots = ['09:00', '11:30', '15:00', '18:30', '20:00'];
  const sessions = ['Open Gym & Weights', 'Pro Football Conditioning', 'Cryo & Recovery Spa'];
  var selDay = 0, selSlot = 3, selSession = 1;
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: card,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => StatefulBuilder(
      builder: (ctx, setSheet) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 16),
          Text('Book Session · ${partner.name}', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('${partner.address} (${partner.distanceKm.toStringAsFixed(1)} km)', style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 16),
          const Text('Select Day', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setSheet(() => selDay = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: i == selDay ? green : surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: i == selDay ? green : border)),
                  child: Text(days[i], style: TextStyle(color: i == selDay ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Session Type', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (var i = 0; i < sessions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => setSheet(() => selSession = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: i == selSession ? green.withValues(alpha: 0.14) : surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: i == selSession ? green : border)),
                  child: Row(children: [
                    Icon(i == selSession ? Icons.radio_button_checked : Icons.radio_button_off, color: i == selSession ? green : Colors.white38, size: 18),
                    const SizedBox(width: 10),
                    Text(sessions[i], style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            ),
          const SizedBox(height: 10),
          const Text('Available Time Slots', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(slots.length, (i) => GestureDetector(
              onTap: () => setSheet(() => selSlot = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: i == selSlot ? green : surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: i == selSlot ? green : border)),
                child: Text(slots[i], style: TextStyle(color: i == selSlot ? Colors.black : Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800)),
              ),
            )),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 46,
            child: ElevatedButton.icon(
              onPressed: () {
                final summary = '${days[selDay]} · ${slots[selSlot]} — ${sessions[selSession]} @ ${partner.name}';
                FitPassSessionStore.addBooking(summary);
                Navigator.pop(sheetCtx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Confirmed: $summary')));
              },
              icon: const Icon(Icons.event_available_rounded, size: 18),
              label: const Text('Confirm FIT-Pass Booking', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ]),
      ),
    ),
  );
}

/// Digital Training & Online Courses tab view inside [FitPassPage].
class FitPassDigitalTrainingTab extends StatelessWidget {
  const FitPassDigitalTrainingTab({super.key});

  static const _courses = [
    ('course_1', 'Explosive Sprint & First-Step Mechanics', 'Coach Lukas Meyer · 24 mins', 'Speed & Agility', 'https://www.youtube.com/watch?v=ePpPVE-GGJw'),
    ('course_2', 'ACL Injury Prevention & Hip Mobility', 'Dr. Hannah Klein · 18 mins', 'Physio & Recovery', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    ('course_3', '90-Minute High-Press Conditioning', 'Sportify Pro Lab · 32 mins', 'Endurance', 'https://www.youtube.com/watch?v=ePpPVE-GGJw'),
    ('course_4', 'Post-Match Cryo & Foam Roll Protocol', 'Coach Karim Zidan · 15 mins', 'Wellness', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
  ];

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), border = Color(0xFF1B2A38), green = AppColors.green2;
    return ValueListenableBuilder<int>(
      valueListenable: FitPassSessionStore.version,
      builder: (context, _, __) => ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          if (FitPassSessionStore.bookedSummaries.isNotEmpty) ...[
            const Text('Upcoming Bookings', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            for (final b in FitPassSessionStore.bookedSummaries.take(2))
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: green.withValues(alpha: 0.35))),
                child: Row(children: [
                  const Icon(Icons.calendar_today_rounded, color: green, size: 15),
                  const SizedBox(width: 8),
                  Expanded(child: Text(b, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                ]),
              ),
            const SizedBox(height: 12),
          ],
          const Text('Online Training & Pro Courses', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          for (final c in _courses)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
              child: Row(children: [
                GestureDetector(
                  onTap: () => openVideoUrl(context, c.$5),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(12), border: Border.all(color: green.withValues(alpha: 0.4))),
                    child: const Icon(Icons.play_arrow_rounded, color: green, size: 28),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c.$4.toUpperCase(), style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 2),
                    Text(c.$2, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(c.$3, style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
                  ]),
                ),
                IconButton(
                  onPressed: () => FitPassSessionStore.toggleCourseCompleted(c.$1),
                  icon: Icon(
                    FitPassSessionStore.completedCourseIds.contains(c.$1) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: FitPassSessionStore.completedCourseIds.contains(c.$1) ? green : Colors.white38,
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

