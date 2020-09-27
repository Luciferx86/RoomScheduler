import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Logo.dart';
import 'package:room_scheduler/utils/Strings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String orgName = "";
  String password = "";
  String foundPass = "";
  String confirmPass = "";
  String btnText = "Login";
  String loginMode = "initial";

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
        backgroundColor: AppColors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Logo(),
            TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: "8080808080",
                  labelText: 'Phone No.',
                ),
                keyboardType: TextInputType.phone,
                obscureText: false,
                onChanged: (String val) {
                  setState(() {
                    email = val;
                  });
                },
                onSaved: (String value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                }),
            SizedBox(height: 20,),
            // this.showPass
            //     ? renderPassFields()
            //     : SizedBox(
            //         height: 20,
            //       ),
            renderPassFields(),
            MyButton(
              text: this.btnText,
              onTap: () {
                this.loginBtnClick(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // void doLogin(BuildContext context) {
  //   if (loggingOrCreating) {
  //     bool userFound = false;
  //     bool status = false;
  //     log("logging");
  //     FirebaseDatabase.instance
  //         .reference()
  //         .child("Orgs")
  //         .once()
  //         .then((DataSnapshot snapshot) {
  //       Map values = snapshot.value;
  //       values.forEach((key, val) {
  //         List emps = val["allEmployees"];
  //         emps.forEach((obj) {
  //           if (obj["email"] == this.email) {
  //             log("found user");
  //             log(key);
  //             status = obj["active"];
  //             userFound = true;
  //             this.setState(() {
  //               orgName = key;
  //               btnText = "Create Account";
  //             });
  //           }
  //         });
  //         if (userFound) {
  //           log("found");
  //           log(orgName);
  //           if (!status) {
  //             showPasswordFields();
  //           }
  //         } else {
  //           log("not foundsss");
  //         }
  //       });
  //       log("yoyo");
  //       log(values.toString());
  //     });
  //   } else {}
  //   // Navigator.pushNamed(context, '/dashboard');
  // }

  void loginBtnClick(BuildContext context) {
    switch (loginMode) {
      case "initial":
        updateLoginStatus(context);
        break;
      case "login":
        doLogin();
        break;
      case "create":
        doCreate();
        break;
    }
  }

  void doLogin() {
    String email = this.email;
    String pass = this.password;
    if (pass == foundPass) {
      log("Lets goooo");
    } else {
      log("wrong pass");
    }
  }

  void doCreate() {}

  void updateLoginStatus(BuildContext context) {
    bool userFound = false;
    String fPass;
    bool status = false;
    log("logging");
    FirebaseDatabase.instance
        .reference()
        .child("Orgs")
        .once()
        .then((DataSnapshot snapshot) {
      Map values = snapshot.value;
      if (values != null) {
        values.forEach((key, val) {
          List emps = val["allEmployees"];
          emps.forEach((obj) {
            if (obj["email"] == this.email) {
              log("found user");
              log(key);
              status = obj["active"];
              userFound = true;
              fPass = obj["password"];
              this.setState(() {
                orgName = key;
              });
            }
          });

          if (userFound) {
            log("found");
            log(orgName);
            if (!status) {
              //user found, but not activated
              log("user found, not active");
              this.setState(() {
                btnText = "Create Account";
                loginMode = "create";
              });
            } else {
              log("user found, active");
              //user found, and activated
              this.setState(() {
                loginMode = "login";
                foundPass = fPass;
              });
            }
          } else {
            //user not found
            log("not foundsss");
          }
        });
      }
    });
  }

  Widget renderPassFields() {
    switch (loginMode) {
      case "initial":
        return Container();
        break;
      case "login":
        return renderPassFieldsForLogin();
        break;
      case "create":
        return renderPassFieldsForCreation();
        break;
      default:
        return Container();
    }
  }

  Widget renderPassFieldsForCreation() {
    return (Column(children: <Widget>[
      TextFormField(
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: '********',
          labelText: 'Password *',
        ),
        obscureText: true,
        onChanged: (String val) {
          setState(() {
            password = val;
          });
        },
        onSaved: (String value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String value) {
          return value.length < 8 ? 'Password less than 8 chars' : null;
        },
      ),
      SizedBox(
        height: 25,
      ),
      TextFormField(
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: '********',
          labelText: 'Confirm Password *',
        ),
        obscureText: true,
        onChanged: (String val) {
          setState(() {
            confirmPass = val;
          });
        },
        onSaved: (String value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String value) {
          return this.password != this.confirmPass
              ? 'Passwords do not match'
              : null;
        },
      ),
      SizedBox(
        height: 20,
      ),
    ]));
  }

  Widget renderPassFieldsForLogin() {
    return (Column(children: <Widget>[
      SizedBox(
        height: 20,
      ),
      TextFormField(
        style: TextStyle(fontSize: 20),
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: '********',
          labelText: 'Password *',
        ),
        obscureText: true,
        onChanged: (String val) {
          setState(() {
            password = val;
          });
        },
        onSaved: (String value) {
          // This optional block of code can be used to run
          // code when the user saves the form.
        },
        validator: (String value) {
          return value.length < 8 ? 'Password less than 8 chars' : null;
        },
      ),
      SizedBox(
        height: 25,
      ),
    ]));
  }
}
