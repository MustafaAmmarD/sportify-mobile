import 'package:equatable/equatable.dart';

/// Dynamic radar and key attribute ratings (0–100) for a player.
class PlayerRadarStats extends Equatable {
  const PlayerRadarStats({
    this.pace = 85,
    this.shooting = 80,
    this.passing = 85,
    this.dribbling = 85,
    this.defending = 70,
    this.physical = 82,
    this.customAttributes,
  });

  factory PlayerRadarStats.fromJson(Map<String, dynamic> json) {
    final custom = <String, int>{};
    for (final entry in json.entries) {
      if (entry.value is num) {
        final key = entry.key;
        final label = key[0].toUpperCase() + key.substring(1);
        custom[label] = (entry.value as num).toInt();
      }
    }
    return PlayerRadarStats(
      pace: ((json['pace'] ?? json['Pace'] ?? 85) as num).toInt(),
      shooting: ((json['shooting'] ?? json['Shooting'] ?? 80) as num).toInt(),
      passing: ((json['passing'] ?? json['Passing'] ?? 85) as num).toInt(),
      dribbling: ((json['dribbling'] ?? json['Dribbling'] ?? 85) as num).toInt(),
      defending: ((json['defending'] ?? json['Defending'] ?? 70) as num).toInt(),
      physical: ((json['physical'] ?? json['Physical'] ?? 82) as num).toInt(),
      customAttributes: custom.isNotEmpty ? custom : null,
    );
  }

  final int pace, shooting, passing, dribbling, defending, physical;
  final Map<String, int>? customAttributes;

  List<(String, int)> get entries {
    if (customAttributes != null && customAttributes!.length >= 3) {
      return customAttributes!.entries.map((e) => (e.key, e.value)).toList();
    }
    return [
      ('Pace', pace),
      ('Shooting', shooting),
      ('Passing', passing),
      ('Dribbling', dribbling),
      ('Defending', defending),
      ('Physical', physical),
    ];
  }

  Map<String, dynamic> toJson() => customAttributes ?? {'pace': pace, 'shooting': shooting, 'passing': passing, 'dribbling': dribbling, 'defending': defending, 'physical': physical};

  @override
  List<Object?> get props => [pace, shooting, passing, dribbling, defending, physical, customAttributes];
}

/// Represents a target club in the player's "Transfer wishes" list.
class TransferWishClub extends Equatable {
  const TransferWishClub({
    required this.clubName,
    required this.country,
    required this.league,
    this.tier = 'Elite',
    this.badgeColorHex = 0xFF22C55E,
  });

  factory TransferWishClub.fromJson(Map<String, dynamic> json) {
    return TransferWishClub(
      clubName: (json['clubName'] ?? json['club_name'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      league: (json['league'] ?? '').toString(),
      tier: (json['tier'] ?? 'Elite').toString(),
      badgeColorHex: ((json['badgeColorHex'] ?? json['badge_color_hex'] ?? 0xFF22C55E) as num).toInt(),
    );
  }

  final String clubName, country, league, tier;
  final int badgeColorHex;

  String get initials {
    final parts = clubName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'FC';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() => {'clubName': clubName, 'country': country, 'league': league, 'tier': tier, 'badgeColorHex': badgeColorHex};

  @override
  List<Object?> get props => [clubName, country, league, tier, badgeColorHex];
}

/// A single historical data point for the player's Market Value Trend chart.
class MarketValuePoint extends Equatable {
  const MarketValuePoint({
    required this.period,
    required this.valueMillions,
    String? formattedLabel,
  }) : label = formattedLabel ?? '€${valueMillions}M';

  factory MarketValuePoint.fromJson(Map<String, dynamic> json) {
    final val = ((json['valueMillions'] ?? json['value_millions'] ?? json['value'] ?? 1.0) as num).toDouble();
    final period = (json['period'] ?? json['year'] ?? '').toString();
    final formatted = json['label'] as String?;
    return MarketValuePoint(
      period: period,
      valueMillions: val,
      formattedLabel: formatted ?? '€${val == val.roundToDouble() ? val.toInt() : val.toStringAsFixed(1)}M',
    );
  }

  final String period;
  final double valueMillions;
  final String label;

  Map<String, dynamic> toJson() => {'period': period, 'valueMillions': valueMillions, 'label': label};

  @override
  List<Object?> get props => [period, valueMillions, label];
}

/// A dynamic video highlight clip for a player's scouting profile.
class PlayerHighlightClip extends Equatable {
  const PlayerHighlightClip({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.thumbnailUrl,
    this.duration = '03:24',
    this.category = 'Full Season Reel',
    this.season = '2025/26',
    this.viewsLabel = '14.2K views',
  });

  factory PlayerHighlightClip.fromJson(Map<String, dynamic> json) {
    return PlayerHighlightClip(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Scouting Highlight Reel').toString(),
      videoUrl: (json['videoUrl'] ?? json['video_url'] ?? '').toString(),
      thumbnailUrl: (json['thumbnailUrl'] ?? json['thumbnail_url']) as String?,
      duration: (json['duration'] ?? '03:24').toString(),
      category: (json['category'] ?? 'Match Compilation').toString(),
      season: (json['season'] ?? '2025/26').toString(),
      viewsLabel: (json['viewsLabel'] ?? json['views_label'] ?? '12K views').toString(),
    );
  }

  final String id, title, videoUrl, duration, category, season, viewsLabel;
  final String? thumbnailUrl;

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
    return 'https://images.unsplash.com/photo-1517466787929-bc90951d0974?w=900&q=80';
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'videoUrl': videoUrl, 'thumbnailUrl': thumbnailUrl, 'duration': duration, 'category': category, 'season': season, 'viewsLabel': viewsLabel};

  @override
  List<Object?> get props => [id, title, videoUrl, thumbnailUrl, duration, category, season, viewsLabel];
}

/// A dynamic action gallery photo for a player's scouting profile.
class PlayerGalleryPhoto extends Equatable {
  const PlayerGalleryPhoto({
    required this.id,
    required this.imageUrl,
    this.caption = 'Matchday Action',
    this.category = 'Matchday',
  });

  factory PlayerGalleryPhoto.fromDynamic(dynamic raw, {int index = 0}) {
    if (raw is String) return PlayerGalleryPhoto(id: 'photo_$index', imageUrl: raw);
    if (raw is Map<String, dynamic>) {
      return PlayerGalleryPhoto(
        id: (raw['id'] ?? 'photo_$index').toString(),
        imageUrl: (raw['imageUrl'] ?? raw['image_url'] ?? raw['url'] ?? '').toString(),
        caption: (raw['caption'] ?? raw['title'] ?? 'Matchday Action').toString(),
        category: (raw['category'] ?? 'Matchday').toString(),
      );
    }
    return PlayerGalleryPhoto(id: 'photo_$index', imageUrl: '');
  }

  final String id, imageUrl, caption, category;

  Map<String, dynamic> toJson() => {'id': id, 'imageUrl': imageUrl, 'caption': caption, 'category': category};

  @override
  List<Object?> get props => [id, imageUrl, caption, category];
}

/// A single season entry in the player's Career History timeline.
class PlayerCareerEntry extends Equatable {
  const PlayerCareerEntry({
    required this.season,
    required this.clubName,
    required this.competition,
    required this.appearances,
    required this.goals,
    this.assists = 0,
    this.roleTag = 'First Team',
    this.isCurrent = false,
  });

  factory PlayerCareerEntry.fromJson(Map<String, dynamic> json) {
    return PlayerCareerEntry(
      season: (json['season'] ?? json['period'] ?? '2024–25').toString(),
      clubName: (json['clubName'] ?? json['club_name'] ?? '').toString(),
      competition: (json['competition'] ?? json['league'] ?? '').toString(),
      appearances: ((json['appearances'] ?? json['apps'] ?? 0) as num).toInt(),
      goals: ((json['goals'] ?? 0) as num).toInt(),
      assists: ((json['assists'] ?? 0) as num).toInt(),
      roleTag: (json['roleTag'] ?? json['role_tag'] ?? 'First Team').toString(),
      isCurrent: (json['isCurrent'] ?? json['is_current'] ?? false) == true,
    );
  }

  final String season, clubName, competition, roleTag;
  final int appearances, goals, assists;
  final bool isCurrent;

  Map<String, dynamic> toJson() => {'season': season, 'clubName': clubName, 'competition': competition, 'appearances': appearances, 'goals': goals, 'assists': assists, 'roleTag': roleTag, 'isCurrent': isCurrent};

  @override
  List<Object?> get props => [season, clubName, competition, appearances, goals, assists, roleTag, isCurrent];
}

/// A single transfer entry in the player's Transfer History.
class PlayerTransferRecord extends Equatable {
  const PlayerTransferRecord({
    required this.dateLabel,
    required this.fromClub,
    required this.toClub,
    required this.feeLabel,
    this.transferType = 'Permanent',
  });

  factory PlayerTransferRecord.fromJson(Map<String, dynamic> json) {
    return PlayerTransferRecord(
      dateLabel: (json['dateLabel'] ?? json['date'] ?? 'Sep 2025').toString(),
      fromClub: (json['fromClub'] ?? json['from_club'] ?? '').toString(),
      toClub: (json['toClub'] ?? json['to_club'] ?? '').toString(),
      feeLabel: (json['feeLabel'] ?? json['fee'] ?? 'Free').toString(),
      transferType: (json['transferType'] ?? json['type'] ?? 'Permanent').toString(),
    );
  }

  final String dateLabel, fromClub, toClub, feeLabel, transferType;

  Map<String, dynamic> toJson() => {'dateLabel': dateLabel, 'fromClub': fromClub, 'toClub': toClub, 'feeLabel': feeLabel, 'transferType': transferType};

  @override
  List<Object?> get props => [dateLabel, fromClub, toClub, feeLabel, transferType];
}
