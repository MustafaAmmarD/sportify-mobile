import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Conversation>> getConversations() async {
    return await remoteDataSource.getConversations();
  }

  @override
  Future<List<ChatMessage>> getMessages(String conversationId, {int page = 1}) async {
    return await remoteDataSource.getMessages(conversationId, page);
  }

  @override
  Future<void> sendMessage(String conversationId, String text) async {
    return await remoteDataSource.sendMessage(conversationId, text);
  }
}
