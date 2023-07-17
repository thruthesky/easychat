import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class EasyChat {
  // The instance of the EasyChat singleton.
  static EasyChat? _instance;
  static EasyChat get instance => _instance ??= EasyChat._();

  // The private constructor for the EasyChat singleton.
  EasyChat._();

  CollectionReference get chatCol =>
      FirebaseFirestore.instance.collection('easychat');
  CollectionReference userCol(String roomId) =>
      chatCol.doc(roomId).collection('users');
  CollectionReference messageCol(String roomId) =>
      chatCol.doc(roomId).collection('messages');

  DocumentReference roomDoc(String roomId) => chatCol.doc(roomId);

  late final String usersCollection;
  late final String displayNameField;
  late final String photoUrlField;

  initialize({
    required String usersCollection,
    required String displayNameField,
    required String photoUrlField,
  }) {
    this.usersCollection = usersCollection;
    this.displayNameField = displayNameField;
    this.photoUrlField = photoUrlField;
  }

  static getSingleChatRoomId(String? otherUserUid) {
    if (otherUserUid == null) return null;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final uids = [currentUserUid, otherUserUid];
    uids.sort();
    return uids.join('-');
  }

  // TODO For confirmation separate 1on1 creation of room from group chat creation

  /// Create chat room
  ///
  /// If [otherUserUid] is set, it is a 1:1 chat.
  /// If [userUids] is set, it is a group chat.
  createChatRoom({
    String? name,
    String? otherUserUid,
    List<String>? userUids,
  }) async {
    final roomId = getSingleChatRoomId(otherUserUid);
    await chatCol.doc(roomId).set({
      'master': FirebaseAuth.instance.currentUser!.uid,
      'name': name ?? '',
    });

    if (userUids == null) {
      userUids = [otherUserUid!, FirebaseAuth.instance.currentUser!.uid];
    } else {
      userUids.add(FirebaseAuth.instance.currentUser!.uid);
    }

    for (final userUid in userUids) {
      await userCol(roomId).doc(userUid).set({
        'master': FirebaseAuth.instance.currentUser!.uid,
        'name': name ?? '',
      });
    }
  }

  createGroupChatRoom({
    String? name,
    List<String>? userUids,
  }) async {
    await chatCol.add({
      'master': FirebaseAuth.instance.currentUser!.uid,
      'name': name ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'group': true,
      'open': false,
    }).then((value) {
      debugPrint("value: ${value.id}");
    });
  }

  create1on1ChatRoom({
    String? otherUserUid,
  }) async {
    final String roomId = getSingleChatRoomId(otherUserUid);
    final doc = await chatCol.doc(roomId).get();
    if (!doc.exists) {
      await chatCol.doc(roomId).set({
        'master': FirebaseAuth.instance.currentUser!.uid,
        'name': '', // TODO I think name should be optional in 1o1 chat
        'createdAt': FieldValue.serverTimestamp(),
        'group': false,
        'open': false,
      });
      userCol(roomId).doc(FirebaseAuth.instance.currentUser!.uid).set({
        'displayName': FirebaseAuth.instance.currentUser!.displayName,
        'email': FirebaseAuth.instance.currentUser!.email,
        'photoUrl': FirebaseAuth.instance.currentUser!.photoURL,
      });
      userCol(roomId).doc(otherUserUid).set({
        'displayName': '',
        // TODO get other user details
      });
    }
  }

  sendMessage({
    required ChatRoomModel room,
    required String text,
  }) async {
    await messageCol(room.id).add({
      'roomId': room.id,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'master': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
