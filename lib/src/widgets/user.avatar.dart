import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:image_picker/image_picker.dart';

/// UserAvatar
///
/// Displays the user's avatar.
///
/// [badgeNumber] is the number of notifications.
///
/// [upload] if [upload] is set to true, then it displays the camera upload
/// button and does the upload.
///
/// [delete] is the callback function that is being called when the user taps the delete button.
///
/// Note, that this avatar widget uses the [AdvancedAvatar] widget from
/// the [flutter_advanced_avatar](https://pub.dev/packages/flutter_advanced_avatar) package.
/// See the examples from the github: https://github.com/alex-melnyk/flutter_advanced_avatar/blob/master/example/lib/main.dart
class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
    required this.user,
    this.size = 100,
    this.radius = 20,
    this.badgeNumber,
    this.upload = false,
    this.delete = false,
    this.uploadStrokeWidth = 6,
  });

  final UserModel user;
  final double radius;
  final double size;
  final int? badgeNumber;
  final bool upload;
  final bool delete;
  final double uploadStrokeWidth;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  double? progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.upload == false) return;

        final source = await EasyUser.instance.chooseUploadSource(context);
        if (source == null) return;
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: source);

        if (image == null) return;

        final file = File(image.path);
        final url = await EasyUser.instance.upload(
          file: file,
          progress: (p) => setState(() => progress = p),
          complete: () => setState(() => progress = null),
          compressQuality: 70,
        );

        final oldUrl = EasyUser.instance.user.photoUrl;
        await EasyUser.instance.update(
          photoUrl: url,
        );
        await EasyUser.instance.deleteUpload(oldUrl);
      },
      child: Container(
        // color: Colors.blue,
        child: Stack(
          children: [
            AdvancedAvatar(
              size: widget.size,
              // statusSize: 16,
              // statusColor: Colors.green,
              name: widget.user.displayName ?? widget.user.email ?? widget.user.uid,
              image: widget.user.photoUrl == null || widget.user.photoUrl!.isEmpty
                  ? null
                  : CachedNetworkImageProvider(widget.user.photoUrl!),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 16.0,
                  ),
                ],
              ),
              children: [
                if (widget.badgeNumber != null)
                  AlignCircular(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 0.5,
                        ),
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.badgeNumber.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            uploadProgressIndicator(),
            if (widget.upload)
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey.shade800,
                  size: 32,
                ),
              ),
            if (widget.delete && widget.user.photoUrl != null && widget.user.photoUrl!.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    onPressed: () async {
                      await EasyUser.instance.deleteUpload(EasyUser.instance.user.photoUrl);
                      await EasyUser.instance.update(
                        field: 'photoUrl',
                        value: FieldValue.delete(),
                      );
                    },
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.grey.shade600,
                      size: 30,
                    )),
              ),
          ],
        ),
      ),
    );
  }

  uploadProgressIndicator() {
    if (progress == null || progress == 0) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: widget.uploadStrokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          value: progress,
        ),
      ),
    );
  }
}
