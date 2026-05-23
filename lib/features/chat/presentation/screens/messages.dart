import 'package:flutter/material.dart';
import 'package:pump/core/presentation/widgets/app_text_input.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/app_dimens.dart';
import '../../../../core/constants/app/app_strings.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widgets/custom_scaffold.dart';
import '../../domain/entity/message.dart';
import '../widgets/message_bubble.dart';

class MessagesScreen extends StatefulWidget {
  final String titleName;
  final List<Message>? initialMessages;

  const MessagesScreen({
    super.key,
    required this.titleName,
    this.initialMessages,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<Message> _messages;

  @override
  void initState() {
    super.initState();

    _messages =
        widget.initialMessages ??
        [
          Message(
            id: 'm1',
            text: 'Checkins burat',
            time: DateTime.now().subtract(const Duration(minutes: 12)),
            isMe: false,
          ),
        ];

    // ensure we start scrolled to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;

    final message = Message(
      id: 'm${_messages.length + 1}',
      text: text.trim(),
      time: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages.add(message);
    });

    _textController.clear();
    // allow UI to update, then scroll:
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollToBottom(animated: true),
    );
  }

  void _scrollToBottom({bool animated = false}) {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(position);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            UiUtils.addHorizontalSpaceS(),
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/images/jm.jpg"),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.titleName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  AppStrings.active,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen8),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                padding: EdgeInsets.symmetric(vertical: AppDimens.dimen12),
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg.isMe;

                  return Padding(
                    padding: EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                      left: isMe ? 64 : 8,
                      right: isMe ? 8 : 64,
                    ),
                    child: MessageBubble(message: msg),
                  );
                },
              ),
            ),
          ),

          // Text Input
          AppTextInput(
            controller: _textController,
            onSend: _sendMessage,
            onAttach: () {
              // implement attachment (image picker, camera, etc.)
            },
          ),
        ],
      ),
    );
  }
}
