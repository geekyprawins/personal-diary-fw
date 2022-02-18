import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class WriteDiaryDialog extends StatefulWidget {
  const WriteDiaryDialog({
    Key? key,
    required this.titleCtrl,
    required this.descCtrl,
    this.selectedDate,
  }) : super(key: key);

  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final DateTime? selectedDate;

  @override
  State<WriteDiaryDialog> createState() => _WriteDiaryDialogState();
}

class _WriteDiaryDialogState extends State<WriteDiaryDialog> {
  var buttonText = "Done";
  final CollectionReference diaries =
      FirebaseFirestore.instance.collection('diaries');

  html.File? _cloudFile;
  var _fileBytes;
  Image? _imageWidget;

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
                      firebase_storage.FirebaseStorage firebaseStorage =
                          firebase_storage.FirebaseStorage.instance;
                      final date = DateTime.now();
                      final path = '$date';
                      final isFieldsNotEmpty =
                          widget.titleCtrl.text.isNotEmpty &&
                              widget.descCtrl.text.isNotEmpty;

                      String? currId;

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
                            author: FirebaseAuth.instance.currentUser!.email!
                                .split('@')[0],
                            entry: widget.descCtrl.text,
                            entryPoint:
                                Timestamp.fromDate(widget.selectedDate!),
                          ).toMap(),
                        )
                            .then((value) {
                          setState(() {
                            currId = value.id;
                          });
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

                      if (_fileBytes != null) {
                        firebase_storage.SettableMetadata? smd =
                            firebase_storage.SettableMetadata(
                          contentType: 'image/jpeg',
                          customMetadata: {'picked-file-path': path},
                        );

                        firebaseStorage
                            .ref()
                            .child(
                                'images/$path/${FirebaseAuth.instance.currentUser!.uid}')
                            .putData(_fileBytes, smd)
                            .then((val) {
                          return val.ref.getDownloadURL().then((value) {
                            diaries
                                .doc(currId)
                                .update({'photo_list': value.toString()});
                          });
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
                          onPressed: () async {
                            // add picture
                            await getMultipleImageInfos();
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
                        Text(
                          formatDate(widget.selectedDate!),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Form(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: (MediaQuery.of(context).size.height *
                                          0.8) /
                                      2,
                                  child: _imageWidget,
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

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;
    // String mimeType = mime(Path.basename(mediaData.fileName!))!;
    // html.File mediaFile =
    //     new html.File(mediaData.data, mediaData.fileName, {'type': mimeType});

    setState(() {
      // _cloudFile = mediaFile;
      _fileBytes = mediaData.data;
      _imageWidget = Image.memory(mediaData.data!);
    });
  }
}
