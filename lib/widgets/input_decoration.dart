import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String labelText, String hintText) {
  return InputDecoration(
    fillColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.blue,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(
        color: Color(0xFF69639f),
        width: 2.0,
      ),
    ),
    labelText: labelText,
    hintText: hintText,
    // suffixIcon: IconButton(
    //   icon: Icon(
    //     _passwordVisible ? Icons.visibility : Icons.visibility_off,
    //     color: Theme.of(context).primaryColorDark,
    //   ),
    //   onPressed: () {
    //     setState(() {
    //       _passwordVisible = !_passwordVisible;
    //     });
    //   },
    // ),
  );
}
