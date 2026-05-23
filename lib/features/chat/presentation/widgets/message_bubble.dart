import 'package:flutter/material.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../domain/entity/message.dart';

class _LocalColors {
  static const primary = Color(0xFFEC7216);
  static const background = Color(0xFF0E0E10);
  static const incomingBubble = Color(0xFF1F1F23);
  static const outgoingBubble = Color(0xFFEC7216);
  static const textOnPrimary = Colors.white;
  static const muted = Colors.white70;
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(AppDimens.radius8),
      topRight: const Radius.circular(AppDimens.radius8),
      bottomLeft: Radius.circular(isMe ? AppDimens.radius8 : 0),
      bottomRight: Radius.circular(isMe ? 0 : AppDimens.radius8),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe) UiUtils.addHorizontalSpaceS(),
        if (!isMe)
          const CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/jm.jpg"),
          ),
        if (!isMe) UiUtils.addHorizontalSpaceS(),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimens.padding10,
              horizontal: AppDimens.padding14,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? _LocalColors.outgoingBubble
                  : _LocalColors.incomingBubble,
              borderRadius: radius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isMe ? _LocalColors.textOnPrimary : Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.time),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    if (isMe) const SizedBox(width: 6),
                    if (isMe)
                      const Icon(Icons.check, size: 12, color: Colors.white70),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isMe) UiUtils.addHorizontalSpaceS(),
      ],
    );
  }

  static String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${time.day}/${time.month}/${time.year}';
  }
}
