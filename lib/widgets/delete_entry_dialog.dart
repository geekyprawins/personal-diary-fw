import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/screens/main_page.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.diaries,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Map<String, dynamic>> diaries;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Delete entry ?',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: const Text(
        "Are you sure you want to delete the entry?\nThis action cannot be reversed!",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            diaries.doc(diary.id).delete().then((value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const MainPage();
                },
              ));
            });
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
