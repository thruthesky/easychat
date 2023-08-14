import 'dart:developer';

import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Easy User Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /// 사용자 문서.
            UserDoc(
              builder: (user) {
                return Column(
                  children: [
                    Text("Hello, ${user.displayName}! (uid: ${user.uid})"),
                    Text(user.toString()),
                    ElevatedButton(
                      onPressed: EasyUser.instance.signOut,
                      child: const Text('Logout'),
                    ),
                    const SizedBox(height: 20),
                    UserAvatar(
                      user: user,
                      upload: true,
                      delete: true,
                      size: 120,
                    ),
                    const SizedBox(height: 20),
                    StatefulBuilder(builder: (context, setState) {
                      final nameController = TextEditingController(text: user.name);
                      return Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await EasyUser.instance.update(
                                name: nameController.text,
                              );
                              setState(() {});
                            },
                            child: const Text("Update"),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              },
              notLoggedInBuilder: () {
                final auth = FirebaseAuth.instance;
                final emailController = TextEditingController();
                final passwordController = TextEditingController();
                return Column(
                  children: [
                    const Text("Please, login"),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
                          child: const Text("Register"),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            await auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          },
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ],
                );
              },
              documentNotExistBuilder: () {
                const str =
                    "You are logged in, but your document does not exist. I am going to CREATE it !!";
                log(str);
                EasyUser.instance.create();
                return const Text(str);
              },
            ),
          ],
        ),
      ),
    );
  }
}
