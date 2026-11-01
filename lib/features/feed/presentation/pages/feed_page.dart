import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/chat/presentation/pages/chat_page.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:sportify/features/feed/presentation/cubit/feed_state.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_header_strip.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_highlight_card.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_upload_sheet.dart';
import 'package:sportify/features/feed/presentation/widgets/guest_auth_sheet.dart';

/// Mobile-first talent & highlight discovery feed.
///
/// Features dynamic position filtering, player/club search, tap-to-play
/// video highlights, and direct profile navigation.
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeedCubit>()..fetchInitialPosts(),
      child: const _FeedView(),
    );
  }
}

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  static const List<String> _filters = [
    'All',
    'ST',
    'LW',
    'RW',
    'CAM',
    'CM',
    'CDM',
    'CB',
    'RB',
    'GK',
  ];

  String _selectedFilter = 'All';
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FeedPost> _filterPosts(List<FeedPost> all) {
    final query = _searchController.text.trim().toLowerCase();
    return all.where((post) {
      final matchesPos =
          _selectedFilter == 'All' ||
          post.positionCode.toUpperCase() == _selectedFilter;
      final matchesQuery =
          query.isEmpty ||
          '${post.authorName} ${post.clubName} ${post.nationality} ${post.positionFull} ${post.leagueName} ${post.traits.join(' ')} ${post.hashtags.join(' ')}'
              .toLowerCase()
              .contains(query);
      return matchesPos && matchesQuery;
    }).toList();
  }

  void _handleTagTap(String tag) {
    setState(() {
      _showSearch = true;
      _searchController.text = tag;
    });
  }

  void _openUploadSheet() {
    final cubit = context.read<FeedCubit>();
    showFeedUploadSheet(
      context,
      onPostCreated: cubit.prependUploadedPost,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF050A12);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Compact floating header ──
            FeedHeader(
              searchActive: _showSearch,
              onUploadTap: _openUploadSheet,
              onSearchTap: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) _searchController.clear();
                });
              },
              onChatTap: _openChat,
            ),

            // ── Expandable search bar ──
            if (_showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search talent, club, position, country...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white38,
                    ),
                    filled: true,
                    fillColor: card,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: green),
                    ),
                  ),
                ),
              ),

            // ── Position filter strip ──
            FeedFilterStrip(
              filters: _filters,
              selected: _selectedFilter,
              onSelected: (f) => setState(() => _selectedFilter = f),
            ),

            // ── Dynamic feed list ──
            Expanded(
              child: BlocBuilder<FeedCubit, FeedState>(
                builder: (context, state) {
                  if (state is FeedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: green),
                    );
                  } else if (state is FeedError) {
                    return Center(
                      child: Text(
                        state.failure.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is FeedLoaded) {
                    final filtered = _filterPosts(state.posts);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person_search_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No players found for "$_selectedFilter".',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: green,
                      backgroundColor: card,
                      onRefresh: () => context.read<FeedCubit>().fetchInitialPosts(),
                      child: _FeedList(posts: filtered, onTagTap: _handleTagTap),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat() {
    if (!ensureAuthenticatedOrPrompt(context, actionLabel: 'message players & scouts')) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ChatPage()),
    );
  }
}

/// Single-column mobile feed list of player highlight & scouting cards.
class _FeedList extends StatelessWidget {
  const _FeedList({required this.posts, required this.onTagTap});

  final List<FeedPost> posts;
  final ValueChanged<String> onTagTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (_, i) => FeedHighlightCard(
        post: posts[i],
        onTagTap: onTagTap,
      ),
    );
  }
}
