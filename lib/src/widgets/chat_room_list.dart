import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key, required this.onTap});

  final void Function(ChatRoomModel) onTap;

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirebaseFirestore.instance.collection('easychat'),
      itemBuilder: (context, QueryDocumentSnapshot snapshot) {
        final room = ChatRoomModel.fromDocumentSnapshot(snapshot);
        return ListTile(
            title: Text(room.group ? room.name : ''),
            onTap: () => widget.onTap(room));
      },
    );
  }
}
