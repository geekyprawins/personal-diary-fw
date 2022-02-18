import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/utils/utils.dart';
import 'dart:html' as html;
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:personal_diary/widgets/delete_entry_dialog.dart';

class UpdateEntryDialog extends StatefulWidget {
  final Diary? diary;
  final DateTime? selectedDate;

  UpdateEntryDialog({this.diary, this.selectedDate});

  @override
  State<UpdateEntryDialog> createState() => _UpdateEntryDialogState();
}

class _UpdateEntryDialogState extends State<UpdateEntryDialog> {
  html.File? _cloudFile;
  var _fileBytes;
  Image? _imageWidget;
  String? currId;
  var buttonText = "Done";

  final diaries = FirebaseFirestore.instance.collection('diaries');
  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleCtrl = TextEditingController(text: widget.diary!.title);
    descCtrl = TextEditingController(text: widget.diary!.entry);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
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
                      // update records
                      firebase_storage.FirebaseStorage firebaseStorage =
                          firebase_storage.FirebaseStorage.instance;
                      final date = DateTime.now();
                      final path = '$date';
                      final isFieldsNotEmpty =
                          titleCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty;

                      if (isFieldsNotEmpty) {
                        setState(() {
                          buttonText = "Updating...";
                        });
                        // update to firestore

                        diaries
                            .doc(widget.diary!.id)
                            .update(Diary(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                              title: titleCtrl.text,
                              author: FirebaseAuth.instance.currentUser!.email!
                                  .split('@')[0],
                              entry: descCtrl.text,
                              entryPoint: Timestamp.fromDate(DateTime.now()),
                            ).toMap())
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

                      if (_fileBytes != null) {
                        firebase_storage.SettableMetadata? smd =
                            firebase_storage.SettableMetadata(
                          contentType: 'image/jpeg',
                          customMetadata: {'picked-file-path': path},
                        );
                        Future.delayed(const Duration(milliseconds: 1500))
                            .then((value) {
                          firebaseStorage
                              .ref()
                              .child(
                                  'images/$path-${FirebaseAuth.instance.currentUser!.uid}')
                              .putData(_fileBytes, smd)
                              .then((val) {
                            return val.ref.getDownloadURL().then((value) {
                              diaries
                                  .doc(widget.diary!.id)
                                  .update({'photo_list': value.toString()});
                            });
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () async {
                              // action
                              await getMultipleImageInfos();
                            },
                            icon: const Icon(Icons.image_rounded),
                            splashRadius: 26,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteEntryDialog(
                                      diaries: diaries, diary: widget.diary!);
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            splashRadius: 26,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //add
                        Text(
                          formatDateFromTimestamp(widget.diary!.entryPoint),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.40,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (_imageWidget != null)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _imageWidget,
                                  )
                                : Image.network(widget.diary!.photoUrls == null
                                    ? 'https://picsum.photos/400/200'
                                    : widget.diary!.photoUrls!),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: titleCtrl,
                                  decoration: const InputDecoration(
                                      hintText: "Title...."),
                                ),
                                TextFormField(
                                  maxLines: null,
                                  controller: descCtrl,
                                  decoration: const InputDecoration(
                                      hintText: "Write your thoughts...."),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
