import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class ChatSettingsButton extends StatefulWidget {
  const ChatSettingsButton({
    super.key,
    required this.room,
    this.onToggleOpen,
  });

  final ChatRoomModel room;
  final Function(bool open)? onToggleOpen;

  @override
  State<ChatSettingsButton> createState() => _ChatSettingsButtonState();
}

class _ChatSettingsButtonState extends State<ChatSettingsButton> {
  ChatRoomModel? _roomState;

  @override
  Widget build(BuildContext context) {
    _roomState ??= widget.room;

    return TextButton(
      child: const Text('Settings'),
      onPressed: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) {
            return ChatRoomSettingsScreen(
              room: _roomState!,
              onToggleOpen: (open) {
                setState(() {
                  _roomState = _roomState!.update({
                    'open': open,
                  });
                });
                widget.onToggleOpen?.call(open);
              },
            );
          },
        );
      },
    );
  }
}
