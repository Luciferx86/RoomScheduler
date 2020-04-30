import 'dart:io';

import 'package:flutter/material.dart';
import 'package:room_scheduler/src/AddRooms.dart';
import 'package:room_scheduler/utils/ButtonWithText.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Strings.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddOrganisation extends StatefulWidget {
  @override
  _AddOrganisationState createState() => _AddOrganisationState();
}

class _AddOrganisationState extends State<AddOrganisation> {
  File logo;
  List allRooms = [];
  String logoText = "No Logo Added";
  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      logo = image;
      logoText = path.basename(image.path);
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      print(arguments["email"]);
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
      body: SingleChildScrollView(
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
              height: 30,
            ),
            ButtonWithText(
              buttonText: "Select Company Logo",
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
            ButtonWithText(buttonText: "Add Teams", text: "No teams Added"),
            SizedBox(
              height: 30,
            ),
            ButtonWithText(
              buttonText: "Add Members",
              text: "0 members added",
            ),
            SizedBox(
              height: 70,
            ),
            MyButton(text: "Create"),
          ],
        ),
      ),
    );
  }
}
