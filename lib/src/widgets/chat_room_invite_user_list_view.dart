import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class InviteUserListView extends StatefulWidget {
  const InviteUserListView({
    super.key,
    required this.room,
    this.onInvite,
  });

  final ChatRoomModel room;
  final Function(String invitedUserUid)? onInvite;

  @override
  State<InviteUserListView> createState() => _InviteUserListViewState();
}

class _InviteUserListViewState extends State<InviteUserListView> {
  ChatRoomModel? _roomState;
  @override
  Widget build(BuildContext context) {
    _roomState ??= widget.room;
    final query = FirebaseFirestore.instance
        .collection(EasyChat.instance.usersCollection)
        .where(FieldPath.documentId, whereNotIn: _roomState!.users.take(10)); // Error message says limit is 10
    return FirestoreListView(
      query: query,
      itemBuilder: (context, snapshot) {
        // TODO how to remove blinking
        final user = UserModel.fromDocumentSnapshot(snapshot);
        if (_roomState!.users.contains(user.uid)) {
          return const SizedBox();
        } else {
          return ListTile(
            title: Text(user.displayName),
            subtitle: Text(user.uid),
            leading: user.photoUrl.isEmpty
                ? null
                : CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
            onTap: () async {
              _roomState = await EasyChat.instance.inviteUser(room: _roomState!, userUid: user.uid);
              if (mounted) setState(() {});
              widget.onInvite?.call(user.uid);
            },
          );
        }
      },
    );
  }
}
