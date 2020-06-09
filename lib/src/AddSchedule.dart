import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/FirebaseKeys.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import 'package:room_scheduler/utils/Schedule.dart';
import 'package:room_scheduler/utils/Strings.dart';

class ScheduleAdder extends StatefulWidget {
  final String title;
  final List<String> allRooms;
  const ScheduleAdder({this.title, this.allRooms, key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ScheduleAdderState();
  }
}

String formatTime(DateTime time) {
  String myTime =
      (time.hour > 12 ? (time.hour - 12).toString() : time.hour.toString()) +
          ":" +
          (time.minute.toString().length == 1
              ? "0" + time.minute.toString()
              : time.minute.toString()) +
          (time.hour > 12 ? " PM" : " AM");
  return myTime;
}

class ScheduleAdderState extends State<ScheduleAdder> {
  String selectedRoom = "Room 1";
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(hours: 1));
  String desc;
  List<Schedule> allSchedules = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: RoomSchedulerColors.orange,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 200),
            child: Text("Select Room", style: TextStyle(fontSize: 20)),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: DropdownButton<String>(
              value: selectedRoom,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              items: this.getRooms(),
              onChanged: (String room) {
                setState(() {
                  selectedRoom = room;
                });
                this.fetchSchedules();
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showSecondsColumn: false,
                      showTitleActions: true, onConfirm: (time) {
                    setState(() {
                      startTime = time;
                    });
                  }, currentTime: startTime, locale: LocaleType.en);
                },
                child: Column(
                  children: <Widget>[
                    Text("Start Time"),
                    Text(
                      formatTime(this.startTime),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showSecondsColumn: false,
                      showTitleActions: true, onConfirm: (time) {
                    setState(() {
                      endTime = time;
                    });
                  }, currentTime: endTime, locale: LocaleType.en);
                },
                child: Column(
                  children: <Widget>[
                    Text("End Time"),
                    Text(
                      formatTime(this.endTime),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          CustomEditText(
            label: "Description",
            hint: "Android Team's Standup",
            isPass: false,
            onChanged: (String text) {
              log("setting desc $text");
              setState(() {
                this.desc = text;
              });
            },
          ),
          SizedBox(
            height: 50,
          ),
          MyButton(
            text: "Book",
            onTap: () {
              Schedule currSchedule = Schedule(this.startTime.toString(),
                  this.endTime.toString(), this.desc);
              if (isValidSchedule(currSchedule)) {
                FirebaseDatabase()
                    .reference()
                    .child("Orgs")
                    .child(widget.title)
                    .child("allRooms")
                    .child(selectedRoom)
                    .child("schedules")
                    .push()
                    .set({
                  "startTime": startTime.toString(),
                  "endTime": endTime.toString(),
                  "desc": "this.desc"
                }).then((onValue) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Schedule Added!"),
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
                  fetchSchedules();
                });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Schedule"),
                      );
                    });
              }
            },
          )
        ],
      )),
    );
  }

  void fetchSchedules() {
    List<Schedule> allSchedules = [];
    FirebaseDatabase.instance
        .reference()
        .child("Orgs")
        .child(widget.title)
        .child("allRooms")
        .child(selectedRoom)
        .child("schedules")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      try {
        values.forEach((key, val) {
          allSchedules
              .add(Schedule(val["startTime"], val["endTime"], val["desc"]));
        });
      } catch (e) {}
      setState(() {
        this.allSchedules = allSchedules;
        log(allSchedules.length.toString());
      });
    });
  }

  bool isValidSchedule(Schedule newSchedule) {
    DateTime newStartTime = DateTime.parse(newSchedule.startTime);
    DateTime newEndTime = DateTime.parse(newSchedule.endTime);
    log("allSchedules size : " + this.allSchedules.length.toString());
    bool retVal = true;
    this.allSchedules.forEach((schedule) {
      DateTime startTime = DateTime.parse(schedule.startTime);
      DateTime endTime = DateTime.parse(schedule.endTime);
      log("comparing" + startTime.compareTo(newStartTime).toString());
      if(startTime.isBefore(newStartTime) && endTime.isBefore(newEndTime) && endTime.isAfter(newStartTime)){
        log("invallid");
        retVal = false;
      }
      if(startTime.isAfter(newStartTime) && endTime.isAfter(newEndTime) && startTime.isBefore(newEndTime)){
        log("invallid");
        retVal = false;
      }
      if(startTime.isBefore(newStartTime) && endTime.isAfter(newEndTime)){
        log("invallid");
        retVal = false;
      }
      if(startTime.isAfter(newStartTime) && endTime.isBefore(newEndTime)){
        log("invallid");
        retVal = false;
      }
      // if (startTime.compareTo(newStartTime) > 0 &&
      //     endTime.compareTo(newEndTime) > 0) {
      //   log("invallid");
      //   retVal = false;
      // }
      // if (startTime.compareTo(newStartTime) > 0 &&
      //     endTime.compareTo(newEndTime) < 0) {
      //   log("invalid");
      //   retVal = false;
      // }
    });
    log("valid");
    return retVal;
  }

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  List<DropdownMenuItem<String>> getRooms() {
    List<DropdownMenuItem<String>> rooms = [];
    widget.allRooms.forEach((roomName) {
      rooms.add(
          DropdownMenuItem<String>(value: roomName, child: Text(roomName)));
    });
    return rooms;
  }
}
