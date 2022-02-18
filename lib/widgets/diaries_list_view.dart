import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';

class DiariesListView extends StatelessWidget {
  const DiariesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
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
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDateFromTimestamp(diary.entryPoint),
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.grey,
                                    ),
                                    label: const Text(''),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "• ${formatDateFromTimestampHour(diary.entryPoint)}",
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.grey,
                                      ),
                                      label: const Text(''),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                                Image.network(diary.photoUrls == null
                                    ? 'https://picsum.photos/400/200'
                                    : diary.photoUrls!),
                                Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              diary.title!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              diary.entry!,
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
