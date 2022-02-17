import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';

class WriteDiaryDialog extends StatefulWidget {
  const WriteDiaryDialog({
    Key? key,
    required this.titleCtrl,
    required this.descCtrl,
  }) : super(key: key);

  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;

  @override
  State<WriteDiaryDialog> createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  var buttonText = "Done";
  final CollectionReference diaries =
      FirebaseFirestore.instance.collection('diaries');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Discard",
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      final isFieldsNotEmpty =
                          widget.titleCtrl.text.isNotEmpty &&
                              widget.descCtrl.text.isNotEmpty;

                      if (isFieldsNotEmpty) {
                        setState(() {
                          buttonText = "Saving...";
                        });
                        // save to firestore
                        diaries
                            .add(
                          Diary(
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            title: widget.titleCtrl.text,
                            author: 'Unknown',
                            entry: widget.descCtrl.text,
                            entryPoint: Timestamp.fromDate(DateTime.now()),
                          ).toMap(),
                        )
                            .then((value) {
                          Future.delayed(const Duration(seconds: 2))
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        });
                      } else {
                        setState(() {
                          buttonText = "Fill in!";
                        });
                      }
                    },
                    child: Text(
                      buttonText,
                    ),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.green,
                      elevation: 4,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        side: BorderSide(
                          width: 1,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            // add picture
                          },
                          icon: const Icon(
                            Icons.image_rounded,
                          ),
                          splashRadius: 26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mar 31, 2003'),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                          0.8) /
                                      2,
                                  child: Container(
                                    width: 700,
                                    color: Colors.black,
                                    child: const Text("Image Placeholder"),
                                  ),
                                ),
                                TextFormField(
                                  controller: widget.titleCtrl,
                                  decoration: const InputDecoration(
                                      hintText: "Title...."),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: widget.descCtrl,
                                  decoration: const InputDecoration(
                                      hintText: "Write your thoughts...."),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
