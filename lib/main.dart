import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:personal_diary/screens/getting_started_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final userDiaryDataStream =
      FirebaseFirestore.instance.collection('diaries').snapshots().map((diary) {
    return diary.docs.map((e) {
      return Diary.fromDoc(e);
    }).toList();
  });
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Diary>>(
            create: (context) => userDiaryDataStream, initialData: []),
        StreamProvider<User?>(
            create: (context) => FirebaseAuth.instance.authStateChanges(),
            initialData: null),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary Book',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const GettingStartedPage(),
        initialRoute: ,
      ),
    );
  }
}

class GetInfo extends StatelessWidget {
  const GetInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('diaries').snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return const Text("Some error occurred :( ");
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemBuilder: (context, i) {
                  final data = docs[i].data();
                  return ListTile(
                    title: Text(data["display_name"]),
                    subtitle: Text(data["profession"]),
                  );
                },
                itemCount: docs.length,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
