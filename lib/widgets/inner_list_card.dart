import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';
import 'package:personal_diary/widgets/update_entry_dialog.dart';

import 'delete_entry_dialog.dart';

class InnerListCard extends StatelessWidget {
  const InnerListCard({
    Key? key,
    required this.diary,
    required this.selectedDate,
    required this.diaries,
  }) : super(key: key);

  final Diary diary;
  final CollectionReference<Map<String, dynamic>> diaries;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteEntryDialog(
                            diaries: diaries, diary: diary);
                      },
                    );
                  },
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
                    style: const TextStyle(color: Colors.green),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              formatDateFromTimestamp(diary.entryPoint),
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateEntryDialog(
                                      diary: diary,
                                      selectedDate: selectedDate,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteEntryDialog(
                                        diaries: diaries, diary: diary);
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                              ),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ],
                  ),
                  content: ListTile(
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "• ${formatDateFromTimestampHour(diary.entryPoint)}",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(diary.photoUrls == null
                                ? 'https://picsum.photos/400/200'
                                : diary.photoUrls!),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      diary.title!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      diary.entry!,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
