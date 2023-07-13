import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomMessageBox extends StatefulWidget {
  const ChatRoomMessageBox({
    super.key,
    required this.room,
  });

  final ChatRoomModel room;

  @override
  State<StatefulWidget> createState() => _ChatRoomMessageBoxState();
}

class _ChatRoomMessageBoxState extends State<ChatRoomMessageBox> {
  final TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
        Expanded(
          child: TextField(
            controller: message,
            decoration: const InputDecoration(hintText: 'Message', border: InputBorder.none),
          ),
        ),
        IconButton(
          onPressed: () async {
            await EasyChat.instance.sendMessage(
              room: widget.room,
              text: message.text,
            );
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}
