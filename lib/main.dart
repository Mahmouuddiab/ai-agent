import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/data/data source/ai_remote_data_source.dart';
import 'features/data/repository/ai_agent_repository_impl.dart';
import 'features/domain/repository/ai_agent_repository.dart';
import 'features/domain/usecase/process_agent_message_usecase.dart';
import 'features/presentation/cubit/ai_agent_cubit.dart';
import 'features/presentation/screen/ai_agent_screen.dart';


final sl = GetIt.instance;
void setupDependencyInjection() {
  // 1. Data Sources
  sl.registerLazySingleton<AIRemoteDataSource>(
        () => AIRemoteDataSourceImpl(
      apiKey: const String.fromEnvironment('GEMINI_API_KEY'),
    ),
  );

  // 2. Repositories
  sl.registerLazySingleton<AIAgentRepository>(
        () => AIAgentRepositoryImpl(sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton<ProcessAgentMessageUseCase>(
        () => ProcessAgentMessageUseCase(sl()),
  );

  // 4. Cubits / Controllers (Factory so each screen instance gets a fresh cubit)
  sl.registerFactory<AIAgentCubit>(
        () => AIAgentCubit(sl()),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Agent Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Inject the AIAgentCubit via GetIt into the AIAgentScreen
      home: BlocProvider<AIAgentCubit>(
        create: (context) => sl<AIAgentCubit>(),
        child: const AIAgentScreen(),
      ),
    );
  }
}