import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class EasyUser {
  static EasyUser? _instance;
  static EasyUser get instance => _instance ??= EasyUser._();
  EasyUser._() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        userModel = null;
      } else {
        get(user.uid).then((user) {
          userModel = user;
        });
      }
    });
  }

  String get collectionName => UserModel.collectionName;

  get db => FirebaseFirestore.instance;

  /// Users collection reference
  CollectionReference get cols => db.collection(collectionName);

  /// Currently login user's uid
  String get uid => FirebaseAuth.instance.currentUser!.uid;

  /// User document reference of the currently login user
  DocumentReference get doc => cols.doc(uid);

  /// [_userCache] is a memory cache for [UserModel].
  ///
  /// Firestore 에서 한번 불러온 유저는 다시 불러오지 않는다. Offline DB 라서, 속도 향상은 크게 느끼지 못하지만, 접속을 아껴 비용을 절약한다.
  final Map<String, UserModel> _userCache = {};

  /// Current user model
  ///
  /// It will be initialized whenever the user is logged in.
  ///
  /// Note that, it has always updated data. But it's not reactive. This means,
  /// even if the user document is updated, this will not fire update event.
  /// Use [UserDoc] widget if you want to show the user document in real-time.
  ///
  /// 주의, 실시간 자동 업데이트를 하지 않는다. 실시간 자동 문서를 화면에 보여주어야 한다면
  /// [UserDoc] 위젯을 사용하면 된다.
  ///
  /// 사용자가 로그인 할 때 마다 초기화 된다. 다른 아이디로 로그인을 해도, 해당 사용자의 문서가
  /// 업데이트된다.
  UserModel? userModel;

  /// userModel 의 getter 로 null operator 가 강제 적용된 것이다. 즉, userModel 이 null 이면 에러가 발생한다.
  /// 실시간 업데이트된 정보가 필요하면, [UserDoc] 위젯을 사용하면 된다.
  UserModel get user => userModel!;

  /// Get user
  ///
  /// It does memory cache.
  /// If the user is already cached, it returns the cached value.
  /// Otherwise, it fetches from Firestore and returns the UserModel.
  /// If the user does not exist, it returns null.
  Future<UserModel?> get(String uid) async {
    /// 캐시되어져 있으면, 그 캐시된 값(UserModel)을 리턴
    if (_userCache.containsKey(uid)) return _userCache[uid];

    /// 아니면, Firestore 에서 불러와서 UserModel 을 만들어 리턴
    final u = await UserModel.get(uid);
    if (u == null) return null;
    _userCache[uid] = u;
    return _userCache[uid];
  }

  /// Sign out from Firebase Auth
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Create a user document under /users/{uid} for the login user with the Firebase Auth user data.
  ///
  /// If the user document already exists, it throws an exception.
  Future<void> create() async {
    if ((await doc.get()).exists) {
      throw Exception(EasyUserError.documentAlreadyExists);
    }

    final u = FirebaseAuth.instance.currentUser!;

    final model = UserModel(
      uid: u.uid,
      email: u.email,
      displayName: u.displayName,
      photoUrl: u.photoURL,
      createdAt: null,
    );
    userModel = await model.create();
    log('User document created.');
  }

  /// Login user's document update
  ///
  /// Update a user document under /users/{uid} for the login user.
  ///
  /// This automatically updates the [userModel] value.
  Future<void> update({
    String? name,
    String? displayName,
    String? photoUrl,
    bool? hasPhotoUrl,
    String? phoneNumber,
    String? email,
    String? field,
    dynamic value,
  }) async {
    if (userModel == null) {
      throw Exception(EasyUserError.notLoggedIn);
    }

    userModel = await userModel!.update(
      name: name,
      displayName: displayName,
      photoUrl: photoUrl,
      hasPhotoUrl: hasPhotoUrl,
      phoneNumber: phoneNumber,
      email: email,
      field: field,
      value: value,
    );

    log('User document updated.');
  }

  /// Upload a file (or an image) to Firebase Storage.
  /// 범용 업로드 함수이며, 모든 곳에서 사용하면 된다.
  ///
  /// [file] is the file to upload.
  ///
  ///
  /// It returns the download url of the uploaded file.
  ///
  /// [progress] is a callback function that is called whenever the upload progress is changed.
  ///
  /// [complete] is a callback function that is called when the upload is completed.
  ///
  /// [compressQuality] is the quality of the compress for the image before uploading.
  /// 중요, compresssion 을 하면 이미지 가로/세로가 자동 보정 된다. 따라서 업로드를 하는 경우, 꼭 사용해야 하는 옵션이다.
  /// 참고로 compression 은 기본 이미지 용량의 내용에 따라 달라 진다.
  /// 이 값이 22 이면, 10M 짜리 파일이 140Kb 로 작아진다.
  /// 이 값이 70 이면, 30M 짜리 파일이 1M 로 작아진다.
  /// 이 값이 80 이면, 10M 짜리 파일이 700Kb 로 작아진다. 80 이면 충분하다. 기본 값이다.
  /// 이 값이 0 이면, compress 를 하지 않는다.
  Future<String?> upload({
    required File file,
    Function(double)? progress,
    Function? complete,
    int compressQuality = 80,
  }) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child("easyuser/$uid/${file.path.split('/').last}");

    if (compressQuality > 0) {
      final xfile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.absolute.path}.compressed.jpg',
        quality: 80,
        // rotate: 180,
      );
      file = File(xfile!.path);
    }

    final uploadTask = fileRef.putFile(file);
    if (progress != null) {
      uploadTask.snapshotEvents.listen((event) {
        progress(event.bytesTransferred / event.totalBytes);
      });
    }

    /// 업로드 완료 할 때까지 기다림
    await uploadTask.whenComplete(() => complete?.call());
    final url = await fileRef.getDownloadURL();
    return url;
  }

  /// Delete the uploaded file in Firebase Storage by the url.
  ///
  /// If the url is null, it does nothing.
  Future<void> deleteUpload(String? url) async {
    if (url == null || url == '') return;
    final storageRef = FirebaseStorage.instance.refFromURL(url);
    await storageRef.delete();
    return;
  }

  Future<ImageSource?> chooseUploadSource(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Choose image from ...'),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Photo Gallery'),
                onTap: () async {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              ElevatedButton(
                child: const Text('Close BottomSheet'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
    return source;
  }
}
