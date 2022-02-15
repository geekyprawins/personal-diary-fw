import 'package:flutter/material.dart';
import 'package:personal_diary/widgets/login_form.dart';
import 'package:personal_diary/widgets/create_account_form.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwdController = TextEditingController();

  final GlobalKey<FormState>? _formKey = GlobalKey<FormState>();

  bool isCreatedAccClicked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            color: const Color(0xFFB9C2D1),
          ),
        ),
        Text(
          isCreatedAccClicked ? "Create Account" : "Sign In",
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: isCreatedAccClicked
                  ? CreateAccountForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwdController: _passwdController,
                    )
                  : LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwdController: _passwdController,
                    ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isCreatedAccClicked = !isCreatedAccClicked;
                });
              },
              icon: const Icon(Icons.portrait_rounded),
              label: Text(isCreatedAccClicked
                  ? "Already have an account?"
                  : "Create an account"),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.05),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: const Color(0xFFB9C2D1),
          ),
        ),
      ],
    ));
  }
}
