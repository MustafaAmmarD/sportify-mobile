import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/presentation/pages/player_profile_page.dart';
import 'package:sportify/features/news/domain/entities/news_entities.dart';

/// Navigates to [PlayerProfilePage] for a player mentioned in news or transfers.
void openLinkedPlayerProfile(
  BuildContext context, {
  required String playerName,
  required String clubName,
  String positionCode = 'CAM',
  String positionFull = 'Attacking Midfielder',
  String marketValue = '€7.0M',
}) {
  final post = FeedPost(
    id: 'linked_${playerName.hashCode.abs()}',
    authorId: 'player_${playerName.hashCode.abs()}',
    authorName: playerName,
    videoUrl: 'https://www.youtube.com/watch?v=ePpPVE-GGJw',
    description: '$playerName · Official Scouting Reel ($clubName)',
    positionCode: positionCode,
    positionFull: positionFull,
    clubName: clubName,
    clubCity: 'Bremen',
    leagueName: 'Bundesliga',
    clubCountry: 'Germany',
    competitionLevel: 'First Team',
    marketValue: marketValue,
    fitScore: 96,
    aiRating: 95,
    goals: 13,
    assists: 8,
    appearances: 20,
    minutesPlayed: 1560,
    createdAt: DateTime.now(),
  );
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => PlayerProfilePage(post: post)),
  );
}

/// Opens the full News Article Reader sheet with linked Player/Club profile CTA.
Future<void> showNewsArticleReaderSheet(BuildContext context, NewsItem item) {
  const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: card,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetCtx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => ListView(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: green.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(6)),
                child: Text(item.category.toUpperCase(), style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 10),
              Text('${item.source} · ${item.publishedAt.toString().substring(0, 10)}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900, height: 1.25)),
          const SizedBox(height: 14),
          if (item.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                item.imageUrl!,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            '${item.summary}\n\n'
            'Sportify Intelligence Analysis: Scouts across Europe have closely monitored this development. '
            'Data metrics show a +18% surge in recruitment interest over the last 14 matchdays, with tactical fit scores exceeding 94/100 for high-pressing systems.',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: border)),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: green.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.person_search_rounded, color: green, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Featured Scouting Profile', style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800)),
                      Text('Finn Larsen · SV Werder Bremen', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    openLinkedPlayerProfile(context, playerName: 'Finn Larsen', clubName: 'SV Werder Bremen');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MatchFixture {
  const _MatchFixture({
    required this.league,
    required this.homeClub,
    required this.awayClub,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.mvpName,
    required this.mvpRating,
  });

  final String league, homeClub, awayClub, status, mvpName, mvpRating;
  final int homeScore, awayScore;
}

/// Kooora-style Match Results & Live Scores tab inside [NewsHubPage].
class MatchesTabView extends StatefulWidget {
  const MatchesTabView({super.key});

  @override
  State<MatchesTabView> createState() => _MatchesTabViewState();
}

class _MatchesTabViewState extends State<MatchesTabView> {
  static const _leagues = ['All', 'Bundesliga', 'Premier League', 'La Liga', 'UCL'];
  static const _fixtures = [
    _MatchFixture(league: 'Bundesliga', homeClub: 'SV Werder Bremen', awayClub: 'Borussia Dortmund', homeScore: 2, awayScore: 1, status: "LIVE 82'", mvpName: 'Finn Larsen', mvpRating: '9.2'),
    _MatchFixture(league: 'Bundesliga', homeClub: 'RB Leipzig', awayClub: 'Bayer Leverkusen', homeScore: 2, awayScore: 2, status: 'FT', mvpName: 'Xavi Simons', mvpRating: '8.8'),
    _MatchFixture(league: 'Premier League', homeClub: 'Arsenal FC', awayClub: 'Chelsea FC', homeScore: 3, awayScore: 1, status: 'FT', mvpName: 'Bukayo Saka', mvpRating: '9.0'),
    _MatchFixture(league: 'La Liga', homeClub: 'Real Madrid', awayClub: 'FC Barcelona', homeScore: 2, awayScore: 1, status: 'FT', mvpName: 'Jude Bellingham', mvpRating: '9.1'),
    _MatchFixture(league: 'UCL', homeClub: 'Bayern Munich', awayClub: 'Paris Saint-Germain', homeScore: 1, awayScore: 0, status: 'FT', mvpName: 'Jamal Musiala', mvpRating: '8.9'),
  ];

  String _selectedLeague = 'All';

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), surface = Color(0xFF13202E), border = Color(0xFF1B2A38), green = AppColors.green2;
    final list = _selectedLeague == 'All' ? _fixtures : _fixtures.where((m) => m.league == _selectedLeague).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _leagues.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final l = _leagues[i];
              final sel = l == _selectedLeague;
              return GestureDetector(
                onTap: () => setState(() => _selectedLeague = l),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: sel ? green.withValues(alpha: 0.15) : card, borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? green : border)),
                  child: Text(l, style: TextStyle(color: sel ? green : Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        for (final m in list)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m.league.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: m.status.startsWith('LIVE') ? green.withValues(alpha: 0.16) : surface, borderRadius: BorderRadius.circular(6)),
                      child: Text(m.status, style: TextStyle(color: m.status.startsWith('LIVE') ? green : Colors.white70, fontSize: 10.5, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text(m.homeClub, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800))),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: border)),
                      child: Text('${m.homeScore}  -  ${m.awayScore}', style: const TextStyle(color: green, fontSize: 15, fontWeight: FontWeight.w900)),
                    ),
                    Expanded(child: Text(m.awayClub, style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w800))),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => openLinkedPlayerProfile(context, playerName: mvpNameOf(m), clubName: m.homeClub),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFACC15), size: 15),
                        const SizedBox(width: 6),
                        Expanded(child: Text('MOTM: ${m.mvpName} (${m.mvpRating} rating)', style: const TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w700))),
                        const Text('Scout Profile →', style: TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String mvpNameOf(_MatchFixture m) => m.mvpName;
}

