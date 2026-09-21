import 'package:ai_integration/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class AIAgentRepository {
  Future<Either<Failure, String>> processUserPrompt(String prompt);
}