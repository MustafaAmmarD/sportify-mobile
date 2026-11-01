import '../entities/news_entities.dart';
import '../repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsItem>> call({int page = 1, int limit = 20}) async {
    return await repository.getNews(page: page, limit: limit);
  }
}

class GetTransfers {
  final NewsRepository repository;

  GetTransfers(this.repository);

  Future<List<TransferActivity>> call({int page = 1, int limit = 20}) async {
    return await repository.getTransfers(page: page, limit: limit);
  }
}
