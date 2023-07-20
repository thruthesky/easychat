import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EasyChat {
  // The instance of the EasyChat singleton.
  static EasyChat? _instance;
  static EasyChat get instance => _instance ??= EasyChat._();

  // The private constructor for the EasyChat singleton.
  EasyChat._();

  String get uid => FirebaseAuth.instance.currentUser!.uid;
  bool get loggedIn => FirebaseAuth.instance.currentUser != null;

  CollectionReference get chatCol => FirebaseFirestore.instance.collection('easychat');
  CollectionReference messageCol(String roomId) => chatCol.doc(roomId).collection('messages');

  DocumentReference get myDoc => FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  DocumentReference roomDoc(String roomId) => chatCol.doc(roomId);

  late final String usersCollection;
  late final String displayNameField;
  late final String photoUrlField;

  final Map<String, UserModel> _userCache = {};

  Function(BuildContext, ChatRoomModel)? onChatRoomFileUpload;

  initialize({
    required String usersCollection,
    required String displayNameField,
    required String photoUrlField,
    Function(BuildContext, ChatRoomModel)? onChatRoomFileUpload,
  }) {
    this.usersCollection = usersCollection;
    this.displayNameField = displayNameField;
    this.photoUrlField = photoUrlField;
    this.onChatRoomFileUpload = onChatRoomFileUpload;
  }

  /// Get user
  ///
  /// It does memory cache.
  Future<UserModel?> getUser(String uid) async {
    if (_userCache.containsKey(uid)) return _userCache[uid];
    final snapshot = await FirebaseFirestore.instance.collection(usersCollection).doc(uid).get();
    if (!snapshot.exists) return null;
    final user = UserModel.fromDocumentSnapshot(snapshot);
    _userCache[uid] = user;
    return _userCache[uid];
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
  Future<ChatRoomModel> createChatRoom({
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
      'users': users,
    };

    // chat room id
    final roomId = isSingleChat ? getSingleChatRoomId(otherUserUid) : chatCol.doc().id;
    await chatCol.doc(roomId).set(roomData);

    // Create users (invite)
    // for (final uid in users) {
    //   final user = await getUser(uid);
    //   await userCol(roomId).doc(uid).set({
    //     'uid': uid,
    //     'displayName': user?.displayName ?? '',
    //     'photoUrl': user?.photoUrl ?? '',
    //   });
    // }

    return ChatRoomModel.fromMap(map: roomData, id: roomId);
  }

  Future<void> sendMessage({
    required ChatRoomModel room,
    String? text,
    String? imageUrl,
  }) async {
    await messageCol(room.id).add({
      if (text != null) 'text': text,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'senderUid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  /// Get other user uid
  ///
  /// ! It will throw an exception if there is no other user uid. So, use it only in 1:1 chat with minimum of 2 users in array.
  String getOtherUserUid(List<String> users) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return users.firstWhere((uid) => uid != currentUserUid);
  }

  /// Open Chat Room
  ///
  /// When the user taps on a chat room, this method is called to open the chat room.
  /// When the login user taps on a user NOT a chat room, then the user want to chat 1:1. That's why the user tap on the user.
  /// In this case, search if there is a chat room the method checks if the 1:1 chat room exists or not.
  showChatRoom({
    required BuildContext context,
    ChatRoomModel? room,
    UserModel? user,
  }) async {
    assert(room != null || user != null, "One of room or user must be not null");

    // If it is 1:1 chat, get the chat room. (or create if it does not exist)
    if (user != null) {
      room = await EasyChat.instance.getOrCreateSingleChatRoom(user.uid);
    }

    if (context.mounted) {
      showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return Scaffold(
            appBar: ChatRoomAppBar(room: room!),
            body: Column(
              children: [
                Expanded(
                  child: ChatMessagesListView(
                    room: room,
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatRoomMessageBox(room: room),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  /// File upload
  ///
  /// This method is invoked when user press button to upload a file.
  onPressedFileUploadIcon({required BuildContext context, required ChatRoomModel room}) async {
    if (onChatRoomFileUpload != null) {
      await onChatRoomFileUpload!(context, room);
      return;
    }
    final re =
        await showModalBottomSheet<ImageSource>(context: context, builder: (_) => ChatRoomFileUploadBottomSheet(room: room));
// print('re; $re');
    if (re == null) return; // double check
    final ImagePicker picker = ImagePicker();

// TODO support video later
    final XFile? image = await picker.pickImage(source: re);
    if (image == null) {
      print('image is null after pickImage()');
      return;
    }

    final name = sanitizeFilename(image.name, replacement: '-');

    final storageRef = FirebaseStorage.instance.ref();
// Create a child reference
// imagesRef now points to "images"
    final imagesRef = storageRef.child("easychat/${EasyChat.instance.uid}/$name");

// TODO compress image, adjust the portrait/landscape, etc.
    try {
      await imagesRef.putFile(File(image.path));
      final url = await imagesRef.getDownloadURL();
      EasyChat.instance.sendMessage(room: room, imageUrl: url);
    } on FirebaseException catch (e) {
      // TODO provide a way of displaying error emssage nicley

      print(e);
    }
  }
}
