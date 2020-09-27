import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/src/AddSchedule.dart';
import 'package:room_scheduler/src/RoomTimeline.dart';
import 'package:room_scheduler/utils/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends State<Dashboard> {
  String orgName = "";
  List<Widget> allChildren = [];

  String getFirebaseRefName(String name) {
    return name
        .replaceAll(" ", "")
        .replaceAll(".", "")
        .replaceAll("/", "")
        .replaceAll("&", "");
  }

  Future<void> loadOrgName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String orgName = prefs.getString("orgName") ?? "";
    List<String> allRooms = [];
    log("org:" + orgName);
    FirebaseDatabase.instance
        .reference()
        .child("Orgs")
        .child(getFirebaseRefName(orgName))
        .child("allRooms")
        .once()
        .then((DataSnapshot snapshot) {
      Map values = snapshot.value;
      log("yoyo");
      log(values.toString());
      values.forEach((key,val) {
        log(val["name"]);
        allRooms.add(key);
      });
    });
    this.setState(() {
      this.orgName = orgName;
      allChildren = [
        RoomTimeline(title: orgName,allRooms: allRooms,),
        ScheduleAdder(title: this.orgName, allRooms : allRooms),
        Container(
          color: Colors.yellow,
        )
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    this.loadOrgName();
  }

  int currIndex = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text(Strings.bottomNavListTitle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text(Strings.bottomNavAddTitle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text(Strings.bottomNavProfileTitle)),
        ],
        onTap: (int index) {
          setState(() {
            currIndex = index;
          });
        },
      ),
      body: IndexedStack(
        children: allChildren,
        index: currIndex,
      ),
    );
  }
}
