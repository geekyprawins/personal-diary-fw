import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/services/services.dart';
import 'package:personal_diary/widgets/diaries_list_view.dart';
import 'package:personal_diary/widgets/user_profile.dart';
import 'package:provider/provider.dart';
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
  var selectedDate = DateTime.now();
  var sameDateDiaries;

  // List<Diary> listOfDiaries = [];
  @override
  Widget build(BuildContext context) {
    var listOfDiaries = Provider.of<List<Diary>>(context);
    var _user = Provider.of<User?>(context);
    var latestFilteredStream;
    var earliestFilteredStream;

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
                      listOfDiaries.clear();
                      latestFilteredStream = DiaryService()
                          .getLatestDiaries(_user!.uid)
                          .then((value) {
                        for (var i in value) {
                          setState(() {
                            listOfDiaries.add(i);
                          });
                        }
                      });
                    } else if (value == "Earliest") {
                      setState(() {
                        _dropdownText = value as String?;
                      });
                      listOfDiaries.clear();
                      earliestFilteredStream = DiaryService()
                          .getEarliestDiaries(_user!.uid)
                          .then((value) {
                        for (var i in value) {
                          setState(() {
                            listOfDiaries.add(i);
                          });
                        }
                      });
                    }
                  },
                ),
              ),
              const UserProfile(),
            ],
          ),
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
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
                      setState(() {
                        selectedDate = daterangepickerSelection.value;
                        listOfDiaries.clear();
                        sameDateDiaries = DiaryService()
                            .getSameDateDiaries(
                          Timestamp.fromDate(selectedDate).toDate(),
                          FirebaseAuth.instance.currentUser!.uid,
                        )
                            .then((value) {
                          for (var item in value) {
                            setState(() {
                              listOfDiaries.add(item);
                            });
                          }
                        });
                      });
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
                                selectedDate: selectedDate,
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
            flex: 10,
            child: DiariesListView(
              listOfDiaries: listOfDiaries,
              selectedDate: selectedDate,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add functionality
          showDialog(
              context: context,
              builder: (context) {
                return WriteDiaryDialog(
                  selectedDate: selectedDate,
                  titleCtrl: titleCtrl,
                  descCtrl: descCtrl,
                );
              });
        },
        tooltip: "Add",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
