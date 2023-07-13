# EasyChat

* This package helps the flutter developers to rapidly build chat app.


# TODO

- See the Principle.
- Login is required to use this app. Meaning, this package does not provide login relational feature. the parent app must provide login and login is reuqired for using this package.
- Create chat room.
- Updating user's display name and photo url in chat room collection. Not indivisual chat message.



# Overview

## Principle of Design

- Easychat provides logic as much as possible. This means, the app must provide UI and hook the user event with the easychat logic.
  - In some case, easychat must provide ui like displaying the list of chat friend list or chat room and message list. But still easychaht provides a way to customise everything.

- Easychat also provide sample UI. So, developer can see the code, copy and customise it.

- Easychat throws exceptions when there are problems. It is the app's responsibility to catch and handle them.
- For sample UI widgets, it provides `sucess` and `error` handler.


## Features

- The one who creats the chat room is the mater manager of the chat.
- The master manager can set moderators.
- Moderators can
  - kick out chat members.
  - block chat members not to join again.
  - set password so other member may not join.

- `OpenChat`
  - A group chat which is searchable.
  - Anybody search chat room and join.

- `PrivateChat`
  - A group chat which is not searchable.



# Environment

* Firestore

# Features

* Chat room list
* 1:1 chat room & multi chat
* File upload api

# Setup

## Firestore Security Rules

* It uses the following collections
  * `/easy-chat-rooms` - chat room information.
  * `/easy-chat-messages` - chat message documents.

* Add the folling security rules.

```json
 ... security rules here ...
```


## Firebase settings

* Easychat package uses the same connection on your application. You can simply initialize firebase connection inside your application.




## Firestore Security Rules

* It uses the following collections
  * `/easy-chat-rooms` - chat room information.
  * `/easy-chat-messages` - chat message documents.

* Add the folling security rules.

```json
 ... security rules here ...
```


## Firebase settings

* Easychat package uses the same connection on your application. You can simply initialize firebase connection inside your application.


# Widgets and Logics

## Create a chat room

- To create a chat room, add a button and display `ChatRoomCreate` widget. You may copy the code from `ChatRoomCreate` and apply your own design.

```dart
class _ChatRoomListreenState extends State<ChatRoomListSreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Chat Room List'),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => ChatRoomCreate(
                  success: () => Navigator.of(context).pop(),
                  cancel: () => Navigator.of(context).pop(),
                  error: () => const ScaffoldMessenger(child: Text('Error creating chat room')),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
```

- You need to create only one screen to use the easychat.


```dart
Scafolld(
  appBar: AppBar(
    title:
  )
)
```





## Additional information

- Please create issues.


## How to test & UI work Chat room screen

```dart

    Timer.run(() {
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatScreen()));

// How to test a chat room screen:
      Navigator.of(context).push(
        MaterialPageRoute(
          /// Open the chat room screen with a chat room for the UI work and testing.
          builder: (_) => ChatRoomScreen(
            /// Get the chat room from the firestore and pass it to the screen for the test.
            room: ChatRoomModel.fromMap(
              id: 'mFpHRSZLCemCfC2B9Y3B',
              map: {
                'name': 'Test Chat Room',
              },
            ),
          ),
        ),
      );
    });
```


# Firebase

## Security Rules

- Run firestore emulator like below and test the security rules.

```sh
% firebase emulators:start --only firestore
```