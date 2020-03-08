import 'package:flutter/material.dart';
import 'package:room_scheduler/src/AddSchedule.dart';
import 'package:room_scheduler/src/RoomTimeline.dart';
import 'package:room_scheduler/utils/Strings.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashBoardState();
  }
}

class DashBoardState extends State<Dashboard> {
  int currIndex = 0;
  String selectedRoom;
  List<Widget> allChildren = [
    RoomTimeline(),
    ScheduleAdder(),
    Container(
      color: Colors.yellow,
    )
  ];
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
      body: allChildren[currIndex],
    );
  }
}
