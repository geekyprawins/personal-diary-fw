import 'package:flutter/material.dart';
import 'package:personal_diary/screens/main_page.dart';
import 'input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatelessWidget {
  LoginForm({
    Key? key,
    required TextEditingController emailController,
    required TextEditingController passwdController,
    GlobalKey<FormState>? formKey,
  })  : _emailController = emailController,
        _passwdController = passwdController,
        _formKey = formKey,
        super(key: key);

  final TextEditingController _emailController;
  final TextEditingController _passwdController;
  final GlobalKey<FormState>? _formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? "Please enter an email" : null;
              },
              controller: _emailController,
              decoration: buildInputDecoration(
                "Email",
                "hello@gmail.com",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                return value!.isEmpty ? "Please enter a password" : null;
              },
              obscureText: true,
              controller: _passwdController,
              decoration: buildInputDecoration(
                "Password",
                "",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              backgroundColor: Colors.green,
              textStyle: const TextStyle(
                fontSize: 18,
              ),
            ),
            onPressed: () {
              // sign in
              if (_formKey!.currentState!.validate()) {
                // validated
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwdController.text)
                    .then((value) {
                  return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  );
                });
              }
            },
            child: const Text("Sign In"),
          )
        ],
      ),
    );
  }
}
