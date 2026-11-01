import '../../domain/entities/chat_entities.dart';

abstract class ChatRemoteDataSource {
  Future<List<Conversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId, int page);
  Future<void> sendMessage(String conversationId, String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl();

  @override
  Future<List<Conversation>> getConversations() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return [
      Conversation(
        id: 'conv-1',
        otherParticipant: const ChatParticipant(
          id: 'user-2',
          name: 'FC Bayern Munich (Club)',
          isOnline: true,
        ),
        lastMessage: ChatMessage(
          id: 'msg-99',
          senderId: 'user-2',
          text: 'We are interested in your recent performance. Can we talk?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        unreadCount: 1,
      ),
      Conversation(
        id: 'conv-2',
        otherParticipant: const ChatParticipant(
          id: 'user-3',
          name: 'Sarah Coach (Trainer)',
        ),
        lastMessage: ChatMessage(
          id: 'msg-98',
          senderId: 'user-1', // Me
          text: 'Thanks for the session yesterday!',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ),
    ];
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId, int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    
    if (conversationId == 'conv-1') {
      return [
        ChatMessage(
          id: 'msg-1',
          senderId: 'user-2',
          text: 'Hello! We saw your highlight video.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ChatMessage(
          id: 'msg-2',
          senderId: 'user-1',
          text: 'Hi! Thank you. I am looking for a new club.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        ),
        ChatMessage(
          id: 'msg-3',
          senderId: 'user-2',
          text: 'We are interested in your recent performance. Can we talk?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];
    }
    return [];
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Simulate successful send
  }
}
