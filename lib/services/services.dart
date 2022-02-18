import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/models/diary_user.dart';

class DiaryService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference diaryCollection =
      FirebaseFirestore.instance.collection('diaries');

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

  // filter selected date's diary
  Future<List<Diary>> getSameDateDiaries(DateTime first, String userId) {
    return diaryCollection
        .where(
          'entry_point',
          isGreaterThanOrEqualTo: Timestamp.fromDate(first).toDate(),
        )
        .where(
          'entry_point',
          isLessThan:
              Timestamp.fromDate(first.add(const Duration(days: 1))).toDate(),
        )
        .where(
          'user_id',
          isEqualTo: userId,
        )
        .get()
        .then((value) {
      print(value.docs.length);
      return value.docs.map((e) {
        return Diary.fromDoc(e);
      }).toList();
    });
  }

  Future<List<Diary>> getLatestDiaries(String uid) {
    return diaryCollection
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_point', descending: true)
        .get()
        .then((value) {
      return value.docs.map((e) {
        return Diary.fromDoc(e);
      }).toList();
    });
  }

  Future<List<Diary>> getEarliestDiaries(String uid) {
    return diaryCollection
        .where('user_id', isEqualTo: uid)
        .orderBy('entry_point', descending: false)
        .get()
        .then((value) {
      return value.docs.map((e) {
        return Diary.fromDoc(e);
      }).toList();
    });
  }
}
