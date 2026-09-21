import 'package:equatable/equatable.dart';
import '../../domain/entities/agent_message.dart';

abstract class AIAgentState extends Equatable {
  const AIAgentState();

  @override
  List<Object?> get props => [];
}

class AIAgentInitial extends AIAgentState {}

class AIAgentLoading extends AIAgentState {
  final List<AgentMessage> messages;

  const AIAgentLoading(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AIAgentSuccess extends AIAgentState {
  final List<AgentMessage> messages;

  const AIAgentSuccess(this.messages);

  @override
  List<Object?> get props => [messages];
}

class AIAgentFailure extends AIAgentState {
  final String errorMessage;
  final List<AgentMessage> messages;

  const AIAgentFailure(this.errorMessage, this.messages);

  @override
  List<Object?> get props => [errorMessage, messages];
}