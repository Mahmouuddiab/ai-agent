import 'package:ai_integration/features/domain/repository/ai_agent_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../data source/ai_remote_data_source.dart';

class AIAgentRepositoryImpl implements AIAgentRepository {
  final AIRemoteDataSource remoteDataSource;

  AIAgentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> processUserPrompt(String prompt) async {
    try {
      final responseText = await remoteDataSource.executeAgentLoop(prompt);
      return Right(responseText);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}