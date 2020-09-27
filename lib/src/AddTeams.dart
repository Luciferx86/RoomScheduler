import 'package:flutter/material.dart';
import 'package:room_scheduler/models/team_model.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import '../utils/CustomEditText.dart';

class AddTeamsDialog extends StatefulWidget {
  final onDone;
  final List allTeams;

  const AddTeamsDialog({Key key, this.onDone, this.allTeams}) : super(key: key);

  _AddTeamsDialog createState() => _AddTeamsDialog();
}

class _AddTeamsDialog extends State<AddTeamsDialog> {
  String teamName = "";
  List<TeamModel> teams;

  @override
  void initState() {
    super.initState();
    teams = widget.allTeams;
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

  getTeam(int index) {
    var object = this.teams[index];
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
              Container(width: 180, child: Text(object.teamName)),
              VerticalDivider(
                width: 8,
                thickness: 2,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  print(index);
                  var allTeams = this.teams;
                  allTeams.removeAt(index);
                  this.setState(() {
                    teams = allTeams;
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
      height: 500,
      child: Column(
        children: <Widget>[
          DefTextFormField(
            fieldName: "Team Name",
            onChanged: (val) {
              this.setState(() {
                this.teamName = val;
              });
            },
          ),
          SizedBox(height: 20),
          MyButton(
            text: "Add Team",
            onTap: () {
              print("l = " + this.teamName.length.toString());
              if (this.teamName.length > 4) {
                this.setState(() {
                  this.teams.add(TeamModel(teamName: this.teamName));
                  this.teamName = "";
                });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Team Name"),
                        content: Container(
                            height: 80,
                            child: Center(
                                child: Text("Team Name less than 4 chars"))),
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
                itemCount: this.teams.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(height: 60, child: this.getTeam(index));
                }),
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            text: "Done",
            onTap: () {
              widget.onDone(this.teams);
            },
          )
        ],
      ),
    );
  }
}
