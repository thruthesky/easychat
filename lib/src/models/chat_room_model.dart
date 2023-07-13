import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String name;

  ChatRoomModel({
    required this.id,
    required this.name,
  });

  factory ChatRoomModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return ChatRoomModel.fromMap(map: documentSnapshot.data() as Map<String, dynamic>, id: documentSnapshot.id);
  }

  factory ChatRoomModel.fromMap({required Map<String, dynamic> map, required id}) {
    return ChatRoomModel(
      id: id,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'ChatRoomModel(id: $id, name: $name)';
}
