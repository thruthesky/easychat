import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Chat Message List
///
///
class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    super.key,
    required this.room,
    required this.itemBuilder,
  });

  final ChatRoomModel room;
  final Widget Function(BuildContext, ChatMessageModel) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return const Text('chat   message   list');
  }
}
