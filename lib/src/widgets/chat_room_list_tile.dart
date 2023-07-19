import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomListTile extends StatelessWidget {
  const ChatRoomListTile({super.key, required this.room});
  final ChatRoomModel room;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: ChatRoomListTileName(room: room), onTap: () => EasyChat.instance.showChatRoom(context: context, room: room));
  }
}
