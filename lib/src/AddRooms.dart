import 'package:flutter/material.dart';
import 'package:room_scheduler/models/room_model.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import '../utils/CustomEditText.dart';

class AddRoomsDialog extends StatefulWidget {
  final onDone;
  final List<RoomModel> allRooms;

  const AddRoomsDialog({Key key, this.onDone, this.allRooms}) : super(key: key);

  _AddRoomsDialog createState() => _AddRoomsDialog();
}

class _AddRoomsDialog extends State<AddRoomsDialog> {
  String roomName = "";
  String roomDesc = "";
  List<RoomModel> rooms;

  @override
  void initState() {
    super.initState();
    rooms = widget.allRooms;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  getRoom(int index) {
    var object = this.rooms[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.green,
            border: Border.all(color: Colors.black, width: 3)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Container(width: 15, child: Text((index + 1).toString())),
              VerticalDivider(
                width: 8,
                thickness: 2,
                color: Colors.black,
              ),
              Container(width: 100, child: Text(object.roomName)),
              VerticalDivider(
                width: 8,
                thickness: 2,
                color: Colors.black,
              ),
              Container(width: 100, child: Text(object.roomDesc)),
              VerticalDivider(
                width: 8,
                thickness: 2,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  print(index);
                  var allRooms = this.rooms;
                  allRooms.remove(index);
                  this.setState(() {
                    rooms = allRooms;
                  });
                },
                child: Icon(
                  Icons.remove_circle_outline,
                ),
              )
            ]),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      height: 600,
      child: Column(
        children: <Widget>[
          DefTextFormField(
            fieldName: "Room Name",
            onChanged: (val) {
              this.setState(() {
                this.roomName = val;
              });
            },
          ),
          DefTextFormField(
            fieldName: "Remarks",
            onChanged: (val) {
              this.setState(() {
                this.roomDesc = val;
              });
            },
          ),
          SizedBox(height: 20),
          MyButton(
            text: "Add Room",
            onTap: () {
              var allRooms = this.rooms;
              allRooms.add(
                  RoomModel(roomName: this.roomName, roomDesc: this.roomDesc));
              this.setState(() {
                this.rooms = allRooms;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            width: 300,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: this.rooms.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(height: 60, child: this.getRoom(index));
                }),
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            text: "Done",
            onTap: () {
              widget.onDone(this.rooms);
            },
          )
        ],
      ),
    );
  }
}
