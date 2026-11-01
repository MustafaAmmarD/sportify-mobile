import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_entities.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_composer.dart';

class _LocalMsg {
  const _LocalMsg(this.senderId, this.text, this.timestamp);
  final String senderId;
  final String text;
  final DateTime timestamp;
}

/// Message thread view for an active conversation.
class ChatThreadPage extends StatefulWidget {
  const ChatThreadPage({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  final Conversation conversation;
  final String currentUserId;

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  late final List<_LocalMsg> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _buildInitialMessages();
  }

  List<_LocalMsg> _buildInitialMessages() {
    final now = DateTime.now();
    final other = widget.conversation.otherParticipant.id;
    final me = widget.currentUserId;
    return [
      _LocalMsg(other, 'Hey! Great profile, are you available for trials?',
          now.subtract(const Duration(hours: 2, minutes: 14))),
      _LocalMsg(me, 'Hi! Yes, I am looking for new opportunities right now.',
          now.subtract(const Duration(hours: 2, minutes: 10))),
      _LocalMsg(other, 'Perfect. We have a trial session next Saturday in Berlin.',
          now.subtract(const Duration(hours: 2))),
      _LocalMsg(me, 'That sounds great, what time does it start?',
          now.subtract(const Duration(hours: 1, minutes: 50))),
      _LocalMsg(other, 'It starts at 10am. Can you make it?',
          now.subtract(const Duration(hours: 1, minutes: 40))),
      _LocalMsg(me, 'Absolutely! I will be there.',
          now.subtract(const Duration(hours: 1, minutes: 35))),
      _LocalMsg(
        other,
        widget.conversation.lastMessage?.text ?? 'Looking forward to seeing you there!',
        now.subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_LocalMsg(widget.currentUserId, text, DateTime.now()));
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    if (_sameDay(dt, now)) return 'Today';
    if (_sameDay(dt, now.subtract(const Duration(days: 1)))) return 'Yesterday';
    return DateFormat('MMMM d, y').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const green = AppColors.green2;
    final other = widget.conversation.otherParticipant;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: green.withOpacity(0.15),
                    border: Border.all(color: green.withOpacity(0.4)),
                  ),
                  child: Text(
                    other.name.isNotEmpty ? other.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: green,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (other.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                        border: Border.all(color: card, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    other.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    other.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: other.isOnline ? green : Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final mine = msg.senderId == widget.currentUserId;
                final showDate = i == 0 || !_sameDay(_messages[i - 1].timestamp, msg.timestamp);

                return Column(
                  children: [
                    if (showDate)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _dateLabel(msg.timestamp),
                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                      ),
                    ChatBubble(
                      text: msg.text,
                      timestamp: msg.timestamp,
                      isMine: mine,
                    ),
                  ],
                );
              },
            ),
          ),
          ChatComposer(
            controller: _controller,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}
