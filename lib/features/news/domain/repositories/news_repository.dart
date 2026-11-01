import '../entities/news_entities.dart';

abstract class NewsRepository {
  Future<List<NewsItem>> getNews({int page = 1, int limit = 20});
  Future<List<TransferActivity>> getTransfers({int page = 1, int limit = 20});
}
