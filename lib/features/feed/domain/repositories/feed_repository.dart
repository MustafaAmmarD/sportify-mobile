import 'package:fpdart/fpdart.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

abstract interface class FeedRepository {
  Future<Either<Failure, List<FeedPost>>> getFeedPosts({int page = 1});
}
