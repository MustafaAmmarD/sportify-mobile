import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/conversation_tile.dart';
import 'chat_thread_page.dart';

/// Entry page for direct messages and conversations.
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(LoadConversations()),
      child: const _ConversationListView(),
    );
  }
}

class _ConversationListView extends StatefulWidget {
  const _ConversationListView();

  @override
  State<_ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<_ConversationListView> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header bar ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              color: bg,
              child: Row(
                children: [
                  if (Navigator.canPop(context)) ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 38,
                        height: 38,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                  const Expanded(
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  _HeaderIconBtn(icon: Icons.person_add_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _HeaderIconBtn(icon: Icons.edit_outlined, onTap: () {}),
                ],
              ),
            ),

          // ── Search field ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _search,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white38),
                filled: true,
                fillColor: card,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: green),
                ),
              ),
            ),
          ),

          // ── Conversations list ──
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial || state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator(color: green));
                }
                if (state is ChatError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                if (state is! ChatLoaded) return const SizedBox.shrink();

                final list = state.conversations.where((c) {
                  if (_query.isEmpty) return true;
                  return c.otherParticipant.name.toLowerCase().contains(_query) ||
                      (c.lastMessage?.text.toLowerCase().contains(_query) ?? false);
                }).toList();

                if (list.isEmpty) {
                  return const _EmptyChatState();
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, i) {
                    final conv = list[i];
                    return ConversationTile(
                      conversation: conv,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ChatThreadPage(
                              conversation: conv,
                              currentUserId: 'me',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _HeaderIconBtn extends StatelessWidget {
  const _HeaderIconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFF0E1822),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1B2A38)),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState();

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: green.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: green.withOpacity(0.3)),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: green, size: 36),
          ),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect with players, clubs and scouts',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
