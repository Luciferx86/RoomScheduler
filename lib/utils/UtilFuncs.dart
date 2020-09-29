import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UtilFuncs {
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child: Container(
              // A simplified version of dialog.
              color: Colors.transparent,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
