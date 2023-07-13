import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

/// Sample chat room screen to show how to use EasyChat.
/// This is for UI design purposes only and this is the the way how it should be used in real app design.
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.room});

  final ChatRoomModel room;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.room.name),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Show menu'),
                ),
              );
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              room: widget.room,
              itemBuilder: (context, message) {
                return ListTile(
                  title: Text(message.text),
                );
              },
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SafeArea(
              child: ChatRoomMessageBox(room: widget.room),
            ),
          ),
        ],
      ),
    );
  }
}
