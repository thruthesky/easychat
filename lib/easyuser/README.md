# EasyUser

* Easyuser package helps managing user account in Firebase.


## Setup


### Storage Security Rules

* Add the following security rules on storage.

```ts
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if false;
    }
    match /easyuser/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

## User document

* The user document is stored on firestore as `/users/{uid}`

* How to create user document. See `EasyUser::create`.

* To update the user document direcly, you can use below. But it is not recommended. Instead, use `EasyUser.instance.update(field: xxx, value: xxx)`

```dart
await EasyUser.instance.doc.update({
    'photoUrl': FieldValue.delete(),
});
```


## Admin

* Admin can be set as the `security rules`.

## Upload

* All the upload of files and images are handled in easy user package.
* Images are stored in `/users/{uid}/...`






## Widgets

### UserDoc

* One of the best widgets that you can use all the time is `UserDoc`. It has three builders.
  * `builder` will build widgets if the user has logged in and has user document.
  * `documentNotExistBuilder` will build a widget. You may return an empty widget while create the user's document. Then, it the `builder` will be called and you can display the widget for login.
  * `notLoggedBuilder` will build widgets for not logged in users. You can registeration or login widgets.

```dart
UserDoc(
  builder: (user, doc) {
    return Column(
      children: [
        Text("Hello, ${doc.displayName}! (uid: ${user.uid})"),
        Text(doc.toString()),
        ElevatedButton(
            onPressed: EasyUser.instance.signOut, child: const Text('Logout'))
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
```