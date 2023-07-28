import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';

class ChatRoomModel {
  final String id;
  final String name;
  final bool group;
  final bool open;
  final String master;
  final List<String> users;
  final List<String> moderators;
  final List<String> blockedUsers;
  final Map<String, int> noOfNewMessages;
  final int? maximumNoOfUsers;

  ChatRoomModel({
    required this.id,
    required this.name,
    required this.group,
    required this.open,
    required this.master,
    required this.users,
    required this.moderators,
    required this.blockedUsers,
    required this.noOfNewMessages,
    required this.maximumNoOfUsers,
  });

  factory ChatRoomModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return ChatRoomModel.fromMap(map: documentSnapshot.data() as Map<String, dynamic>, id: documentSnapshot.id);
  }

  factory ChatRoomModel.fromMap({required Map<String, dynamic> map, required id}) {
    return ChatRoomModel(
      id: id,
      name: map['name'] ?? '',
      group: map['group'],
      open: map['open'],
      master: map['master'],
      users: List<String>.from((map['users'] ?? [])),
      moderators: List<String>.from(map['moderators'] ?? []),
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
      noOfNewMessages: Map<String, int>.from(map['noOfNewMessages'] ?? {}),
      maximumNoOfUsers: map['maximumNoOfUsers'],
    );
  }

  update(Map<String, dynamic> updates) {
    return ChatRoomModel(
      id: id,
      name: updates['name'] ?? name,
      group: updates['group'] ?? group,
      open: updates['open'] ?? open,
      master: updates['master'] ?? master,
      users: List<String>.from((updates['users'] ?? users)),
      moderators: List<String>.from(updates['moderators'] ?? moderators),
      blockedUsers: List<String>.from(updates['blockedUsers'] ?? blockedUsers),
      noOfNewMessages: Map<String, int>.from(updates['noOfNewMessages'] ?? noOfNewMessages),
      maximumNoOfUsers: updates['maximumNoOfUsers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'open': open,
      'master': master,
      'users': users,
      'moderators': moderators,
      'blockedUsers': blockedUsers,
      'noOfNewMessages': noOfNewMessages,
      'maximumNoOfUsers': maximumNoOfUsers,
    };
  }

  @override
  String toString() => 'ChatRoomModel(id: $id, name: $name, group: $group, open: $open, master: $master, users: $users)';

  String get otherUserUid {
    assert(users.length == 2 && group == false, "This is not a single chat room");
    return EasyChat.instance.getOtherUserUid(users);
  }
}
