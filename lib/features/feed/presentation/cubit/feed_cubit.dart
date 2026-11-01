import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/domain/use_cases/get_feed_posts.dart';
import 'package:sportify/features/feed/presentation/cubit/feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({
    required GetFeedPosts getFeedPosts,
  })  : _getFeedPosts = getFeedPosts,
        super(const FeedInitial());

  final GetFeedPosts _getFeedPosts;

  void prependUploadedPost(FeedPost post) {
    final current = state;
    if (current is FeedLoaded) {
      emit(current.copyWith(posts: [post, ...current.posts]));
    } else {
      emit(FeedLoaded(posts: [post], currentPage: 1, hasReachedMax: false));
    }
  }

  Future<void> fetchInitialPosts() async {
    emit(const FeedLoading());
    final result = await _getFeedPosts(1);
    
    emit(
      result.fold(
        FeedError.new,
        (posts) => FeedLoaded(
          posts: posts,
          currentPage: 1,
          hasReachedMax: posts.isEmpty,
        ),
      ),
    );
  }

  Future<void> loadMorePosts() async {
    if (state is! FeedLoaded) return;
    
    final currentState = state as FeedLoaded;
    if (currentState.hasReachedMax) return;

    final nextPage = currentState.currentPage + 1;
    final result = await _getFeedPosts(nextPage);

    result.fold(
      (failure) => null, // Ignore load more errors for now or handle silently
      (newPosts) {
        emit(
          currentState.copyWith(
            posts: List.of(currentState.posts)..addAll(newPosts),
            currentPage: nextPage,
            hasReachedMax: newPosts.isEmpty,
          ),
        );
      },
    );
  }
}
