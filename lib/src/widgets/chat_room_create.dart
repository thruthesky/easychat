import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomCreate extends StatefulWidget {
  const ChatRoomCreate({super.key, required this.success, required this.cancel, required this.error});

  final void Function(ChatRoomModel room) success;
  final void Function() cancel;
  final void Function() error;

  @override
  State<ChatRoomCreate> createState() => _ChatRoomCreateState();
}

class _ChatRoomCreateState extends State<ChatRoomCreate> {
  final name = TextEditingController();
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t('Create Chat Room')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              labelText: 'Chat Room Name',
            ),
          ),
          CheckboxListTile.adaptive(
            title: const Text('Open Chat'),
            value: isOpen,
            onChanged: (re) => setState(() {
              isOpen = re!;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.cancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final createdChatRoom = await EasyChat.instance.createChatRoom(
              roomName: name.text,
              isOpen: isOpen,
            );
            widget.success(createdChatRoom);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
