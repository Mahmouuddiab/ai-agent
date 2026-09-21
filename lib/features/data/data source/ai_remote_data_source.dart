import 'package:google_generative_ai/google_generative_ai.dart';

abstract class AIRemoteDataSource {
  Future<String> executeAgentLoop(String userPrompt);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  late final ChatSession _chatSession;

  AIRemoteDataSourceImpl({required String apiKey}) {
    final model = GenerativeModel(
      model: 'gemini-3.6-flash',
      apiKey: apiKey,
      tools: [_appTools],
      systemInstruction: Content.system(
        'You are an AI Agent operating inside a mobile app. '
            'Execute provided tools whenever requested by user intent.',
      ),
    );
    _chatSession = model.startChat();
  }

  // Declare tools available to the model
  static final Tool _appTools = Tool(
    functionDeclarations: [
      FunctionDeclaration(
        'fetchAppPreferences',
        'Retrieves current application setting preferences.',
        Schema.object(properties: {}),
      ),
    ],
  );

  @override
  Future<String> executeAgentLoop(String userPrompt, {int maxTurns = 5}) async {
    GenerateContentResponse response = await _chatSession.sendMessage(
      Content.text(userPrompt),
    );

    int turn = 0;
    while (response.functionCalls.isNotEmpty && turn < maxTurns) {
      turn++;
      final responses = <Content>[];

      for (final call in response.functionCalls) {
        final result = await _executeLocalTool(call);
        responses.add(Content.functionResponse(call.name, result));
      }

      response = await _chatSession.sendMessage(
        Content.multi([...responses.expand((c) => c.parts)]),
      );
    }

    return response.text ?? 'Action executed successfully.';
  }

  Future<Map<String, dynamic>> _executeLocalTool(FunctionCall call) async {
    switch (call.name) {
      case 'fetchAppPreferences':
        return {'theme': 'dark', 'notificationsEnabled': true};
      default:
        throw UnimplementedError('Tool ${call.name} not implemented.');
    }
  }
}