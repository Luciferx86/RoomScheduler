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
  final formKey = GlobalKey<FormState>();
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

  void validateForm() {
    if (formKey.currentState.validate()) {
      print(this.email);
      print(this.password);
      print(this.confirmPass);
      Navigator.pushNamed(context, '/add',
          arguments: {"email": email, "pass": password});
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20
                      ),
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: 'someone@example.com',
                        labelText: 'Email *',
                      ),
                      onChanged: (String val) {
                        setState(() {
                          email = val;
                        });
                      },
                      onSaved: (String value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String value) {
                        return EmailValidator.validate(this.email)
                            ? null
                            : 'Invalid Email';
                      },
                    ),
                    SizedBox(height: 25,),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20
                      ),
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
                        return value.length < 8
                            ? 'Password less than 8 chars'
                            : null;
                      },
                    ),
                    SizedBox(height: 25,),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 20
                      ),
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
                      height: 100,
                    ),
                    MyButton(text: "Create Account", onTap: this.validateForm)
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
