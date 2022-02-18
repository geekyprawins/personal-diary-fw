import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';
import 'package:personal_diary/widgets/write_diary_dialog.dart';
import 'package:provider/provider.dart';

import 'delete_entry_dialog.dart';
import 'inner_list_card.dart';

class DiariesListView extends StatefulWidget {
  DiariesListView({this.selectedDate, required this.listOfDiaries});

  final DateTime? selectedDate;
  final List<Diary> listOfDiaries;

  @override
  State<DiariesListView> createState() => _DiariesListViewState();
}

class _DiariesListViewState extends State<DiariesListView> {
  final diaries = FirebaseFirestore.instance.collection('diaries');

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    var diaryList = widget.listOfDiaries;
    var filteredList = diaryList.where((element) {
      return (element.userId == _user!.uid);
    }).toList();

    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: (filteredList.isNotEmpty)
                ? ListView.builder(
                    itemBuilder: (ctx, index) {
                      Diary diary = filteredList[index];
                      return DelayedDisplay(
                        delay: const Duration(
                          milliseconds: 2,
                        ),
                        fadeIn: true,
                        child: Card(
                          elevation: 4,
                          child: InnerListCard(
                              selectedDate: widget.selectedDate!,
                              diary: diary,
                              diaries: diaries),
                        ),
                      );
                    },
                    itemCount: filteredList.length,
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 4,
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                children: [
                                  Text(
                                    'Safeguard your memories on ${formatDate(widget.selectedDate!)}',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return WriteDiaryDialog(
                                              selectedDate: widget.selectedDate,
                                              titleCtrl:
                                                  TextEditingController(),
                                              descCtrl:
                                                  TextEditingController());
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.lock_outline_sharp),
                                    label: const Text("Click to add an entry"),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 1,
                  ),
          ),
        ),
      ],
    );
  }
}
/*
StreamBuilder<QuerySnapshot>(
            stream: diaries.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              var filteredList = snapshot.data!.docs.map((diary) {
                return Diary.fromDoc(diary);
              }).where((element) {
                return (element.userId ==
                    FirebaseAuth.instance.currentUser!.uid);
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
          )
 */
