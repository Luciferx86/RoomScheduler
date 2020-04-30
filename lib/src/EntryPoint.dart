import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Strings.dart';

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Strings.loginPageTitle,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: RoomSchedulerColors.orange,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              "Welcome to Room Scheduler!",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            Image(image: AssetImage("img/logo.png")),
            SizedBox(
              height: 60,
            ),
            MyButton(
              text: "Existing User",
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            SizedBox(
              height: 50,
            ),
            MyButton(
              text: "Create Organisation",
              onTap: () {
                Navigator.pushNamed(context, '/create');
              },
            )
          ],
        ),
      ),
    );
  }
}
