import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final String name;
  final bool group;
  final bool open;
  final String master;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.group,
    required this.open,
    required this.master,
  });

  factory ChatRoomModel.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    return ChatRoomModel.fromMap(
        map: documentSnapshot.data() as Map<String, dynamic>,
        id: documentSnapshot.id);
  }

  factory ChatRoomModel.fromMap(
      {required Map<String, dynamic> map, required id}) {
    return ChatRoomModel(
      id: id,
      name: (map['name'] ?? '') as String,
      group: map['group'] as bool,
      open: map['open'] as bool,
      master: (map['master'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'open': open,
      'master': master,
    };
  }

  @override
  String toString() => 'ChatRoomModel(id: $id, name: $name)';
}
