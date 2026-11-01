import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/chat_entities.dart';

/// Renders a single conversation row with participant avatar, online badge, and unread pill.
class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  String _fmt(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) return DateFormat.Hm().format(dt);
    if (now.difference(dt).inDays == 1) return 'Yesterday';
    if (now.difference(dt).inDays < 7) return DateFormat('EEE').format(dt);
    return DateFormat('d MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    final other = conversation.otherParticipant;
    final last = conversation.lastMessage;
    final unread = conversation.unreadCount > 0;
    final time = last != null ? _fmt(last.timestamp) : '';

    return InkWell(
      onTap: onTap,
      splashColor: green.withOpacity(0.06),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border)),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: green.withOpacity(0.15),
                    border: Border.all(
                      color: unread ? green.withOpacity(0.6) : border,
                    ),
                  ),
                  child: Text(
                    other.name.isNotEmpty ? other.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: unread ? green : Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (other.isOnline)
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                        border: Border.all(color: bg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          other.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: unread ? FontWeight.w800 : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: unread ? green : Colors.white38,
                          fontSize: 11,
                          fontWeight: unread ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          last?.text ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: unread ? Colors.white70 : Colors.white38,
                            fontSize: 13,
                            fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (conversation.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
