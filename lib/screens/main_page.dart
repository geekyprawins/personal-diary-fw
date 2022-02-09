import 'package:flutter/material.dart';

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
              )
            ],
          )
        ],
      ),
    );
  }
}
