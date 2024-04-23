import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final textController;
  final String hintText;
  final bool obscureText;

  const LoginTextField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: textController,
        obscureText: obscureText,
        //LabelText & labelStyle
        //prefixIcon
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}