import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Logo.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/Strings.dart';

class LoginPage extends StatelessWidget {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Logo(),
          CustomEditText(
              label: Strings.email, hint: Strings.emailHint, isPass: false),
          SizedBox(
            height: 20,
          ),
          CustomEditText(
              label: Strings.password, hint: Strings.password, isPass: true),
          SizedBox(
            height: 50,
          ),
          MyButton(
            text: "Login",
            onTap: () {
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
        ],
      ),
    );
  }
}
