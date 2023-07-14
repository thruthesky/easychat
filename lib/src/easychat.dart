import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EasyChat {
  // The instance of the EasyChat singleton.
  static EasyChat? _instance;
  static EasyChat get instance => _instance ??= EasyChat._();

  // The private constructor for the EasyChat singleton.
  EasyChat._();

  CollectionReference get chatCol => FirebaseFirestore.instance.collection('easychat');
  CollectionReference userCol(String roomId) => chatCol.doc(roomId).collection('users');
  CollectionReference messageCol(String roomId) => chatCol.doc(roomId).collection('messages');

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

  getSingleChatRoomId(String? otherUserUid) {
    if (otherUserUid == null) return null;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final uids = [currentUserUid, otherUserUid];
    uids.sort();
    return uids.join('-');
  }

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
