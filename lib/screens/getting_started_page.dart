import 'package:flutter/material.dart';
import 'login_page.dart';

class GettingStartedPage extends StatelessWidget {
  const GettingStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CircleAvatar(
        backgroundColor: const Color(0xFFF5F6F8),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "DiaryBook.",
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              '"Document your life!"',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black26,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                icon: const Icon(Icons.login_rounded),
                label: const Text("Sign-in to get started"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
