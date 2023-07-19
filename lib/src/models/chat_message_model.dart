import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final String senderUid;
  final Timestamp? createdAt;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.senderUid,
    required this.createdAt,
  });

  factory ChatMessageModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return ChatMessageModel.fromMap(map: documentSnapshot.data() as Map<String, dynamic>, id: documentSnapshot.id);
  }

  factory ChatMessageModel.fromMap({required Map<String, dynamic> map, required id}) {
    return ChatMessageModel(
      id: id,
      text: map['text'],
      senderUid: map['senderUid'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'senderUid': senderUid,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() => 'ChatMessageModel(id: $id, text: $text)';
}
