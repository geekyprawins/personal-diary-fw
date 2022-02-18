import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary_user.dart';
import 'build_profile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final usersListStream = snapshot.data!.docs.map((docs) {
          return DiaryUser.fromDoc(docs);
        }).where((element) {
          return (element.uid == FirebaseAuth.instance.currentUser!.uid);
        }).toList();

        DiaryUser currUser = usersListStream[0];

        return buildProfile(currUser, context);
      },
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
    );
  }
}
