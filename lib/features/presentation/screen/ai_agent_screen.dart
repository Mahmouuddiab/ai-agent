import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent_message.dart';
import '../cubit/ai_agent_cubit.dart';
import '../cubit/ai_agent_state.dart';

class AIAgentScreen extends StatefulWidget {
  const AIAgentScreen({super.key});

  @override
  State<AIAgentScreen> createState() => _AIAgentScreenState();
}

class _AIAgentScreenState extends State<AIAgentScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendMessage() {
    final text = _textController.text;
    _textController.clear();
    context.read<AIAgentCubit>().sendPrompt(text);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Agent Assistant'),
        centerTitle: true,
      ),
      body: BlocConsumer<AIAgentCubit, AIAgentState>(
        listener: (context, state) {
          if (state is AIAgentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          if (state is AIAgentSuccess || state is AIAgentLoading) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          List<AgentMessage> messages = [];

          if (state is AIAgentLoading) messages = state.messages;
          if (state is AIAgentSuccess) messages = state.messages;
          if (state is AIAgentFailure) messages = state.messages;

          return Column(
            children: [
              // Chat Message List
              Expanded(
                child: messages.isEmpty
                    ? const Center(
                  child: Text(
                    'Ask the AI Agent to perform actions in the app...',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _ChatBubble(message: message);
                  },
                ),
              ),

              // Loading Indicator
              if (state is AIAgentLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Agent is executing task...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

              // Input Bar
              _buildInputArea(state is AIAgentLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputArea(bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  hintText: 'Type your instruction...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _onSendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              color: Theme.of(context).primaryColor,
              onPressed: isLoading ? null : _onSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final AgentMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}