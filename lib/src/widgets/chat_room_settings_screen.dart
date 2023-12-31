import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomSettingsScreen extends StatefulWidget {
  const ChatRoomSettingsScreen({
    super.key,
    required this.room,
    this.onUpdateRoomSetting, // Todo: For all updates
  });

  final ChatRoomModel room;
  final Function(ChatRoomModel updatedRoom)? onUpdateRoomSetting;

  @override
  State<ChatRoomSettingsScreen> createState() => _ChatRoomSettingsScreenState();
}

class _ChatRoomSettingsScreenState extends State<ChatRoomSettingsScreen> {
  ChatRoomModel? _roomState;

  @override
  Widget build(BuildContext context) {
    _roomState ??= widget.room;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          if (EasyChat.instance.isMaster(room: widget.room, uid: EasyChat.instance.uid) && _roomState!.group) ...[
            // TODO for confirmation, Only master can set [Open] and [Max Users]?
            ChatRoomOpenSettingListTile(
              room: _roomState!,
              onToggleOpen: (updatedRoom) {
                widget.onUpdateRoomSetting?.call(updatedRoom);
              },
            ),
            ChatRoomMaximumUsersSettingListTile(
              room: _roomState!,
              onUpdateMaximumNoOfUsers: (updatedRoom) {
                widget.onUpdateRoomSetting?.call(updatedRoom);
              },
            ),
            ChatRoomDefaultRoomNameSettingListTile(
              room: _roomState!,
              onUpdateChatRoomName: (updatedRoom) {
                widget.onUpdateRoomSetting?.call(updatedRoom);
              },
            ),
          ],
          // ! Still Ongoing
          // TODO Proceed here christian
          const ListTile(
            title: Text("Rename Chat Room"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("This will rename the chat room only on your view."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
