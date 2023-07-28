import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({
    super.key,
    required this.room,
  });

  final ChatRoomModel room;

  @override
  createState() => ChatRoomAppBarState();

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}

class ChatRoomAppBarState extends State<ChatRoomAppBar> {
  ChatRoomModel? _roomState;

  @override
  Widget build(BuildContext context) {
    _roomState ??= widget.room;
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: ChatRoomAppBarTitle(room: _roomState!),
      actions: [
        ChatRoomMenuButton(
          room: widget.room,
          onUpdateRoomSetting: (updatedRoom) {
            setState(() {
              _roomState = updatedRoom;
            });
          },
        ),
      ],
    );
  }
}
