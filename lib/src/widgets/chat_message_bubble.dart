import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.chatMessage,
  });

  final ChatMessageModel chatMessage;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  @override
  Widget build(BuildContext context) {
    final isMyMessage = widget.chatMessage.senderUid == FirebaseAuth.instance.currentUser!.uid;
    bool showDateTime = false;
    late final MainAxisAlignment bubbleMainAxisAlignment;
    late final CrossAxisAlignment bubbleCrossAxisAlignment;
    late final Color colorOfBubble;
    late final BorderRadius borderRadiusOfBubble;
    const radiusOfCorners = Radius.circular(16);
    const borderRadiusOfBubbleOfOtherUser = BorderRadius.only(
      topRight: radiusOfCorners,
      bottomLeft: radiusOfCorners,
      bottomRight: radiusOfCorners,
    );
    const borderRadiusOfBubbleOfCurrentUser = BorderRadius.only(
      topLeft: radiusOfCorners,
      bottomLeft: radiusOfCorners,
      bottomRight: radiusOfCorners,
    );
    // To set the bubble details
    if (isMyMessage) {
      colorOfBubble = Theme.of(context).colorScheme.primaryContainer;
      bubbleMainAxisAlignment = MainAxisAlignment.end;
      bubbleCrossAxisAlignment = CrossAxisAlignment.end;
      borderRadiusOfBubble = borderRadiusOfBubbleOfCurrentUser;
    } else {
      colorOfBubble = Theme.of(context).colorScheme.tertiaryContainer;
      bubbleMainAxisAlignment = MainAxisAlignment.start;
      bubbleCrossAxisAlignment = CrossAxisAlignment.start;
      borderRadiusOfBubble = borderRadiusOfBubbleOfOtherUser;
    }
    final user = EasyChat.instance.getUser(widget.chatMessage.senderUid);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: bubbleMainAxisAlignment,
      children: [
        if (!isMyMessage) ...[
          FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              }
              if (snapshot.hasData == false) {
                return const Text('Error - no user');
              }
              final user = snapshot.data as UserModel;
              return Row(
                children: [
                  user.photoUrl.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                          ),
                        ),
                ],
              );
            },
          ),
        ],
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: bubbleCrossAxisAlignment,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMyMessage) ...[
                      FutureBuilder(
                        future: user,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text('Loading...');
                          }
                          if (snapshot.hasData == false) {
                            return const Text('Error - no user');
                          }
                          final user = snapshot.data as UserModel;
                          return user.photoUrl.isEmpty
                              ? const SizedBox()
                              : Text(
                                  user.displayName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                );
                        },
                      ),
                    ],
                  ],
                ),
                if (widget.chatMessage.text != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showDateTime = !showDateTime;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorOfBubble,
                        borderRadius: borderRadiusOfBubble,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.chatMessage.text!),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.chatMessage.imageUrl != null) Image.network(widget.chatMessage.imageUrl!),
                Visibility(
                  visible: showDateTime,
                  child: Text(widget.chatMessage.createdAt != null ? toAgoDate(widget.chatMessage.createdAt!.toDate()) : ''),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  toAgoDate(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago';
    } else {
      return 'Just Now';
    }
  }
}
