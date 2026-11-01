import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/exceptions.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl({required this.remoteDataSource});

  final FeedRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<FeedPost>>> getFeedPosts({int page = 1}) async {
    try {
      final posts = await remoteDataSource.getFeedPosts(page: page);
      return Right(posts);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on SportifyException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
