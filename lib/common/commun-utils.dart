import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonUtils {
  static void showLoader(BuildContext context, {String message}) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  message != null && message.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )
                          ],
                        )
                      : SizedBox(
                          height: 0,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showToastMessage(String message) {
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

}
