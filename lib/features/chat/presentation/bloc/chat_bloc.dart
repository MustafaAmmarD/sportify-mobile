import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/chat_usecases.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetConversations getConversations;

  ChatBloc({
    required this.getConversations,
  }) : super(ChatInitial()) {
    on<LoadConversations>(_onLoadConversations);
  }

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final conversations = await getConversations();
      emit(ChatLoaded(conversations));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
