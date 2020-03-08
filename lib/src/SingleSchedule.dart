import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';

class SingleSchedule extends StatelessWidget {
  String startTime = "";
  String endTime = "";
  String desc = "";

  SingleSchedule(
      {Key key,
      @required this.startTime,
      @required this.endTime,
      @required this.desc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Bubble(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  this.startTime,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  this.endTime,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            Container(
                alignment: Alignment.center,
                width: 200,
                // margin: EdgeInsets.only(right: 10),
                child: Text(
                  this.desc,
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
        color: RoomSchedulerColors.green,
        nip: BubbleNip.leftTop,
        margin: BubbleEdges.only(top: 10),
      ),
    );
  }
}
