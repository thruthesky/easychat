import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatRoomSettingsScreen extends StatefulWidget {
  const ChatRoomSettingsScreen({
    super.key,
    required this.room,
    this.onToggleOpen,
  });

  final ChatRoomModel room;
  final Function(bool open)? onToggleOpen;

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
          ListTile(
            title: const Text("Open Chat Room"),
            subtitle: const Text("Anyone can join or invite users."),
            trailing: Switch(
              value: _roomState!.open,
              onChanged: (value) {
                debugPrint('Value $value');
                EasyChat.instance.updateSetting(
                  room: _roomState!,
                  setting: 'open',
                  value: value,
                );
                setState(() {
                  _roomState = _roomState!.update({
                    'open': value,
                  });
                });
                widget.onToggleOpen?.call(value);
              },
            ),
          )
        ],
      ),
    );
  }
}
