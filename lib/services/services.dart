import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_diary/models/diary_user.dart';

class DiaryService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser(
      String displayName, String uid, BuildContext context) async {
    DiaryUser diaryUser = DiaryUser(
      avatarUrl: 'https://picsum.photos/200/300',
      displayName: displayName,
      uid: uid,
    );

    userCollection.add(diaryUser.toMap());
    return;
  }

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return;
  }

  Future<void> updateUser(DiaryUser dUser, String displayName, String avatarUrl,
      BuildContext context) async {
    DiaryUser updatedUser = DiaryUser(
      uid: dUser.uid,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );

    userCollection.doc(dUser.id).update(updatedUser.toMap());
    return;
  }
}
