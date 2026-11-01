import 'package:equatable/equatable.dart';
import 'package:sportify/core/error/failures.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';

sealed class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  const FeedLoaded({
    required this.posts,
    required this.currentPage,
    required this.hasReachedMax,
  });

  final List<FeedPost> posts;
  final int currentPage;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [posts, currentPage, hasReachedMax];

  FeedLoaded copyWith({
    List<FeedPost>? posts,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class FeedError extends FeedState {
  const FeedError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
