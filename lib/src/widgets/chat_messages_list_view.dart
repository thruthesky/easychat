import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easychat/easychat.dart';

class ChatMessagesListView extends StatefulWidget {
  const ChatMessagesListView({super.key, required this.room});

  final ChatRoomModel room;

  @override
  State<ChatMessagesListView> createState() => _ChatMessagesViewState();
}

class _ChatMessagesViewState extends State<ChatMessagesListView> {
  @override
  Widget build(BuildContext context) {
    final query = EasyChat.instance.messageCol(widget.room.id).orderBy('createdAt', descending: true);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FirestoreListView(
        reverse: true,
        query: query,
        itemBuilder: (BuildContext context, QueryDocumentSnapshot<dynamic> doc) {
          return ChatBubble(chatMessageDoc: ChatMessageModel.fromDocumentSnapshot(doc));
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint(error.toString());
          return Text(error.toString());
        },
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.chatMessageDoc,
  });

  final ChatMessageModel chatMessageDoc;

  @override
  Widget build(BuildContext context) {
    final isMyMessage = chatMessageDoc.senderUid == FirebaseAuth.instance.currentUser!.uid;
    late final MainAxisAlignment bubbleAlignment;
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
      bubbleAlignment = MainAxisAlignment.end;
      borderRadiusOfBubble = borderRadiusOfBubbleOfCurrentUser;
    } else {
      colorOfBubble = Theme.of(context).colorScheme.tertiaryContainer;
      bubbleAlignment = MainAxisAlignment.start;
      borderRadiusOfBubble = borderRadiusOfBubbleOfOtherUser;
    }
    final user = EasyChat.instance.getUser(chatMessageDoc.senderUid);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: bubbleAlignment,
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
                    Text("From: ${chatMessageDoc.senderUid}"),
                    Text("Text: ${chatMessageDoc.text}"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
