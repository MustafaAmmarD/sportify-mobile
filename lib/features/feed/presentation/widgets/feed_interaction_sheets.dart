import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

/// A single comment item on a player highlight post.
class FeedCommentItem {
  const FeedCommentItem({required this.authorName, required this.roleBadge, required this.text, required this.timeAgo});
  final String authorName, roleBadge, text, timeAgo;
}

/// Reactive in-memory store for likes, shortlist bookmarks, and comments.
/// Keeps [FeedPost] instance fields untouched for Hot-Reload safety.
class FeedInteractionStore {
  static final Set<String> _likedIds = <String>{};
  static final Set<String> _shortlistedIds = <String>{};
  static final Map<String, List<FeedCommentItem>> _commentsByPost = {};

  static bool isLiked(String postId) => _likedIds.contains(postId);
  static bool isShortlisted(String postId) => _shortlistedIds.contains(postId);

  static bool toggleLike(String postId) => _likedIds.remove(postId) ? false : (_likedIds.add(postId) || true);
  static bool toggleShortlist(String postId) => _shortlistedIds.remove(postId) ? false : (_shortlistedIds.add(postId) || true);

  static List<FeedCommentItem> commentsFor(FeedPost post) {
    return _commentsByPost.putIfAbsent(post.id, () => [
      FeedCommentItem(authorName: 'Marcus Weber', roleBadge: 'Verified Scout', text: 'Impressive first touch and spatial awareness in tight zones for ${post.clubName}.', timeAgo: '2h ago'),
      FeedCommentItem(authorName: 'Elena Rostova', roleBadge: 'Licensed Agent', text: 'Strong ${post.positionCode} profile (${post.fitScore} fit score). Keeping on our summer radar.', timeAgo: '5h ago'),
    ]);
  }

  static void addComment(FeedPost post, String text, {String author = 'You', String role = 'Pro Member'}) {
    commentsFor(post).insert(0, FeedCommentItem(authorName: author, roleBadge: role, text: text, timeAgo: 'Just now'));
  }
}

/// Interactive social & scouting bar (Hashtags, Like, Comment, Shortlist, Share/Report).
class FeedSocialActionBar extends StatefulWidget {
  const FeedSocialActionBar({super.key, required this.post, this.onTagTap});
  final FeedPost post;
  final ValueChanged<String>? onTagTap;

  @override
  State<FeedSocialActionBar> createState() => _FeedSocialActionBarState();
}

class _FeedSocialActionBarState extends State<FeedSocialActionBar> {
  @override
  Widget build(BuildContext context) {
    const surfaceBg = Color(0xFF111E2C), border = Color(0xFF1B2A38), green = AppColors.green2;
    final p = widget.post;
    final liked = FeedInteractionStore.isLiked(p.id);
    final shortlisted = FeedInteractionStore.isShortlisted(p.id);
    final likesCount = p.likesCount + (liked ? 1 : 0);
    final commentsCount = p.commentsCount + FeedInteractionStore.commentsFor(p).length;
    final tags = p.hashtags.isNotEmpty ? p.hashtags : [...p.traits.map((t) => '#${t.replaceAll(' ', '')}'), '#${p.positionCode}'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.take(4).map((tag) {
              final formatted = tag.startsWith('#') ? tag : '#$tag';
              return GestureDetector(
                onTap: () => widget.onTagTap?.call(formatted.replaceFirst('#', '')),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(color: green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: green.withValues(alpha: 0.28))),
                  child: Text(formatted, style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            _ActionPill(
              icon: liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              label: '$likesCount',
              active: liked,
              activeColor: const Color(0xFFF43F5E),
              onTap: () => setState(() => FeedInteractionStore.toggleLike(p.id)),
            ),
            const SizedBox(width: 8),
            _ActionPill(
              icon: Icons.chat_bubble_outline_rounded,
              label: '$commentsCount',
              onTap: () async {
                await showFeedCommentsSheet(context, p);
                if (mounted) setState(() {});
              },
            ),
            const SizedBox(width: 8),
            _ActionPill(
              icon: shortlisted ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              label: shortlisted ? 'Saved' : 'Shortlist',
              active: shortlisted,
              activeColor: green,
              onTap: () {
                final added = FeedInteractionStore.toggleShortlist(p.id);
                setState(() {});
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(added ? '${p.authorName} added to your scouting shortlist' : 'Removed from shortlist'), duration: const Duration(seconds: 2)));
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => showFeedMoreOptionsSheet(context, p),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: surfaceBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
                child: const Icon(Icons.ios_share_rounded, color: Colors.white70, size: 17),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionPill extends StatelessWidget {
  const _ActionPill({required this.icon, required this.label, required this.onTap, this.active = false, this.activeColor = AppColors.green2});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: active ? activeColor.withValues(alpha: 0.14) : const Color(0xFF111E2C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? activeColor.withValues(alpha: 0.45) : const Color(0xFF1B2A38)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: active ? activeColor : Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: active ? activeColor : Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}

/// Opens the interactive Scouting Comments bottom sheet for [post].
Future<void> showFeedCommentsSheet(BuildContext context, FeedPost post) {
  final controller = TextEditingController();
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => StatefulBuilder(
      builder: (ctx, setSheetState) {
        final comments = FeedInteractionStore.commentsFor(post);
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 14, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
              const SizedBox(height: 14),
              Text('Scouting Notes & Comments (${comments.length})', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final c = comments[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(c.authorName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(6)),
                            child: Text(c.roleBadge, style: const TextStyle(color: green, fontSize: 9.5, fontWeight: FontWeight.w800)),
                          ),
                          const Spacer(),
                          Text(c.timeAgo, style: const TextStyle(color: Colors.white38, fontSize: 10.5)),
                        ]),
                        const SizedBox(height: 6),
                        Text(c.text, style: const TextStyle(color: Colors.white70, fontSize: 12.5, height: 1.35)),
                      ]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 13.5),
                    decoration: InputDecoration(
                      hintText: 'Add a scouting note for ${post.authorName}...',
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                      filled: true, fillColor: surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  onPressed: () {
                    final txt = controller.text.trim();
                    if (txt.isEmpty) return;
                    FeedInteractionStore.addComment(post, txt);
                    controller.clear();
                    setSheetState(() {});
                  },
                ),
              ]),
            ],
          ),
        );
      },
    ),
  );
}

/// Share & UGC Moderation (Report / Block) bottom sheet.
void showFeedMoreOptionsSheet(BuildContext context, FeedPost post) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF0E1822),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.link_rounded, color: AppColors.green2),
            title: const Text('Copy Player Scouting Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            onTap: () {
              Clipboard.setData(ClipboardData(text: 'https://sportifyplus.de/players/${post.id}'));
              Navigator.pop(sheetCtx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scouting profile link copied to clipboard')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined, color: Color(0xFFFACC15)),
            title: const Text('Report Highlight or Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            onTap: () {
              Navigator.pop(sheetCtx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you. Our moderation team will review this content within 24h.')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_rounded, color: Color(0xFFF43F5E)),
            title: Text('Block ${post.authorName}', style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.w700)),
            onTap: () {
              Navigator.pop(sheetCtx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${post.authorName} has been blocked.')));
            },
          ),
        ]),
      ),
    ),
  );
}
