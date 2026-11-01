import '../entities/chat_entities.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId, {int page = 1});
  Future<void> sendMessage(String conversationId, String text);
}
