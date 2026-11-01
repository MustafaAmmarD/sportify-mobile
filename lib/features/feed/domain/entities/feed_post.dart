import 'package:equatable/equatable.dart';
import 'package:sportify/features/feed/domain/entities/player_scouting_profile.dart';

/// Dynamic domain entity representing a player highlight card and scouting profile.
class FeedPost extends Equatable {
  const FeedPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.videoUrl,
    this.thumbnailUrl,
    this.description,
    this.positionCode = 'CM',
    this.positionFull = 'Central Midfielder',
    this.jerseyNumber = 10,
    this.fitScore = 88,
    this.aiRating = 90,
    this.age = 20,
    this.nationality = 'Germany',
    this.countryCode = 'DE',
    this.countryFlag = '🇩🇪',
    this.availabilityStatus = 'Available',
    this.clubName = 'Free Agent',
    this.clubLogoUrl,
    this.clubCity = '',
    this.leagueName = '',
    this.clubCountry = 'Germany',
    this.competitionLevel = 'Professional',
    this.division = '1st division',
    this.marketValue = '€2.5M',
    this.preferredFoot = 'Right',
    this.heightCm = 182,
    this.languages = const ['English'],
    this.goals = 0,
    this.assists = 0,
    this.appearances = 0,
    this.minutesPlayed = 0,
    this.bio = '',
    this.traits = const [],
    this.radarStats = const PlayerRadarStats(),
    this.transferWishes = const [],
    this.marketValueHistory = const [],
    this.highlights = const [],
    this.hashtags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic raw, [List<String> fb = const []]) =>
        raw is List ? raw.map((e) => e.toString()).toList() : fb;

    final rawWishes = json['transferWishes'] ?? json['transfer_wishes'];
    final wishes = rawWishes is List
        ? rawWishes.whereType<Map<String, dynamic>>().map(TransferWishClub.fromJson).toList()
        : const <TransferWishClub>[];

    final rawHistory = json['marketValueHistory'] ?? json['market_value_history'];
    final history = rawHistory is List
        ? rawHistory.whereType<Map<String, dynamic>>().map(MarketValuePoint.fromJson).toList()
        : const <MarketValuePoint>[];

    final rawHighlights = json['highlights'] ?? json['highlightClips'] ?? json['highlight_clips'];
    final clips = rawHighlights is List
        ? rawHighlights.whereType<Map<String, dynamic>>().map(PlayerHighlightClip.fromJson).toList()
        : const <PlayerHighlightClip>[];

    final rawRadar = json['radarStats'] ?? json['radar_stats'];
    final radar = rawRadar is Map<String, dynamic>
        ? PlayerRadarStats.fromJson(rawRadar)
        : const PlayerRadarStats();

    final name = (json['authorName'] ?? json['author_name'] ?? json['playerName'] ?? '').toString();
    final club = (json['clubName'] ?? json['club_name'] ?? 'Free Agent').toString();
    final city = (json['clubCity'] ?? json['club_city'] ?? '').toString();
    final foot = (json['preferredFoot'] ?? json['preferred_foot'] ?? 'Right').toString();
    final posFull = (json['positionFull'] ?? json['position_full'] ?? 'Midfielder').toString();
    final langs = parseList(json['languages'], const ['English']);

    final defaultBio =
        '$name is a ${foot.toLowerCase()}-footed ${posFull.toLowerCase()} '
        'at $club${city.isNotEmpty ? ' ($city)' : ''}. '
        'Speaks ${langs.join(', ')}. Tracked by Sportify\'s AI scouting '
        'network with strong potential and clear ambitions at club level.';

    return FeedPost(
      id: (json['id'] ?? '').toString(),
      authorId: (json['authorId'] ?? json['author_id'] ?? json['playerId'] ?? '').toString(),
      authorName: name,
      authorAvatar: (json['authorAvatar'] ?? json['author_avatar']) as String?,
      videoUrl: (json['videoUrl'] ?? json['video_url'] ?? '').toString(),
      thumbnailUrl: (json['thumbnailUrl'] ?? json['thumbnail_url']) as String?,
      description: json['description'] as String?,
      positionCode: (json['positionCode'] ?? json['position_code'] ?? json['position'] ?? 'CM').toString(),
      positionFull: posFull,
      jerseyNumber: ((json['jerseyNumber'] ?? json['jersey_number'] ?? 10) as num).toInt(),
      fitScore: ((json['fitScore'] ?? json['fit_score'] ?? 88) as num).toInt(),
      aiRating: ((json['aiRating'] ?? json['ai_rating'] ?? 92) as num).toInt(),
      age: ((json['age'] ?? 20) as num).toInt(),
      nationality: (json['nationality'] ?? 'Germany').toString(),
      countryCode: (json['countryCode'] ?? json['country_code'] ?? 'DE').toString(),
      countryFlag: (json['countryFlag'] ?? json['country_flag'] ?? '🏳️').toString(),
      availabilityStatus: (json['availabilityStatus'] ?? json['availability_status'] ?? 'Available').toString(),
      clubName: club,
      clubLogoUrl: (json['clubLogoUrl'] ?? json['club_logo_url']) as String?,
      clubCity: city,
      leagueName: (json['leagueName'] ?? json['league_name'] ?? '').toString(),
      clubCountry: (json['clubCountry'] ?? json['club_country'] ?? '').toString(),
      competitionLevel: (json['competitionLevel'] ?? json['competition_level'] ?? 'Professional').toString(),
      division: (json['division'] ?? '1st division').toString(),
      marketValue: (json['marketValue'] ?? json['market_value'] ?? '€3.5M').toString(),
      preferredFoot: foot,
      heightCm: ((json['heightCm'] ?? json['height_cm'] ?? 180) as num).toInt(),
      languages: langs,
      goals: ((json['goals'] ?? 0) as num).toInt(),
      assists: ((json['assists'] ?? 0) as num).toInt(),
      appearances: ((json['appearances'] ?? 0) as num).toInt(),
      minutesPlayed: ((json['minutesPlayed'] ?? json['minutes_played'] ?? 0) as num).toInt(),
      bio: (json['bio'] ?? defaultBio).toString(),
      traits: parseList(json['traits'], const ['Set-pieces', 'Vision']),
      radarStats: radar,
      transferWishes: wishes,
      marketValueHistory: history,
      highlights: clips,
      hashtags: parseList(json['hashtags']),
      likesCount: ((json['likesCount'] ?? json['likes_count'] ?? 0) as num).toInt(),
      commentsCount: ((json['commentsCount'] ?? json['comments_count'] ?? 0) as num).toInt(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? json['created_at'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  final String id, authorId, authorName, videoUrl;
  final String? authorAvatar, thumbnailUrl, description, clubLogoUrl;
  final String positionCode, positionFull, nationality, countryCode, countryFlag;
  final String availabilityStatus, clubName, clubCity, leagueName, clubCountry;
  final String competitionLevel, division, marketValue, preferredFoot, bio;
  final int jerseyNumber, fitScore, aiRating, age, heightCm;
  final int goals, assists, appearances, minutesPlayed, likesCount, commentsCount;
  final List<String> languages, traits, hashtags;
  final PlayerRadarStats radarStats;
  final List<TransferWishClub> transferWishes;
  final List<MarketValuePoint> marketValueHistory;
  final List<PlayerHighlightClip> highlights;
  final DateTime createdAt;

  double get goalsPer90 => minutesPlayed > 0 ? (goals * 90) / minutesPlayed : 0.0;
  double get assistsPer90 => minutesPlayed > 0 ? (assists * 90) / minutesPlayed : 0.0;
  int get goalContributions => goals + assists;
  double get contributionsPer90 => goalsPer90 + assistsPer90;

  String? get youtubeVideoId {
    final regExp = RegExp(
      r'(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))([\w-]{11})',
      caseSensitive: false,
    );
    return regExp.firstMatch(videoUrl)?.group(1);
  }

  String get resolvedThumbnailUrl {
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) return thumbnailUrl!;
    final ytId = youtubeVideoId;
    if (ytId != null) return 'https://img.youtube.com/vi/$ytId/hqdefault.jpg';
    return 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=800';
  }

  List<PlayerHighlightClip> get resolvedHighlights {
    if (highlights.isNotEmpty) return highlights;
    return [
      PlayerHighlightClip(
        id: '${id}_main',
        title: description?.isNotEmpty == true ? description! : '$authorName · Official Scouting Reel ($leagueName)',
        videoUrl: videoUrl,
        thumbnailUrl: resolvedThumbnailUrl,
        duration: '03:42',
        category: 'Full Season Reel',
        season: '2025/26',
        viewsLabel: '${(likesCount * 11).clamp(1200, 99000)} views',
      ),
      PlayerHighlightClip(
        id: '${id}_skills',
        title: '$authorName · ${traits.isNotEmpty ? traits.join(' & ') : positionFull} Breakdown',
        videoUrl: videoUrl,
        thumbnailUrl: youtubeVideoId != null ? 'https://img.youtube.com/vi/$youtubeVideoId/hqdefault.jpg' : resolvedThumbnailUrl,
        duration: '02:18',
        category: 'Skills & Goals',
        season: '2025/26',
        viewsLabel: '${(likesCount * 6).clamp(850, 54000)} views',
      ),
      PlayerHighlightClip(
        id: '${id}_tactical',
        title: 'AI Tactical Camera · $clubName ($positionCode #$jerseyNumber)',
        videoUrl: videoUrl,
        thumbnailUrl: resolvedThumbnailUrl,
        duration: '04:05',
        category: 'Tactical Analysis',
        season: '2024/25',
        viewsLabel: '${(likesCount * 4).clamp(620, 32000)} views',
      ),
    ];
  }

  String get clubInitials {
    final parts = clubName.replaceAll(RegExp(r'\b(SV|FC|SSC|SL|BC)\b'), '').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'FC';
    if (parts.length == 1) return parts.first.substring(0, 2).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() => {
        'id': id, 'authorId': authorId, 'authorName': authorName, 'authorAvatar': authorAvatar,
        'videoUrl': videoUrl, 'thumbnailUrl': thumbnailUrl, 'description': description,
        'positionCode': positionCode, 'positionFull': positionFull, 'jerseyNumber': jerseyNumber,
        'fitScore': fitScore, 'aiRating': aiRating, 'age': age, 'nationality': nationality,
        'countryCode': countryCode, 'countryFlag': countryFlag, 'availabilityStatus': availabilityStatus,
        'clubName': clubName, 'clubLogoUrl': clubLogoUrl, 'clubCity': clubCity, 'leagueName': leagueName,
        'clubCountry': clubCountry, 'competitionLevel': competitionLevel, 'division': division,
        'marketValue': marketValue, 'preferredFoot': preferredFoot, 'heightCm': heightCm,
        'languages': languages, 'goals': goals, 'assists': assists, 'appearances': appearances,
        'minutesPlayed': minutesPlayed, 'bio': bio, 'traits': traits, 'radarStats': radarStats.toJson(),
        'transferWishes': transferWishes.map((w) => w.toJson()).toList(),
        'marketValueHistory': marketValueHistory.map((m) => m.toJson()).toList(),
        'highlights': highlights.map((h) => h.toJson()).toList(),
        'hashtags': hashtags, 'likesCount': likesCount, 'commentsCount': commentsCount,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id, authorId, authorName, videoUrl, positionCode, fitScore, aiRating, clubName,
        marketValue, goals, assists, appearances, minutesPlayed, radarStats,
        transferWishes, marketValueHistory, highlights,
      ];
}
