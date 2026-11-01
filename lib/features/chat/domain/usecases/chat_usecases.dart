import '../entities/chat_entities.dart';
import '../repositories/chat_repository.dart';

class GetConversations {
  final ChatRepository repository;

  GetConversations(this.repository);

  Future<List<Conversation>> call() async {
    return await repository.getConversations();
  }
}

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<ChatMessage>> call(String conversationId, {int page = 1}) async {
    return await repository.getMessages(conversationId, page: page);
  }
}

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String conversationId, String text) async {
    return await repository.sendMessage(conversationId, text);
  }
}
