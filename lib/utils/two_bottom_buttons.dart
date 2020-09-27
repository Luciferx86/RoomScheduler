import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_scheduler/utils/Colors.dart';

class TwoBottomButtons extends StatelessWidget {
  final String btnOneText;
  final String btnTwoText;
  final Function btnOneFunction;
  final Function btnTwoFunction;

  const TwoBottomButtons(
      {Key key,
        this.btnOneFunction,
        this.btnTwoFunction,
        this.btnOneText,
        this.btnTwoText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnTextStyle = TextStyle(
      fontSize: 14.0,
      color: Colors.black,
    );
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 4.0,
        vertical: 5.0,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 30.0,
          ),
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.all(
                15.0,
              ),
              color: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: btnOneFunction,
              child: Text(
                btnOneText,
                style: btnTextStyle,
              ),
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.all(
                15.0,
              ),
              color: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: btnTwoFunction,
              child: Text(
                btnTwoText,
                style: btnTextStyle,
              ),
            ),
          ),
          SizedBox(
            width: 30.0,
          ),
        ],
      ),
    );
  }
}