import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.user});
  final UserModel? user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.user != null) {
        showChatRoom(user: widget.user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Easy Chat'),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => ChatRoomCreate(
                  success: () => Navigator.of(context).pop(),
                  cancel: () => Navigator.of(context).pop(),
                  error: () => const ScaffoldMessenger(child: Text('Error creating chat room')),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ChatRoomList(onTap: (room) => showChatRoom(room: room)),
    );
  }

  /// Open Chat Room
  ///
  /// When the user taps on a chat room, this method is called to open the chat room.
  /// When the login user taps on a user NOT a chat room, then the user want to chat 1:1. That's why the user tap on the user.
  /// In this case, search if there is a chat room the method checks if the 1:1 chat room exists or not.
  showChatRoom({
    ChatRoomModel? room,
    UserModel? user,
  }) async {
    assert(room != null || user != null, "One of room or user must be not null");

    if (room == null) {
      // If 1:1 chat room exists, then enter the chat room.
      EasyChat.instance.createChatRoom(name: 'name');
    }
    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(room!.name),
          ),
          body: const Text("Chat Room"),
        );
      },
    );
  }
}
