import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';

import 'delete_entry_dialog.dart';
import 'inner_list_card.dart';

class DiariesListView extends StatelessWidget {
  DiariesListView({this.selectedDate});

  final DateTime? selectedDate;
  final diaries = FirebaseFirestore.instance.collection('diaries');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: diaries.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        var filteredList = snapshot.data!.docs.map((diary) {
          return Diary.fromDoc(diary);
        }).where((element) {
          return (element.userId == FirebaseAuth.instance.currentUser!.uid);
        }).toList();

        return Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    Diary diary = filteredList[index];
                    return Card(
                      elevation: 4,
                      child: InnerListCard(
                          selectedDate: selectedDate!,
                          diary: diary,
                          diaries: diaries),
                    );
                  },
                  itemCount: filteredList.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
