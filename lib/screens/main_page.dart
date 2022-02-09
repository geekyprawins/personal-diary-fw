import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropdownText;
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
              Row(
                children: [
                  Column(
                    children: const [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage("https://picsum.photos/200/300"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Praveen",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.login,
                      color: Colors.red,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
      body: Row(
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
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SfDateRangePicker(
                    onSelectionChanged: (daterangepickerSelection) {
                      // TODO: add functionality
                    },
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                    label: const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Write New',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
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
        onPressed: () {},
        tooltip: "Add",
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
