import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/presentation/widgets/video_launcher.dart';

/// Card displaying YouTube, Vimeo, TikTok, and Facebook highlight video links.
class ProfileVideoCard extends StatelessWidget {
  const ProfileVideoCard({
    super.key,
    required this.links,
    required this.l10n,
  });

  final List<String> links;
  final AppLocalizations l10n;

  String? _ytId(String url) {
    final r = RegExp(
      r'(?:youtube\.com\/(?:watch\?v=|shorts\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    );
    return r.firstMatch(url)?.group(1);
  }

  String _platformLabel(String url) {
    final u = url.toLowerCase();
    if (u.contains('vimeo')) return 'Vimeo Scouting Reel';
    if (u.contains('tiktok')) return 'TikTok Highlight Clip';
    if (u.contains('facebook') || u.contains('fb.watch')) return 'Facebook Shorts';
    return 'YouTube Highlight Reel';
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.profileVideoLinks,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...links.map((link) {
            final id = _ytId(link);
            return GestureDetector(
              onTap: () => openVideoUrl(context, link),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 68,
                      color: const Color(0xFF0A131C),
                      child: id != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://img.youtube.com/vi/$id/mqdefault.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white24,
                                    size: 30,
                                  ),
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white70,
                                    size: 30,
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: green,
                                size: 28,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _platformLabel(link),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              link,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.open_in_new, color: green, size: 16),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
