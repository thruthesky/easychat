import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMessageBubble extends StatefulWidget {
  const ChatMessageBubble({
    super.key,
    required this.chatMessageDoc,
  });

  final ChatMessageModel chatMessageDoc;

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _showDateTime = false;
  @override
  Widget build(BuildContext context) {
    final isMyMessage = widget.chatMessageDoc.senderUid == FirebaseAuth.instance.currentUser!.uid;
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
    final user = EasyChat.instance.getUser(widget.chatMessageDoc.senderUid);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: bubbleMainAxisAlignment,
      children: [
        if (!isMyMessage) ...[
          FutureBuilder(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                  ),
                );
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
                          if (snapshot.connectionState == ConnectionState.waiting) return const Text('');
                          if (snapshot.hasData == false) return const Text('');
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showDateTime = !_showDateTime;
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
                          Text(widget.chatMessageDoc.text),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _showDateTime,
                  child:
                      Text(widget.chatMessageDoc.createdAt != null ? toAgoDate(widget.chatMessageDoc.createdAt!.toDate()) : ''),
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
    if (diff.inDays >= 2) {
      return date.toIso8601String();
    } else if (diff.inDays >= 1) {
      return '${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} ${diff.inSeconds == 1 ? "second" : "seconds"} ago';
    } else {
      return 'Just Now';
    }
  }
}
