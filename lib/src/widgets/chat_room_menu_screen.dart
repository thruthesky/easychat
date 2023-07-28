import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomMenuScreen extends StatefulWidget {
  const ChatRoomMenuScreen({
    super.key,
    required this.room,
    this.otherUser,
    this.onUpdateRoomSetting,
  });

  final ChatRoomModel room;
  final UserModel? otherUser;
  final Function(ChatRoomModel updatedRoom)? onUpdateRoomSetting;

  @override
  State<ChatRoomMenuScreen> createState() => _ChatRoomMenuScreenState();
}

class _ChatRoomMenuScreenState extends State<ChatRoomMenuScreen> {
  ChatRoomModel? _roomState;

  Stream<DocumentSnapshot<Object?>>? _roomStream;

  @override
  Widget build(BuildContext context) {
    // _roomState ??= widget.room;
    _roomStream = EasyChat.instance.roomDoc(widget.room.id).snapshots();

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: _roomStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: const Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Text('Loading...'),
          );
        }
        _roomState = ChatRoomModel.fromDocumentSnapshot(snapshot.data!);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat Room'),
          ),
          body: ListView(
            children: [
              if (_roomState!.group) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_roomState!.name),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(widget.otherUser!.displayName),
                ),
              ],
              if (!EasyChat.instance.isMaster(room: _roomState!, uid: EasyChat.instance.uid)) ...[
                LeaveButton(
                  room: _roomState!,
                ),
              ],
              InviteUserButton(
                room: _roomState!,
                onInvite: (invitedUserUid) {
                  setState(() {});
                },
              ),
              ChatSettingsButton(
                room: _roomState!,
                onToggleOpen: (updatedRoom) {
                  debugPrint('Managing State $updatedRoom');
                  widget.onUpdateRoomSetting?.call(updatedRoom);
                  setState(() {
                    _roomState = updatedRoom;
                    debugPrint('Chat Room Menu State open ${updatedRoom.open}');
                  });
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text('Members'),
                  ),
                  ChatRoomMembersListView(room: _roomState!),
                ],
              ),
            ],
          ),
        );
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Chat Room'),
    //   ),
    //   body: ListView(
    //     children: [
    //       if (_roomState!.group) ...[
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(_roomState!.name),
    //         ),
    //       ] else ...[
    //         Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Text(widget.otherUser!.displayName),
    //         ),
    //       ],
    //       if (!EasyChat.instance.isMaster(room: _roomState!, uid: EasyChat.instance.uid)) ...[
    //         LeaveButton(
    //           room: _roomState!,
    //         ),
    //       ],
    //       InviteUserButton(
    //         room: _roomState!,
    //         onInvite: (invitedUserUid) {
    //           setState(() {});
    //         },
    //       ),
    //       ChatSettingsButton(
    //         room: _roomState!,
    //         onToggleOpen: (open) {
    //           debugPrint('Managing State $open');
    //           widget.onToggleOpen?.call(open);
    //           setState(() {
    //             _roomState = _roomState!.update({
    //               'open': open,
    //             });
    //             debugPrint('Chat Room Menu State open $open');
    //           });
    //         },
    //       ),
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const Padding(
    //             padding: EdgeInsets.only(left: 16.0, right: 16.0),
    //             child: Text('Members'),
    //           ),
    //           ChatRoomMembersListView(room: _roomState!),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
