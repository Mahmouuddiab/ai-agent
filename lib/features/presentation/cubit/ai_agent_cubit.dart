import 'package:ai_integration/features/domain/usecase/process_agent_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent_message.dart';
import 'ai_agent_state.dart';

class AIAgentCubit extends Cubit<AIAgentState> {
  final ProcessAgentMessageUseCase processMessageUseCase;
  final List<AgentMessage> _messages = [];

  AIAgentCubit(this.processMessageUseCase) : super(AIAgentInitial());

  Future<void> sendPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return;

    // 1. Add user message locally
    _messages.add(AgentMessage(text: prompt, sender: MessageSender.user));
    emit(AIAgentLoading(List.from(_messages)));

    // 2. Execute UseCase
    final result = await processMessageUseCase(prompt);

    // 3. Process result
    result.fold(
          (failure) {
        emit(AIAgentFailure(failure.message, List.from(_messages)));
      },
          (response) {
        _messages.add(
          AgentMessage(text: response, sender: MessageSender.agent),
        );
        emit(AIAgentSuccess(List.from(_messages)));
      },
    );
  }
}