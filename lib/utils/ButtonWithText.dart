import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/MyButton.dart';

class ButtonWithText extends StatelessWidget {
  final onTap;
  final String buttonText;
  final String text;
  ButtonWithText({Key key, this.onTap, this.text, @required this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyButton(onTap: this.onTap, text: this.buttonText),
        SizedBox(height: 10),
        Text(
          this.text,
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }
}
