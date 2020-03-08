import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/src/SingleSchedule.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/Schedule.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class RoomTimeline extends StatefulWidget {
  @override
  _RoomTimelineState createState() => _RoomTimelineState();
}

class _RoomTimelineState extends State<RoomTimeline> {
  String selectedRoom = "Room 1";
  String randomStartTime = "Room 1";
  List<Schedule> allSchedules;
  List<TimelineModel> timelineItems = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: RoomSchedulerColors.orange,
          title: Text(this.selectedRoom),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: Timeline(
                    children: timelineItems, position: TimelinePosition.Left)),
            Text(this.randomStartTime),
            DropdownButton<String>(
              value: selectedRoom,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items: [
                DropdownMenuItem<String>(
                    value: "Room 1", child: Text("Room 1")),
                DropdownMenuItem<String>(
                    value: "Room 2", child: Text("Room 2")),
                DropdownMenuItem<String>(
                    value: "Room 3", child: Text("Room 3")),
                DropdownMenuItem<String>(
                    value: "Room 4", child: Text("Room 4")),
                DropdownMenuItem<String>(
                    value: "Room 5", child: Text("Room 5")),
              ],
              onChanged: (String room) {
                setState(() {
                  this.selectedRoom = room;
                });
                fetchSchedules();
              },
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSchedules();
  }

  void fetchSchedules() {
    List<Schedule> allSchedules = [];
    FirebaseDatabase.instance
        .reference()
        .child("rooms")
        .child(selectedRoom)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, val) {
        allSchedules
            .add(Schedule(val["startTime"], val["endTime"], val["desc"]));
      });
      setState(() {
        this.allSchedules = allSchedules;
      });

      sortSchedules(allSchedules);

      updateSchedules();
    });
  }

  void updateSchedules() {
    List<TimelineModel> items = [];
    this.allSchedules.forEach((schedule) {
      items.add(TimelineModel(
          SingleSchedule(
            startTime: formatTime(DateTime.parse(schedule.startTime)),
            endTime: formatTime(DateTime.parse(schedule.endTime)),
            desc: schedule.desc,
          ),
          position: TimelineItemPosition.right,
          iconBackground: Colors.redAccent,
          icon: Icon(Icons.blur_circular)));
    });
    setState(() {
      this.timelineItems = items;
    });
  }

  String formatTime(DateTime time) {
    String myTime =
        (time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString()) +
            ":" +
            time.minute.toString() +
            (time.hour > 12 ? " PM" : " AM");
    return myTime;
  }

  //TO-DO
  void sortSchedules(List<Schedule> items) {
    items.sort((a, b) {
      var dateA = DateTime.parse(a.startTime);
      var dateB = DateTime.parse(b.startTime);
      return dateA.compareTo(dateB);
    });
  }
}
