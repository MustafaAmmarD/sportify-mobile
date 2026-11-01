import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/news/domain/entities/news_entities.dart';
import 'package:sportify/features/news/presentation/bloc/news_bloc.dart';
import 'package:sportify/features/news/presentation/bloc/news_event.dart';
import 'package:sportify/features/news/presentation/bloc/news_state.dart';
import 'package:sportify/features/news/presentation/widgets/news_article_card.dart';
import 'package:sportify/features/news/presentation/widgets/news_sources_strip.dart';

/// Tab view displaying news articles with category filtering and infinite scroll.
class NewsTabView extends StatefulWidget {
  const NewsTabView({super.key, required this.state});

  final NewsLoaded state;

  @override
  State<NewsTabView> createState() => _NewsTabViewState();
}

class _NewsTabViewState extends State<NewsTabView> {
  final _scrollController = ScrollController();
  String _filter = 'All';

  static const _filters = [
    'All',
    'Transfers',
    'Injuries',
    'International',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.9) {
      context.read<NewsBloc>().add(LoadMoreNews());
    }
  }

  List<NewsItem> _filterNews(List<NewsItem> all) {
    if (_filter == 'All') return all;
    final f = _filter.toLowerCase();
    return all.where((n) {
      final t = '${n.category} ${n.title}'.toLowerCase();
      return t.contains(f.substring(0, f.length - 1));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);

    final items = _filterNews(widget.state.news);
    final hero = items.isNotEmpty ? items.first : null;
    final rest = items.length > 1 ? items.sublist(1) : <NewsItem>[];

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 4),
        const NewsSourcesStrip(),
        const SizedBox(height: 16),
        if (hero != null) NewsHeroCard(item: hero),
        const SizedBox(height: 16),

        // Category filter chips
        SizedBox(
          height: 34,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _filters.map((f) {
              final sel = f == _filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel
                          ? green.withValues(alpha: 0.15)
                          : card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? green : border),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: sel ? green : Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Article cards
        ...rest.map((n) => NewsArticleCard(item: n)),
        if (!widget.state.hasReachedMaxNews)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(color: green)),
          ),
      ],
    );
  }
}
