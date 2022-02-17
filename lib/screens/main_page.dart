import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary_user.dart';
import 'package:personal_diary/widgets/build_profile.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:personal_diary/widgets/write_diary_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropdownText;
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        toolbarHeight: 100,
        elevation: 4,
        title: Row(
          children: [
            Text(
              "Diary",
              style: TextStyle(
                fontSize: 39,
                color: Colors.blueGrey.shade400,
              ),
            ),
            const Text(
              "Book",
              style: TextStyle(
                fontSize: 39,
                color: Colors.green,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  hint: (_dropdownText == null)
                      ? const Text('Select')
                      : Text(_dropdownText!),
                  items: <String>['Latest', 'Earliest']
                      .map(
                        (String e) => DropdownMenuItem<String>(
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          value: e,
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == "Latest") {
                      setState(() {
                        _dropdownText = value as String?;
                      });
                    } else if (value == "Earliest") {
                      _dropdownText = value as String?;
                    }
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final usersListStream = snapshot.data!.docs.map((docs) {
                    return DiaryUser.fromDoc(docs);
                  }).where((element) {
                    return (element.uid ==
                        FirebaseAuth.instance.currentUser!.uid);
                  }).toList();

                  DiaryUser currUser = usersListStream[0];

                  return buildProfile(currUser, context);
                },
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
              ),
            ],
          ),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border(
                  right: BorderSide(
                    width: 0.4,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: (daterangepickerSelection) {
                      // TODO: add functionality
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.1),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                        // size: 40,
                      ),
                      label: const Text(
                        'Write New',
                        // style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        // add functionality
                        // print("clicked");
                        showDialog(
                            context: context,
                            builder: (context) {
                              return WriteDiaryDialog(
                                titleCtrl: titleCtrl,
                                descCtrl: descCtrl,
                              );
                            });
                        // print("shown");
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text("Hello, $index"),
                      ),
                    ),
                  );
                },
                itemCount: 5,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add functionality
        },
        tooltip: "Add",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
