class Message {
  final String id;
  final String text;
  final DateTime time;
  final bool isMe;
  final String? avatarUrl;
  final String? imageUrl;

  Message({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.avatarUrl,
    this.imageUrl,
  });
}
