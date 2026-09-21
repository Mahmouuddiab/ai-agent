enum MessageSender { user, agent, tool }

class AgentMessage {
  final String text;
  final MessageSender sender;

  const AgentMessage({
    required this.text,
    required this.sender,
  });
}