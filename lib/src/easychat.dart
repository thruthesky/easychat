import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';

class EasyChat {
  // The instance of the EasyChat singleton.
  static EasyChat? _instance;
  static EasyChat get instance => _instance ??= EasyChat._();

  // The private constructor for the EasyChat singleton.
  EasyChat._();

  CollectionReference get chatRoomsCol => FirebaseFirestore.instance.collection('easy-chat-rooms');
  CollectionReference get chatMessagesCol => FirebaseFirestore.instance.collection('easy-chat-messages');

  createChatRoom({required String name}) async {
    await chatRoomsCol.add({
      'name': name,
    });
  }

  sendMessage({
    required ChatRoomModel room,
    required String text,
  }) async {
    await chatMessagesCol.add({
      'roomId': room.id,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}