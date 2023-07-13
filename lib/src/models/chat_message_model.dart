import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String text;

  ChatMessageModel({
    required this.id,
    required this.text,
  });

  factory ChatMessageModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return ChatMessageModel.fromMap(map: documentSnapshot.data() as Map<String, dynamic>, id: documentSnapshot.id);
  }

  factory ChatMessageModel.fromMap({required Map<String, dynamic> map, required id}) {
    return ChatMessageModel(
      id: id,
      text: map['text'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  String toString() => 'ChatMessageModel(id: $id, text: $text)';
}
