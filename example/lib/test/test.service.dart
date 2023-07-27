import 'package:firebase_auth/firebase_auth.dart';

class TestUser {
  final String displayName;
  final String email;
  final String photoUrl;
  final String password = ",*13245a,";
  String? uid;
  TestUser({required this.displayName, required this.email, required this.photoUrl});
}

class Test {
  static const String test = 'test';
  static List<TestUser> users = [
    TestUser(displayName: 'Apple', email: 'apple@test-user.com', photoUrl: 'https://picsum.photos/id/1/200/200'),
    TestUser(displayName: 'Banana', email: 'banana@test-user.com', photoUrl: 'https://picsum.photos/id/1/200/200'),
    TestUser(displayName: 'Cherry', email: 'cherry@test-user.com', photoUrl: 'https://picsum.photos/id/1/200/200'),
    TestUser(displayName: 'Durian', email: 'durian@test-user.com', photoUrl: 'https://picsum.photos/id/1/200/200'),
  ];
  static get apple => users[0];
  static get banana => users[1];
  static get cherry => users[2];
  static get durian => users[3];

  static Future<User> loginOrRegister(TestUser user) async {
    try {
      final UserCredential cred =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password);
      return cred.user!;
    } catch (e) {
      print(e);
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
      return cred.user!;
    }
  }

  static ok(bool cond, [String? reason]) async {
    if (cond) {
      print('--> OK');
    } else {
      print('--> ERROR: $reason');
    }
  }
}
