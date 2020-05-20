import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:room_scheduler/src/AddEmployees.dart';
import 'package:room_scheduler/src/AddRooms.dart';
import 'package:room_scheduler/src/AddTeams.dart';
import 'package:room_scheduler/utils/ButtonWithText.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Strings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as path;

class AddOrganisation extends StatefulWidget {
  @override
  _AddOrganisationState createState() => _AddOrganisationState();
}

class _AddOrganisationState extends State<AddOrganisation> {
  String orgName = "";
  File logo;
  List allRooms = [];
  List allTeams = [];
  List allEmployees = [];
  var admin;
  bool isLoading = false;
  String logoText = "No Logo Added";

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        logo = image;
        logoText = path.basename(image.path);
      }
    });
  }

  void addRooms() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddRoomsDialog(
              allRooms: this.allRooms,
              onDone: (List allRooms) {
                this.setState(() {
                  this.allRooms = allRooms;
                });
                Navigator.pop(context);
              },
            ));
  }

  void addEmployees() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddEmployeeDialog(
              allTeams: this.allTeams,
              allEmployees: this.allEmployees,
              onDone: (List allEmployees) {
                this.setState(() {
                  this.allEmployees = allEmployees;
                });
                Navigator.pop(context);
              },
            ));
  }

  void addTeams() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddTeamsDialog(
              allTeams: this.allTeams,
              onDone: (List allTeams) {
                this.setState(() {
                  this.allTeams = allTeams;
                });
                Navigator.pop(context);
              },
            ));
  }

  String getFirebaseRefName(String name) {
    return name
        .replaceAll(" ", "")
        .replaceAll(".", "")
        .replaceAll("/", "")
        .replaceAll("&", "");
  }

  void createOrg() {
    String error = "";
    if (this.allEmployees.length == 0) {
      error = "No employees added.";
    }
    if (this.allTeams.length == 0) {
      error = "No teams added.";
    }
    if (this.allRooms.length == 0) {
      error = "No rooms added.";
    }
    if (this.logo == null) {
      error = "No logo selected";
    }
    if (this.orgName == "") {
      error = "Organisation Name not set.";
    }
    if (error == "") {
      this.setState(() {
        this.isLoading = true;
      });
      FirebaseDatabase()
          .reference()
          .child("Orgs")
          .child(getFirebaseRefName(this.orgName))
          .set({
        "orgName": this.orgName,
        "allRooms": this.allRooms,
        "allTeams": this.allTeams,
        "allEmployees": this.allEmployees,
        "admin": admin
      }).then((onValue) async {
        StorageUploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("Orgs")
            .child(getFirebaseRefName(this.orgName))
            .child("logo")
            .putFile(this.logo);
        await uploadTask.onComplete;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('orgName', this.orgName);
        this.setState(() {
          isLoading = false;
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Organisation Created"),
                content: Text(this.orgName + " was created successfully!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/dashboard',
                      );
                    },
                  )
                ],
              );
            });
      });
    } else {
      showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(error),
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    this.admin = {"email": arguments["email"], "pass": arguments["pass"]};
    if (arguments != null) {
      print(arguments["email"]);
      log(arguments["email"]);
    }
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
      body: LoadingOverlay(
        isLoading: this.isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                " Add Organisation \n details:",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              CustomEditText(
                  label: "Organisation Name",
                  hint: "Stanford Ltd.",
                  isPass: false,
                  onChanged: (val) {
                    this.setState(() {
                      orgName = val;
                    });
                  }),
              SizedBox(
                height: 30,
              ),
              ButtonWithText(
                buttonText: "Select Organisation Logo",
                text: this.logoText,
                onTap: this.getImageFromGallery,
              ),
              SizedBox(
                height: 30,
              ),
              ButtonWithText(
                buttonText: "Add Rooms",
                text: this.allRooms.length.toString() + " rooms added",
                onTap: this.addRooms,
              ),
              SizedBox(
                height: 30,
              ),
              ButtonWithText(
                  buttonText: "Add Teams",
                  text: this.allTeams.length.toString() + " teams Added",
                  onTap: this.addTeams),
              SizedBox(
                height: 30,
              ),
              ButtonWithText(
                buttonText: "Add Employees",
                text: this.allEmployees.length.toString() + " employees added",
                onTap: this.addEmployees,
              ),
              SizedBox(
                height: 30,
              ),
              MyButton(
                text: "Create",
                onTap: () {
                  print("creating");
                  this.createOrg();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
