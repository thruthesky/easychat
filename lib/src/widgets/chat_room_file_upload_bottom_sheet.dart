import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomFileUploadBottomSheet extends StatefulWidget {
  const ChatRoomFileUploadBottomSheet({super.key, required this.room});

  final ChatRoomModel room;

  @override
  State<ChatRoomFileUploadBottomSheet> createState() => _ChatRoomFileUploadBottomSheetState();
}

class _ChatRoomFileUploadBottomSheetState extends State<ChatRoomFileUploadBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Theme.of(context).canvasColor,
      child: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Choose a file/image from'),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Photo gallery'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
