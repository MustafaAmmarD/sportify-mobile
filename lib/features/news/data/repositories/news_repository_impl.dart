import '../../domain/entities/news_entities.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NewsItem>> getNews({int page = 1, int limit = 20}) async {
    return await remoteDataSource.getNews(page, limit);
  }

  @override
  Future<List<TransferActivity>> getTransfers({int page = 1, int limit = 20}) async {
    return await remoteDataSource.getTransfers(page, limit);
  }
}
