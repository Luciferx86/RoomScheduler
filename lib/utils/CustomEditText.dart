import 'package:flutter/material.dart';

class CustomEditText extends StatelessWidget {
  CustomEditText({Key key, this.label, this.hint, this.isPass, this.onChanged})
      : super(key: key);

  final String label;
  final String hint;
  final bool isPass;
  final onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: TextField(
          onChanged: this.onChanged,
          obscureText: isPass,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 20),
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
