import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatRoomMaximumUsersSettingListTile extends StatefulWidget {
  const ChatRoomMaximumUsersSettingListTile({
    super.key,
    required this.room,
    this.onUpdateMaximumNoOfUsers,
  });

  final ChatRoomModel room;
  final Function(ChatRoomModel updatedRoom)? onUpdateMaximumNoOfUsers;

  @override
  State<ChatRoomMaximumUsersSettingListTile> createState() => _ChatRoomMaximumUsersSettingListTileState();
}

class _ChatRoomMaximumUsersSettingListTileState extends State<ChatRoomMaximumUsersSettingListTile> {
  ChatRoomModel? _roomState;
  final maxNumberOfUsers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _roomState ??= widget.room;
    maxNumberOfUsers.text = "${_roomState?.maximumNoOfUsers ?? ''}";
    return ListTile(
      title: const Text("Maximum Number of Users"),
      subtitle: TextFormField(
        controller: maxNumberOfUsers,
        // keyboardType: TextInputType.number,
        // TODO | question, do we have better UI for inputing integer? like better keyboard
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(hintText: 'Enter the limit number of user who can join.'),
        onFieldSubmitted: (value) async {
          debugPrint('Submitting Field $value');
          _roomState = await EasyChat.instance.updateRoomSetting(
              room: _roomState!, setting: 'maximumNoOfUsers', value: value.isNotEmpty ? int.parse(value) : null);
          if (mounted) setState(() {});
          widget.onUpdateMaximumNoOfUsers?.call(_roomState!);
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    maxNumberOfUsers.dispose();
    super.dispose();
  }
}
