import 'package:easychat/easychat.dart';
import 'package:example/test/test.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    super.initState();

    initTest();
  }

  initTest() async {
    for (final user in Test.users) {
      if (user.uid != null) continue;
      final login = await Test.loginOrRegister(user);
      user.uid = login.uid;
    }

    for (var e in Test.users) {
      print(e.uid);
    }

    testNoOfNewMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EasyChat Test')),
      body: Column(
        children: [
          const Text('''How To TEST
1. Wait until the users are loaded. On the [initState], it will load apple, banana, cherry, and durian user uids.
2. Press run all tests to test all the features.
3. Or press test button one by one to see the result of each test.
'''),
          const Divider(),
          StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (_, snapshot) {
                final user = snapshot.data;
                if (user == null) {
                  return const Text('Logged out');
                }
                return Text('User: ${user.email ?? 'null'}');
              }),
          Wrap(
            children: [
              for (final user in Test.users)
                ElevatedButton(
                  onPressed: () async {
                    final login = await Test.loginOrRegister(user);
                    print(login);
                  },
                  child: Text('Login w/ ${user.displayName}'),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Run all tests', style: TextStyle(color: Colors.red.shade800)),
          ),
          ElevatedButton(
            onPressed: testNoOfNewMessage,
            child: const Text('TEST noOfNewMessage - Apple & Banana'),
          ),
        ],
      ),
    );
  }

  testNoOfNewMessage() async {
    await FirebaseAuth.instance.signOut();

    // Wait until logout is complete or you may see firestore permission denied error.
    await Future.delayed(const Duration(milliseconds: 200));

    // Sign in with apple with its password
    await Test.loginOrRegister(Test.apple);

    // Get the room
    final room = await EasyChat.instance.getOrCreateSingleChatRoom(Test.banana.uid);

    await EasyChat.instance.roomRef(room.id).update({'noOfNewMessages': {}});

    // Send a message with the room information.
    await EasyChat.instance.sendMessage(
      room: room,
      text: 'yo',
    );

    // Get the no of new messages.
    final roomAfter = await EasyChat.instance.getOrCreateSingleChatRoom(Test.banana.uid);

    Test.ok(roomAfter.noOfNewMessages[Test.banana.uid] == 2, "noOfNewMessages of Banana must be 1");

    //     expect(roomAfter.noOfNewMessages[Test.banana.uid], 2, reason: "noOfNewMessages of Banana must be 1");
  }
}
