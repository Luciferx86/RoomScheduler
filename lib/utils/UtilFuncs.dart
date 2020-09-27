import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class UtilFuncs {
  static void showToast(String msg, BuildContext context) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
