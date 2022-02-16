import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountForm extends StatelessWidget {
  CreateAccountForm({
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
          const Text(
            "Please enter an email and password that is at least 6 characters long!",
          ),
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
                String email = _emailController.text;
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwdController.text)
                    .then((value) {
                  // create custom user

                  Map<String, dynamic> user = {
                    'avatar_url': "https://google.com",
                    'profession': "Doctor",
                    'uid': value.user!.uid,
                    'display_name': email.split('@')[0],
                  };

                  FirebaseFirestore.instance
                      .collection("users")
                      .add(user)
                      .then((value) => print(value.path));
                });
              }
            },
            child: const Text("Create Account"),
          )
        ],
      ),
    );
  }
}
