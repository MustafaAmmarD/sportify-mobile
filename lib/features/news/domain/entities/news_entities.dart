import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String source;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;
  final String category;

  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.url,
    this.imageUrl,
    required this.publishedAt,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        source,
        url,
        imageUrl,
        publishedAt,
        category,
      ];
}

class TransferActivity extends Equatable {
  final String id;
  final String playerId;
  final String playerName;
  final String fromClub;
  final String toClub;
  final String status; // 'confirmed' or 'rumor'
  final String? fee;
  final DateTime date;
  final String source;

  const TransferActivity({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.fromClub,
    required this.toClub,
    required this.status,
    this.fee,
    required this.date,
    required this.source,
  });

  @override
  List<Object?> get props => [
        id,
        playerId,
        playerName,
        fromClub,
        toClub,
        status,
        fee,
        date,
        source,
      ];
}
