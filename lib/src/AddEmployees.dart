import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/MyButton.dart';
import '../utils/CustomEditText.dart';

class AddEmployeeDialog extends StatefulWidget {
  final onDone;
  final List allEmployees;
  final List allTeams;
  const AddEmployeeDialog(
      {Key key, this.onDone, this.allEmployees, this.allTeams})
      : super(key: key);
  _AddEmployeeDialog createState() => _AddEmployeeDialog();
}

class _AddEmployeeDialog extends State<AddEmployeeDialog> {
  String employeeEmail = "";
  List employees;
  List teams;
  String teamSelected;

  @override
  void initState() {
    print("allTeams: " + widget.allTeams.toString());
    super.initState();
    employees = widget.allEmployees;
    teams = widget.allTeams;
    teamSelected = teams[0]["name"];
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

  getEmployee(int index) {
    var object = this.employees[index];
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
                indent: 3,
                endIndent: 3,
                color: Colors.black,
              ),
              Container(
                  width: 180,
                  child: Column(
                    children: <Widget>[
                      Text(
                        object["email"],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      Divider(
                        thickness: 3,
                        color: Colors.black,
                      ),
                      Text(object["team"])
                    ],
                  )),
              VerticalDivider(
                width: 8,
                indent: 3,
                endIndent: 3,
                thickness: 2,
                color: Colors.black,
              ),
              InkWell(
                onTap: () {
                  print(index);
                  var allEmployees = this.employees;
                  allEmployees.removeAt(index);
                  this.setState(() {
                    employees = allEmployees;
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

  getTeams() {
    List<DropdownMenuItem<String>> allTeams = [];
    this.teams.forEach((team) {
      allTeams.add(DropdownMenuItem(
        child: Text(team["name"]),
        value: team["name"],
      ));
    });
    return allTeams;
  }

  dialogContent(BuildContext context) {
    return Container(
      
      height: 600,
      child: Column(
        children: <Widget>[
          CustomEditText(
            label: "Employee Email",
            hint: "johnwatson@mail.com",
            isPass: false,
            onChanged: (val) {
              this.setState(() {
                this.employeeEmail = val;
              });
            },
          ),
          SizedBox(height: 20),
          Text("Team: "),
          DropdownButton(
            value: this.teamSelected,
            items: this.getTeams(),
            onChanged: (val) {
              this.setState(() {
                teamSelected = val;
              });
            },
          ),
          MyButton(
            text: "Add Employee",
            onTap: () {
              if (this.employeeEmail.length > 4) {
                var allEmployees = this.employees;
                allEmployees.add(
                    {"email": this.employeeEmail, "team": this.teamSelected});
                this.setState(() {
                  this.employees = allEmployees;
                });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Invalid Employee Name"),
                        content: Container(
                            height: 80,
                            child: Center(
                                child:
                                    Text("Employee Name less than 4 chars"))),
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
                itemCount: this.employees.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(height: 80, child: this.getEmployee(index));
                }),
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            text: "Done",
            onTap: () {
              widget.onDone(this.employees);
            },
          )
        ],
      ),
    );
  }
}
