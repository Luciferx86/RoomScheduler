import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Strings.dart';
import 'package:room_scheduler/utils/UtilFuncs.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  String number = "";
  String btnText = "Generate OTP";
  bool isLoading = false;
  bool otpGenerated = false;
  bool otpExpired = false;
  String verificationID = "";
  String otpText = "";
  void createAccount() {
    print(this.number);
    Navigator.pushNamed(context, '/add', arguments: {"number": number});
  }

  void validateForm() {
    if (formKey.currentState.validate()) {
      // Navigator.pushNamed(context, '/add',
      //     arguments: {"email": email, "pass": password});
      if (this.btnText == "Generate OTP") {
        FocusScope.of(context).requestFocus(FocusNode());
        String mobile = this.number;
        this.sendOtp(mobile, context);
      } else {
        this.setState(() {
          isLoading = true;
        });
        try {
          AuthCredential _credential = PhoneAuthProvider.getCredential(
              verificationId: verificationID, smsCode: this.otpText);
          _auth.signInWithCredential(_credential).then((AuthResult result) {
            this.setState(() {
              isLoading = false;
            });
            UtilFuncs.showToast("Verified", context);
            Navigator.pushReplacementNamed(context, '/add',
                arguments: {"number": number});
          }).catchError((err) {
            this.setState(() {
              isLoading = false;
            });
            UtilFuncs.showToast(err, context);
          });
        } on Exception {
          this.setState(() {
            isLoading = false;
          });
        } catch (e) {
          this.setState(() {
            isLoading = false;
          });
          log(e);
        }
      }
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
        backgroundColor: AppColors.orange,
      ),
      body: LoadingOverlay(
        isLoading: this.isLoading,
        child: SingleChildScrollView(
          child: Column(
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
                          maxLength: 10,
                          style: TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: '8080808080',
                            labelText: 'Phone Number *',
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (String val) {
                            setState(() {
                              number = val;
                            });
                          },
                          onSaved: (String value) {
                            // This optional block of code can be used to run
                            // code when the user saves the form.
                          },
                          validator: (String value) {
                            return value.length != 10
                                ? 'Phone Number is 10 chars'
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // this.showOtpField(),
                        this.otpGenerated
                            ? this.renderOtpField()
                            : SizedBox(height: 0),
                        MyButton(text: this.btnText, onTap: this.validateForm)
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future sendOtp(String mobile, BuildContext context) async {
    this.setState(() {
      isLoading = true;
    });
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          this.setState(() {
            isLoading = false;
          });

          _auth.signInWithCredential(authCredential).then((AuthResult result) {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => HomeScreen(result.user)));
          });
          //this is a callback if otp verfied automatically
          //navigate to next page
        },
        verificationFailed: (AuthException authException) {
          this.setState(() {
            isLoading = false;
          });
          print(authException.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          log(verificationId);
          log(otpText);
          UtilFuncs.showToast("OTP sent", context);
          this.setState(() {
            btnText = "Verify OTP";
            otpGenerated = true;
            isLoading = false;
            verificationID = verificationId;
          });
          // this.showOtpField();
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  Widget renderOtpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Column(
        children: <Widget>[
          PinCodeTextField(
            length: 6,
            obsecureText: false,
            textInputType: TextInputType.number,
            animationType: AnimationType.slide,
            validator: (v) {
              if (v.length < 6) {
                return "6 digit OTP";
              } else {
                return null;
              }
            },
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                // borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 25,
                // activeFillColor: hasError ? Colors.orange : Colors.white,
                activeFillColor: Colors.transparent,
                inactiveColor: Colors.green,
                selectedColor: Colors.green,
                selectedFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                disabledColor: Colors.transparent),
            animationDuration: Duration(milliseconds: 100),
            errorTextSpace: 30,
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            onCompleted: (v) {
              print("Completed");
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onChanged: (value) {
              this.setState(() {
                this.otpText = value;
              });
            },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
              child: Text(
                "00:00",
                style: TextStyle(
                    color: this.otpExpired ? Colors.red : Colors.black),
              ),
              onTap: () {
                if (this.otpGenerated) {}
              })
        ],
      ),
    );
  }
}
