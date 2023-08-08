import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class TestUser {
  final String displayName;
  final String email;
  final String photoUrl;
  final String password = ",*13245a,";
  static int errorCount = 0;
  static int successCount = 0;
  String? uid;
  TestUser({required this.displayName, required this.email, required this.photoUrl});
}

class Test {
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
      log(e.toString());
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: user.password);
      return cred.user!;
    }
  }

  /// Test login
  static Future<User> login(TestUser user) async {
    //
    await FirebaseAuth.instance.signOut();

    // Wait until logout is complete or you may see firestore permission denied error.
    await Test.wait();

    final UserCredential cred =
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password);
    await Test.wait();
    return cred.user!;
  }

  /// wait
  static Future<void> wait() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  static test(bool cond, [String? reason]) async {
    if (cond) {
      TestUser.successCount++;
      log('--> OK [${TestUser.successCount}]: $reason');
    } else {
      TestUser.errorCount++;
      log('--> ERROR [${TestUser.errorCount}]: $reason');
    }
  }

  static start() {
    TestUser.successCount = 0;
    TestUser.errorCount = 0;
    log('------------------- TEST START --------------------');
  }

  static report() {
    log('------------------- TEST REPORT -------------------');
    log('Success: ${TestUser.successCount}');
    log('Error: ${TestUser.errorCount}');
  }
}

test(bool cond, [String? reason]) {
  Test.test(cond, reason);
}
