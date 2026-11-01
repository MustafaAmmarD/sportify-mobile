import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Mobile-first Action Gallery tab for [PlayerProfilePage].
class PlayerGalleryTab extends StatefulWidget {
  const PlayerGalleryTab({super.key, required this.post});
  final FeedPost post;

  @override
  State<PlayerGalleryTab> createState() => _PlayerGalleryTabState();
}

class _PlayerGalleryTabState extends State<PlayerGalleryTab> {
  String _selectedCategory = 'All';

  List<PlayerGalleryPhoto> _safePhotos() {
    final p = widget.post;
    final thumb = p.thumbnailUrl?.isNotEmpty == true
        ? p.thumbnailUrl!
        : 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900&q=80';
    return [
      PlayerGalleryPhoto(id: '${p.id}_g1', imageUrl: 'https://images.unsplash.com/photo-1522778119026-d647f0596c20?w=900&q=80', caption: '${p.authorName} · Floodlit Matchday at ${p.clubName}', category: 'Matchday'),
      PlayerGalleryPhoto(id: '${p.id}_g2', imageUrl: 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=900&q=80', caption: 'Set-Piece & Technical Preparation · ${p.leagueName}', category: 'Training'),
      PlayerGalleryPhoto(id: '${p.id}_g3', imageUrl: thumb, caption: '${p.authorName} (#${p.jerseyNumber} ${p.positionCode}) · Match Action', category: 'Matchday'),
      PlayerGalleryPhoto(id: '${p.id}_g4', imageUrl: 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=900&q=80', caption: '${p.clubName} Tactical Pitch Session', category: 'Training'),
      PlayerGalleryPhoto(id: '${p.id}_g5', imageUrl: 'https://images.unsplash.com/photo-1551958219-acbc608c6377?w=900&q=80', caption: 'Matchday Warm-Up · ${p.division}', category: 'Matchday'),
      PlayerGalleryPhoto(id: '${p.id}_g6', imageUrl: 'https://images.unsplash.com/photo-1518091043644-c1d4457512c6?w=900&q=80', caption: 'Stadium Atmosphere · ${p.clubCity}, ${p.clubCountry}', category: 'Stadium'),
    ];
  }

  void _openLightbox(BuildContext context, List<PlayerGalleryPhoto> photos, int initialIndex) {
    showDialog<void>(
      context: context,
      barrierColor: const Color(0xF2050A10),
      builder: (_) => _GalleryLightboxDialog(photos: photos, initialIndex: initialIndex, playerName: widget.post.authorName),
    );
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
    final allPhotos = _safePhotos();
    final categories = <String>{'All', ...allPhotos.map((p) => p.category)}.toList();
    final filtered = _selectedCategory == 'All' ? allPhotos : allPhotos.where((p) => p.category == _selectedCategory).toList();
    final displayPhotos = filtered.isNotEmpty ? filtered : allPhotos;
    final heroPhoto = displayPhotos.first;
    final gridPhotos = displayPhotos.length > 1 ? displayPhotos.sublist(1) : const <PlayerGalleryPhoto>[];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(18), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.photo_library_rounded, color: green, size: 18),
                  SizedBox(width: 8),
                  Text('Action Gallery', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(20)),
                child: Text('${displayPhotos.length} photos', style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _selectedCategory = categories[i]),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                      decoration: BoxDecoration(
                        color: categories[i] == _selectedCategory ? green : surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: categories[i] == _selectedCategory ? green : border),
                      ),
                      child: Text(
                        categories[i],
                        style: TextStyle(
                          color: categories[i] == _selectedCategory ? Colors.black : Colors.white70,
                          fontSize: 11.5,
                          fontWeight: categories[i] == _selectedCategory ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _openLightbox(context, displayPhotos, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _SafeNetworkPhoto(url: heroPhoto.imageUrl),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x44070D14), Color(0x00070D14), Color(0xE6070D14)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xD9070D14), borderRadius: BorderRadius.circular(8), border: Border.all(color: green.withValues(alpha: 0.45))),
                            child: Text(heroPhoto.category.toUpperCase(), style: const TextStyle(color: green, fontSize: 9.5, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: const Color(0xB3070D14), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Text(heroPhoto.caption, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (var i = 0; i < gridPhotos.length; i += 2) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _GalleryTile(photo: gridPhotos[i], onTap: () => _openLightbox(context, displayPhotos, i + 1))),
                const SizedBox(width: 10),
                Expanded(
                  child: i + 1 < gridPhotos.length
                      ? _GalleryTile(photo: gridPhotos[i + 1], onTap: () => _openLightbox(context, displayPhotos, i + 2))
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.photo, required this.onTap});
  final PlayerGalleryPhoto photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 1.05,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _SafeNetworkPhoto(url: photo.imageUrl),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xD9070D14)], stops: [0.45, 1.0]),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xCC070D14), borderRadius: BorderRadius.circular(6)),
                  child: Text(photo.category, style: const TextStyle(color: Colors.white70, fontSize: 9.5, fontWeight: FontWeight.w700)),
                ),
              ),
              Positioned(
                left: 9,
                right: 9,
                bottom: 8,
                child: Text(photo.caption, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SafeNetworkPhoto extends StatelessWidget {
  const _SafeNetworkPhoto({required this.url, this.fit = BoxFit.cover});
  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E);
    if (url.isEmpty) return const ColoredBox(color: surface, child: Icon(Icons.image_outlined, color: Colors.white24));
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, __, ___) => const ColoredBox(color: surface, child: Icon(Icons.sports_soccer_rounded, color: Colors.white24, size: 32)),
    );
  }
}

class _GalleryLightboxDialog extends StatefulWidget {
  const _GalleryLightboxDialog({required this.photos, required this.initialIndex, required this.playerName});
  final List<PlayerGalleryPhoto> photos;
  final int initialIndex;
  final String playerName;

  @override
  State<_GalleryLightboxDialog> createState() => _GalleryLightboxDialogState();
}

class _GalleryLightboxDialogState extends State<_GalleryLightboxDialog> {
  late int _index = widget.initialIndex.clamp(0, widget.photos.length - 1);

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    final current = widget.photos[_index];
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_index + 1} / ${widget.photos.length} · ${widget.playerName}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.5,
                child: Center(child: _SafeNetworkPhoto(url: current.imageUrl, fit: BoxFit.contain)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  IconButton(onPressed: _index > 0 ? () => setState(() => _index--) : null, icon: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 28)),
                  Expanded(
                    child: Column(
                      children: [
                        Text(current.category.toUpperCase(), style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                        const SizedBox(height: 4),
                        Text(current.caption, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: _index < widget.photos.length - 1 ? () => setState(() => _index++) : null, icon: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 28)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
