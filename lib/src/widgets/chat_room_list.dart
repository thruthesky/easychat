import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomListController {
  late final ChatRoomListState state;
}

/// Chat room list
class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key, required this.controller});

  final ChatRoomListController controller;

  // final void Function(ChatRoomModel) onTap;

  @override
  State<ChatRoomList> createState() => ChatRoomListState();
}

class ChatRoomListState extends State<ChatRoomList> {
  @override
  void initState() {
    super.initState();
    widget.controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: EasyChat.instance.chatCol
          .where('users'), // FirebaseFirestore.instance.collection('easychat'),
      itemBuilder: (context, QueryDocumentSnapshot snapshot) {
        final room = ChatRoomModel.fromDocumentSnapshot(snapshot);
        return ListTile(
            title: Text(room.group
                ? room.name
                : 'TODO Get Other User ${room.otherUserUid}'),
            onTap: () => showChatRoom(room: room));
      },
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
    assert(
        room != null || user != null, "One of room or user must be not null");

    // If it is 1:1 chat, get the chat room. (or create if it does not exist)
    if (user != null) {
      room = await EasyChat.instance.getOrCreateSingleChatRoom(user.uid);
    }

    if (mounted) {
      showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return Scaffold(
            appBar: ChatRoomAppBar(room: room!),
            body: const Text("Chat Room"),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),

                /// TODO continue here ian
                /// check the firestore rules for creating messages.
                child: ChatRoomMessageBox(room: room),
              ),
            ),
          );
        },
      );
    }
  }
}

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
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: ChatRoomAppBarTitle(room: widget.room),
    );
  }
}

class ChatRoomAppBarTitle extends StatelessWidget {
  const ChatRoomAppBarTitle({
    super.key,
    required this.room,
  });

  final ChatRoomModel room;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EasyChat.instance.getUser(room.otherUserUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (snapshot.hasData == false) {
          return const Text('Error - no user');
        }

        final user = snapshot.data as UserModel;
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            const SizedBox(width: 8),
            Text(user.displayName),
          ],
        );
      },
    );
  }
}
