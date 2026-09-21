import 'package:ai_integration/features/domain/repository/ai_agent_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';

class ProcessAgentMessageUseCase {
  final AIAgentRepository repository;

  ProcessAgentMessageUseCase(this.repository);

  Future<Either<Failure, String>> call(String prompt) {
    return repository.processUserPrompt(prompt);
  }
}