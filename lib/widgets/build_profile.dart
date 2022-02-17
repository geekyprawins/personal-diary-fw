import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary_user.dart';
import 'package:personal_diary/screens/login_page.dart';
import 'package:personal_diary/widgets/update_user_dialog.dart';

Row buildProfile(DiaryUser currUser, BuildContext context) {
  final avatarUrlCtrl = TextEditingController(text: currUser.avatarUrl);
  final displaynameCtrl = TextEditingController(text: currUser.displayName);
  return Row(
    children: [
      Column(
        children: [
          Expanded(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(currUser.avatarUrl.toString()),
                  backgroundColor: Colors.transparent,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return UpdateUserDialogue(
                      currUser: currUser,
                      avatarUrlCtrl: avatarUrlCtrl,
                      displaynameCtrl: displaynameCtrl,
                    );
                  },
                );
              },
            ),
          ),
          Text(
            currUser.displayName.toString(),
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
      IconButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          });
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
      )
    ],
  );
}
