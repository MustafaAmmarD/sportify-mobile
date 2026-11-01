import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/chat/presentation/pages/chat_page.dart';

/// Represents a professional connection or incoming request on Sportify.
class NetworkPerson {
  const NetworkPerson({
    required this.id,
    required this.name,
    required this.role,
    required this.organization,
    required this.initials,
  });

  final String id, name, role, organization, initials;
}

/// In-memory reactive store for connection requests and active network.
class ProfileNetworkStore {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static final List<NetworkPerson> pendingRequests = [
    const NetworkPerson(
      id: 'req_1',
      name: 'Henrik Lindqvist',
      role: 'Chief Scout',
      organization: 'RB Leipzig',
      initials: 'HL',
    ),
    const NetworkPerson(
      id: 'req_2',
      name: 'Nadia Al-Mansoor',
      role: 'FIFA Licensed Agent',
      organization: 'Elite Talent Sports',
      initials: 'NA',
    ),
  ];

  static final List<NetworkPerson> connections = [
    const NetworkPerson(
      id: 'con_1',
      name: 'Clemens Fritz',
      role: 'Sporting Director',
      organization: 'SV Werder Bremen',
      initials: 'CF',
    ),
    const NetworkPerson(
      id: 'con_2',
      name: 'Lukas Meyer',
      role: 'Head Performance Coach',
      organization: 'Sportify Pro Lab',
      initials: 'LM',
    ),
  ];

  static void accept(NetworkPerson person) {
    pendingRequests.removeWhere((p) => p.id == person.id);
    connections.insert(0, person);
    version.value++;
  }

  static void decline(NetworkPerson person) {
    pendingRequests.removeWhere((p) => p.id == person.id);
    version.value++;
  }
}

/// Opens the My Network & Connection Requests bottom sheet.
Future<void> showProfileNetworkSheet(BuildContext context) {
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => ValueListenableBuilder<int>(
      valueListenable: ProfileNetworkStore.version,
      builder: (ctx, _, __) {
        final pending = ProfileNetworkStore.pendingRequests;
        final active = ProfileNetworkStore.connections;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Scouting Network', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                    child: Text('${active.length} Connected', style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (pending.isNotEmpty) ...[
                Text('Pending Invitations (${pending.length})', style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                for (final req in pending)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
                    child: Row(
                      children: [
                        _AvatarCircle(initials: req.initials, color: const Color(0xFF38BDF8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(req.name, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
                              Text('${req.role} · ${req.organization}', style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => ProfileNetworkStore.decline(req),
                          icon: const Icon(Icons.close_rounded, color: Colors.white54, size: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ProfileNetworkStore.accept(req);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Connected with ${req.name} (${req.organization})!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Accept', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
              ],
              const Text('Active Connections', style: TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              for (final con in active)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
                  child: Row(
                    children: [
                      _AvatarCircle(initials: con.initials, color: green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(con.name, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
                            Text('${con.role} · ${con.organization}', style: const TextStyle(color: Colors.white54, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(sheetCtx);
                          Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ChatPage()));
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: green),
                        label: const Text('Message', style: TextStyle(color: green, fontSize: 11.5, fontWeight: FontWeight.w800)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: green.withValues(alpha: 0.4)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.initials, required this.color});
  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(initials, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
    );
  }
}

