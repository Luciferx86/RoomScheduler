import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Strings.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String email = "";
  String password = "";
  String confirmPass = "";
  void createAccount() {
    if (EmailValidator.validate(this.email)) {
      if (this.password.length > 4) {
        if (this.password == this.confirmPass) {
          print(this.email);
          print(this.password);
          print(this.confirmPass);
          Navigator.pushNamed(context, '/add',
              arguments: {"email": email, "pass": password});
        } else {
          showDialog(
              // barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Passwords do not match"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      } else {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Passwords must be atleast 5 characters"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } else {
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Invalid Email"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            "Create An Account",
            style: TextStyle(fontSize: 20),
          ),
          CustomEditText(
            label: "Email",
            hint: "someone@example.com",
            isPass: false,
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
          CustomEditText(
              label: "Password",
              hint: "password",
              isPass: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              }),
          CustomEditText(
              label: "Confirm Password",
              hint: "password",
              isPass: true,
              onChanged: (val) {
                setState(() {
                  confirmPass = val;
                });
              }),
          SizedBox(
            height: 30,
          ),
          MyButton(text: "Create Account", onTap: this.createAccount)
        ],
      ),
    );
  }
}
