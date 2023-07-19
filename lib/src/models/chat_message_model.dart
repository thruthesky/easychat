import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String text;
  final String senderUid;
  final Timestamp? createdAt;
  final String? photoUrl;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.senderUid,
    required this.createdAt,
    required this.photoUrl,
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
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'senderUid': senderUid,
      'createdAt': createdAt,
      'photoUrl': photoUrl,
    };
  }

  @override
  String toString() => 'ChatMessageModel(id: $id, text: $text)';
}
