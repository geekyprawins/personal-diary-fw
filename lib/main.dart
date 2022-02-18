import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/screens/login_page.dart';
import 'package:personal_diary/screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_diary/widgets/page_not_found.dart';
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
        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(
                settingsName: settings.name!,
              );
            },
          );
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const PageNotFound(),
        ),
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  const RouteController({Key? key, required this.settingsName})
      : super(key: key);
  final String settingsName;
  @override
  Widget build(BuildContext context) {
    var _userLoggedIn = Provider.of<User?>(context) != null;
    final signedInGoToMain = _userLoggedIn && settingsName == '/main';
    final notSignedInGoToMain = !_userLoggedIn && settingsName == '/main';
    if (settingsName == '/') {
      return const GettingStartedPage();
    } else if (notSignedInGoToMain || settingsName == '/main') {
      return LoginPage();
    } else if (notSignedInGoToMain || settingsName == '/login') {
      return LoginPage();
    } else if (signedInGoToMain) {
      return const MainPage();
    } else {
      return const PageNotFound();
    }
  }
}
