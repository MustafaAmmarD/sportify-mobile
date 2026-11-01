import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';
import 'package:sportify/features/feed/presentation/widgets/video_launcher.dart';

/// Mobile-first Highlights tab for [PlayerProfilePage].
class PlayerHighlightsTab extends StatefulWidget {
  const PlayerHighlightsTab({super.key, required this.post});
  final FeedPost post;

  @override
  State<PlayerHighlightsTab> createState() => _PlayerHighlightsTabState();
}

class _PlayerHighlightsTabState extends State<PlayerHighlightsTab> {
  int _selectedClipIndex = 0;

  Future<void> _playClip(BuildContext context, PlayerHighlightClip clip) =>
      openVideoUrl(context, clip.videoUrl.isNotEmpty ? clip.videoUrl : widget.post.videoUrl);

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
    final clips = widget.post.resolvedHighlights;
    final safeIndex = _selectedClipIndex.clamp(0, clips.length - 1);
    final activeClip = clips[safeIndex];
    final cardDeco = BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Featured Mobile Video Stage Card ──
        Container(
          decoration: cardDeco,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _playClip(context, activeClip),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: activeClip.resolvedThumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const ColoredBox(color: surface),
                        errorWidget: (_, __, ___) => const ColoredBox(
                          color: surface,
                          child: Icon(Icons.videocam_rounded, color: Colors.white24, size: 42),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x66070D14), Color(0x22070D14), Color(0xE6070D14)],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xD9070D14),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: green.withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.bolt_rounded, color: green, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    activeClip.category.toUpperCase(),
                                    style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xD9070D14),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Text(activeClip.duration, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: green,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: green.withValues(alpha: 0.45), blurRadius: 20, spreadRadius: 2)],
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 36),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 10,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(6)),
                              child: Text('Season ${activeClip.season}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 8),
                            Text(activeClip.viewsLabel, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activeClip.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, height: 1.3)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _MetaTag(label: '${widget.post.positionCode} #${widget.post.jerseyNumber}'),
                        _MetaTag(label: widget.post.clubName),
                        _MetaTag(label: '${widget.post.fitScore} FIT', highlight: true),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () => _playClip(context, activeClip),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                        ),
                        icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                        label: const Text('Watch Scouting Reel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 2. Dynamic Scouting Reels Playlist ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardDeco,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Scouting Reels', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  Text('${clips.length} clips', style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(clips.length, (i) {
                final clip = clips[i];
                final isSelected = i == safeIndex;
                return Padding(
                  padding: EdgeInsets.only(bottom: i == clips.length - 1 ? 0 : 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedClipIndex = i);
                      _playClip(context, clip);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? green.withValues(alpha: 0.1) : surface,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: isSelected ? green.withValues(alpha: 0.5) : border),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: SizedBox(
                              width: 88,
                              height: 54,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(imageUrl: clip.resolvedThumbnailUrl, fit: BoxFit.cover),
                                  const ColoredBox(color: Color(0x55000000)),
                                  Center(
                                    child: Icon(
                                      isSelected ? Icons.equalizer_rounded : Icons.play_arrow_rounded,
                                      color: isSelected ? green : Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clip.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.25),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${clip.category} · ${clip.duration} · ${clip.season}',
                                  style: TextStyle(color: isSelected ? green : Colors.white54, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.label, this.highlight = false});
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? green.withValues(alpha: 0.14) : const Color(0xFF13202E),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: highlight ? green.withValues(alpha: 0.45) : const Color(0xFF1B2A38)),
      ),
      child: Text(label, style: TextStyle(color: highlight ? green : Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
