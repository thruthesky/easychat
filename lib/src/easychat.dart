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

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection(usersCollection).doc(uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromDocumentSnapshot(snapshot);
  }

  getSingleChatRoomId(String? otherUserUid) {
    if (otherUserUid == null) return null;
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final uids = [currentUserUid, otherUserUid];
    uids.sort();
    return uids.join('-');
  }

  Future<ChatRoomModel?> getSingleChatRoom(String uid) async {
    final roomId = getSingleChatRoomId(uid);
    final snapshot = await roomDoc(roomId).get();
    if (!snapshot.exists) return null;
    return ChatRoomModel.fromDocumentSnapshot(snapshot);
  }

  Future<ChatRoomModel> getOrCreateSingleChatRoom(String uid) async {
    final room = await EasyChat.instance.getSingleChatRoom(uid);
    if (room != null) return room;
    return await EasyChat.instance.createChatRoom(
      otherUserUid: uid,
    );
  }

  /// Create chat room
  ///
  /// If [otherUserUid] is set, it is a 1:1 chat. If it is unset, it's a group chat.
  createChatRoom({
    String? roomName,
    String? otherUserUid,
    bool isOpen = false,
  }) async {
    // prepare
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    bool isSingleChat = otherUserUid != null;
    bool isGroupChat = !isSingleChat;
    List<String> users = [myUid];
    if (isSingleChat) users.add(otherUserUid);

    // room data
    final roomData = {
      'master': myUid,
      'name': roomName ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'group': isGroupChat,
      'open': isOpen,
    };

    // chat room id
    final roomId = isSingleChat ? getSingleChatRoomId(otherUserUid) : chatCol.doc().id;
    await chatCol.doc(roomId).set(roomData);

    // promise.all() or transaction.
    // async/await..

    // Create users (invite)
    for (final uid in users) {
      final user = await getUser(uid);
      await userCol(roomId).doc(uid).set({
        'uid': uid,
        'displayName': user?.displayName ?? '',
        'photoUrl': user?.photoUrl ?? '',
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
