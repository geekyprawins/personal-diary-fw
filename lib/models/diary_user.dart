import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryUser {
  final String? id;
  final String? uid;
  final String? displayName;
  final String? profession;
  final String? avatarUrl;

  DiaryUser({
    this.id,
    this.uid,
    this.displayName,
    this.profession,
    this.avatarUrl,
  });

  factory DiaryUser.fromDoc(QueryDocumentSnapshot data) {
    return DiaryUser(
      id: data.id,
      uid: data.get('uid'),
      displayName: data.get('display_name'),
      profession: data.get('profession'),
      avatarUrl: data.get('avatar_url'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar_url': avatarUrl,
      'profession': profession,
      'uid': uid,
      'display_name': displayName,
    };
  }
}
