import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: FirebaseFirestore.instance.collection('easy-chat-rooms'),
      itemBuilder: (context, QueryDocumentSnapshot snapshot) {
        final data = Map<String, dynamic>.from(snapshot.data() as Map<String, dynamic>);
        return ListTile(title: Text(data['name']));
      },
    );
  }
}
