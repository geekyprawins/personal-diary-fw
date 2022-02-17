import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String? id;
  final String? userId;
  final String? title;
  final String? author;
  final Timestamp? entryPoint;
  final String? photoUrls;
  final String? entry;

  Diary({
    this.id,
    this.userId,
    this.title,
    this.author,
    this.entryPoint,
    this.photoUrls,
    this.entry,
  });

  factory Diary.fromDoc(QueryDocumentSnapshot doc) {
    return Diary(
      id: doc.id,
      userId: doc.get('user_id'),
      title: doc.get('title'),
      author: doc.get('author'),
      entryPoint: doc.get('entry_point'),
      photoUrls: doc.get('photo_list'),
      entry: doc.get('entry'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'author': author,
      'entry_point': entryPoint,
      'photo_list': photoUrls,
      'entry': entry,
    };
  }
}
