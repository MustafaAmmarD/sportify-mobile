import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/core/usecase/usecase.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/repositories/feed_repository.dart';

class GetFeedPosts implements UseCase<List<FeedPost>, int> {
  const GetFeedPosts(this.repository);

  final FeedRepository repository;

  @override
  Future<Either<Failure, List<FeedPost>>> call(int page) {
    return repository.getFeedPosts(page: page);
  }
}
