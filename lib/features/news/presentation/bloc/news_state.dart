import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entities.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsItem> news;
  final List<TransferActivity> transfers;
  final bool hasReachedMaxNews;
  final bool hasReachedMaxTransfers;

  const NewsLoaded({
    required this.news,
    required this.transfers,
    this.hasReachedMaxNews = false,
    this.hasReachedMaxTransfers = false,
  });

  NewsLoaded copyWith({
    List<NewsItem>? news,
    List<TransferActivity>? transfers,
    bool? hasReachedMaxNews,
    bool? hasReachedMaxTransfers,
  }) {
    return NewsLoaded(
      news: news ?? this.news,
      transfers: transfers ?? this.transfers,
      hasReachedMaxNews: hasReachedMaxNews ?? this.hasReachedMaxNews,
      hasReachedMaxTransfers: hasReachedMaxTransfers ?? this.hasReachedMaxTransfers,
    );
  }

  @override
  List<Object?> get props => [news, transfers, hasReachedMaxNews, hasReachedMaxTransfers];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}
