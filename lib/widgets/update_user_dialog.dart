import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary_user.dart';
import 'package:personal_diary/services/services.dart';

class UpdateUserDialogue extends StatelessWidget {
  const UpdateUserDialogue({
    Key? key,
    required this.avatarUrlCtrl,
    required this.displaynameCtrl,
    required this.currUser,
  }) : super(key: key);

  final TextEditingController avatarUrlCtrl;
  final TextEditingController displaynameCtrl;
  final DiaryUser currUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text(currUser.displayName.toString()),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.40,
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Editing ${currUser.displayName.toString()}",
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: avatarUrlCtrl,
                    ),
                    TextFormField(
                      controller: displaynameCtrl,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          DiaryService().updateUser(
                              currUser,
                              displaynameCtrl.text,
                              avatarUrlCtrl.text,
                              context);
                          Future.delayed(const Duration(milliseconds: 200))
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text("Update"),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              side: BorderSide(color: Colors.green, width: 1)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
