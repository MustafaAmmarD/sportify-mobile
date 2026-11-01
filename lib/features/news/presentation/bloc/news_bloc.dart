import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/news_usecases.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetNews getNews;
  final GetTransfers getTransfers;

  int _currentNewsPage = 1;
  int _currentTransfersPage = 1;
  static const int _limit = 20;

  NewsBloc({
    required this.getNews,
    required this.getTransfers,
  }) : super(NewsInitial()) {
    on<FetchNewsAndTransfers>(_onFetchNewsAndTransfers);
    on<LoadMoreNews>(_onLoadMoreNews);
    on<LoadMoreTransfers>(_onLoadMoreTransfers);
  }

  Future<void> _onFetchNewsAndTransfers(
    FetchNewsAndTransfers event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      _currentNewsPage = 1;
      _currentTransfersPage = 1;

      final results = await Future.wait([
        getNews(page: _currentNewsPage, limit: _limit),
        getTransfers(page: _currentTransfersPage, limit: _limit),
      ]);

      final newsList = results[0] as List<dynamic>;
      final transfersList = results[1] as List<dynamic>;

      emit(NewsLoaded(
        news: List.from(newsList),
        transfers: List.from(transfersList),
        hasReachedMaxNews: newsList.length < _limit,
        hasReachedMaxTransfers: transfersList.length < _limit,
      ));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasReachedMaxNews) return;

      try {
        _currentNewsPage++;
        final newsList = await getNews(page: _currentNewsPage, limit: _limit);

        emit(currentState.copyWith(
          news: List.of(currentState.news)..addAll(newsList),
          hasReachedMaxNews: newsList.length < _limit,
        ));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreTransfers(
    LoadMoreTransfers event,
    Emitter<NewsState> emit,
  ) async {
    if (state is NewsLoaded) {
      final currentState = state as NewsLoaded;
      if (currentState.hasReachedMaxTransfers) return;

      try {
        _currentTransfersPage++;
        final transfersList = await getTransfers(page: _currentTransfersPage, limit: _limit);

        emit(currentState.copyWith(
          transfers: List.of(currentState.transfers)..addAll(transfersList),
          hasReachedMaxTransfers: transfersList.length < _limit,
        ));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }
}
