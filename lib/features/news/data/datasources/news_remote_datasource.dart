import '../../domain/entities/news_entities.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsItem>> getNews(int page, int limit);
  Future<List<TransferActivity>> getTransfers(int page, int limit);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  const NewsRemoteDataSourceImpl();

  @override
  Future<List<NewsItem>> getNews(int page, int limit) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data based on sportifyplus.de
    return [
      NewsItem(
        id: 'news-1',
        title: 'Bayern Munich eyes new talent from Sportify academy',
        summary: 'The German giants are reportedly scouting young talents discovered through the Sportify platform...',
        source: 'Sky Sports',
        url: 'https://example.com/news/1',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'transfers',
      ),
      NewsItem(
        id: 'news-2',
        title: 'Sportify AI predicts 2026 World Cup breakouts',
        summary: 'Our RefereeX AI has analyzed over 250,000 matches to bring you the top predictions...',
        source: 'Sportify News',
        url: 'https://example.com/news/2',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        category: 'general',
      ),
      NewsItem(
        id: 'news-3',
        title: 'Real Madrid secure late victory in El Clasico',
        summary: 'A 90th-minute winner sealed all three points in a dramatic encounter...',
        source: 'BBC Sport',
        url: 'https://example.com/news/3',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        category: 'match_results',
      ),
    ];
  }

  @override
  Future<List<TransferActivity>> getTransfers(int page, int limit) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data based on sportifyplus.de
    return [
      TransferActivity(
        id: 'tx-1',
        playerId: 'p-123',
        playerName: 'Marcus Thuram',
        fromClub: 'Inter Milan',
        toClub: 'Paris SG',
        status: 'rumor',
        fee: '€65M',
        date: DateTime.now().subtract(const Duration(days: 1)),
        source: 'The Guardian',
      ),
      TransferActivity(
        id: 'tx-2',
        playerId: 'p-456',
        playerName: 'Jude Bellingham',
        fromClub: 'Real Madrid',
        toClub: 'Real Madrid', // Extending contract
        status: 'confirmed',
        fee: 'Contract Extension',
        date: DateTime.now().subtract(const Duration(days: 2)),
        source: '90min',
      ),
      TransferActivity(
        id: 'tx-3',
        playerId: 'p-789',
        playerName: 'Florian Wirtz',
        fromClub: 'Bayer Leverkusen',
        toClub: 'Bayern Munich',
        status: 'rumor',
        fee: '€100M+',
        date: DateTime.now().subtract(const Duration(days: 3)),
        source: 'Sky Sports',
      ),
    ];
  }
}
