import 'package:flutter/material.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/auth/domain/repositories/auth_repository.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

/// Opens the modal sheet to publish a new Player Highlight or FIT-Pass clip.
Future<void> showFeedUploadSheet(
  BuildContext context, {
  required ValueChanged<FeedPost> onPostCreated,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF0E1822),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _FeedUploadForm(onPostCreated: onPostCreated),
  );
}

class _FeedUploadForm extends StatefulWidget {
  const _FeedUploadForm({required this.onPostCreated});
  final ValueChanged<FeedPost> onPostCreated;

  @override
  State<_FeedUploadForm> createState() => _FeedUploadFormState();
}

class _FeedUploadFormState extends State<_FeedUploadForm> {
  static const List<String> _positions = ['ST', 'LW', 'RW', 'CAM', 'CM', 'CDM', 'CB', 'RB', 'GK'];
  static const Map<String, String> _posFullMap = {
    'ST': 'Striker',
    'LW': 'Left Winger',
    'RW': 'Right Winger',
    'CAM': 'Attacking Midfielder',
    'CM': 'Central Midfielder',
    'CDM': 'Defensive Midfielder',
    'CB': 'Center Back',
    'RB': 'Right Back',
    'GK': 'Goalkeeper',
  };

  final _titleCtrl = TextEditingController();
  final _clubCtrl = TextEditingController(text: 'SV Werder Bremen');
  final _videoUrlCtrl = TextEditingController(text: 'https://www.youtube.com/watch?v=ePpPVE-GGJw');
  final _tagsCtrl = TextEditingController(text: '#MatchHighlight #Scouting #TopBins');
  String _selectedPos = 'CAM';
  String _clipType = 'Match Highlight';

  @override
  void dispose() {
    _titleCtrl.dispose();
    _clubCtrl.dispose();
    _videoUrlCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final user = sl<AuthRepository>().currentUser;
    final authorName = user?.firstName.isNotEmpty == true
        ? '${user!.firstName} ${user.lastName}'.trim()
        : 'Mustafa Ammar';
    final tags = _tagsCtrl.text
        .split(RegExp(r'[\s,]+'))
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.startsWith('#') ? s : '#$s')
        .toList();

    final newPost = FeedPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: user?.id ?? 'local_user',
      authorName: authorName,
      videoUrl: _videoUrlCtrl.text.trim().isNotEmpty
          ? _videoUrlCtrl.text.trim()
          : 'https://www.youtube.com/watch?v=ePpPVE-GGJw',
      description: _titleCtrl.text.trim().isNotEmpty
          ? _titleCtrl.text.trim()
          : '$_clipType · $authorName (${_clubCtrl.text.trim()})',
      positionCode: _selectedPos,
      positionFull: _posFullMap[_selectedPos] ?? 'Midfielder',
      clubName: _clubCtrl.text.trim().isNotEmpty ? _clubCtrl.text.trim() : 'Sportify FC',
      clubCity: 'Bremen',
      leagueName: 'Bundesliga',
      clubCountry: 'Germany',
      competitionLevel: _clipType == 'FIT-Pass Workout' ? 'FIT-Pass Pro' : 'First Team',
      marketValue: '€4.5M',
      fitScore: 95,
      aiRating: 94,
      goals: 11,
      assists: 7,
      appearances: 18,
      minutesPlayed: 1420,
      hashtags: tags,
      likesCount: 1,
      commentsCount: 0,
      createdAt: DateTime.now(),
    );

    widget.onPostCreated(newPost);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Highlight published to the Sportify feed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.video_call_rounded, color: green, size: 22),
                SizedBox(width: 8),
                Text(
                  'Publish Highlight or Workout',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: ['Match Highlight', 'FIT-Pass Workout'].map((type) {
                final active = _clipType == type;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: type == 'Match Highlight' ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _clipType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: active ? green.withValues(alpha: 0.16) : surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: active ? green : border),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: active ? green : Colors.white70,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _Field(controller: _titleCtrl, label: 'Highlight Title / Caption', hint: 'e.g. Match-winning goal & key passes vs Dortmund'),
            const SizedBox(height: 10),
            _Field(controller: _clubCtrl, label: 'Club / Academy / Gym', hint: 'SV Werder Bremen'),
            const SizedBox(height: 10),
            _Field(controller: _videoUrlCtrl, label: 'Video URL (YouTube, Vimeo, TikTok)', hint: 'https://www.youtube.com/watch?v=...'),
            const SizedBox(height: 10),
            _Field(controller: _tagsCtrl, label: 'Skill Tags & Hashtags', hint: '#Speed #Vision #Bundesliga'),
            const SizedBox(height: 12),
            const Text('Position', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _positions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (_, i) {
                  final pos = _positions[i];
                  final sel = pos == _selectedPos;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPos = pos),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? green : surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: sel ? green : border),
                      ),
                      child: Text(
                        pos,
                        style: TextStyle(color: sel ? Colors.black : Colors.white70, fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                label: const Text('Publish to Feed', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: const Color(0xFF050A12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.label, required this.hint});
  final TextEditingController controller;
  final String label, hint;

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF13202E), border = Color(0xFF1B2A38);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 12.5),
            filled: true,
            fillColor: surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: border)),
          ),
        ),
      ],
    );
  }
}

