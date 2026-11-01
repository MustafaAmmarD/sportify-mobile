import 'package:equatable/equatable.dart';

class ChatParticipant extends Equatable {
  final String id;
  final String name;
  final String? profileImageUrl;
  final bool isOnline;

  const ChatParticipant({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [id, name, profileImageUrl, isOnline];
}

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, senderId, text, timestamp, isRead];
}

class Conversation extends Equatable {
  final String id;
  final ChatParticipant otherParticipant;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.otherParticipant,
    this.lastMessage,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, otherParticipant, lastMessage, unreadCount];
}
