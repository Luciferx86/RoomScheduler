import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_timeline/progress_timeline.dart';
import 'package:room_scheduler/Onboarding/all_employees.dart';
import 'package:room_scheduler/Onboarding/all_rooms.dart';
import 'package:room_scheduler/Onboarding/all_teams.dart';
import 'package:room_scheduler/Onboarding/name_and_logo.dart';
import 'package:room_scheduler/common/commun-utils.dart';
import 'package:room_scheduler/models/employee_model.dart';
import 'package:room_scheduler/models/room_model.dart';
import 'package:room_scheduler/models/team_model.dart';
import 'package:room_scheduler/src/AddEmployees.dart';
import 'package:room_scheduler/src/AddRooms.dart';
import 'package:room_scheduler/src/AddTeams.dart';
import 'package:room_scheduler/utils/Colors.dart';
import 'package:room_scheduler/utils/Strings.dart';
import 'package:room_scheduler/utils/two_bottom_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrganisation extends StatefulWidget {
  @override
  _AddOrganisationState createState() => _AddOrganisationState();
}

class _AddOrganisationState extends State<AddOrganisation> {
  String orgName = "";
  File orgLogo;
  List<RoomModel> allRooms = new List();
  List<TeamModel> allTeams = [];
  List allEmployees = [];
  OrgNameAndLogo setupChild;
  AddTeams teamsChild;
  AddRooms roomsChild;
  AddEmployees employeesChild;

  List<String> teams = [];
  List<EmployeeModel> employees = [];

  Widget currentStageChild;
  var admin;
  AddOrgStages currentStage = AddOrgStages.ORG_SETUP;
  String logoText = "No Logo Added";
  List<SingleState> allStages = [
    SingleState(stateTitle: "Setup"),
    SingleState(stateTitle: "Teams"),
    SingleState(stateTitle: "Employees"),
    SingleState(stateTitle: "Rooms"),
  ];

  ProgressTimeline timeline;

  @override
  void initState() {
    timeline = new ProgressTimeline(
      states: allStages,
      connectorColor: AppColors.orange,
    );
    setupChild = new OrgNameAndLogo(
      iniOrgName: orgName,
      orgLogo: orgLogo,
      onSavedOrgLogo: (File logo) {
        setState(() {
          orgLogo = logo;
        });
      },
      onChangedOrgName: (String val) {
        setState(() {
          orgName = val;
        });
      },
    );
    employeesChild = new AddEmployees(
      employeeList: employees,
      teamsList: teams,
      addEmployee: (EmployeeModel emp) {
        setState(() {
          employees.add(emp);
        });
      },
      removeEmployee: (EmployeeModel emp) {
        setState(() {
          employees.remove(emp);
        });
      },
    );
    roomsChild = new AddRooms();
    teamsChild = new AddTeams(
      teams: teams,
      addTeam: (String teamName) {
        setState(() {
          teams.add(teamName);
        });
      },
      deleteTeam: (String teamName) {
        setState(() {
          teams.remove(teamName);
        });
      },
    );
    currentStageChild = setupChild;
    super.initState();
  }

  void gotoPreviousStage() {
    switch (currentStage) {
      case AddOrgStages.ORG_SETUP:
        break;
      case AddOrgStages.ADD_TEAMS:
        setState(() {
          currentStageChild = setupChild;
        });
        currentStage = AddOrgStages.ORG_SETUP;
        timeline.gotoPreviousStage();
        break;
      case AddOrgStages.ADD_EMPLOYEES:
        setState(() {
          currentStageChild = teamsChild;
        });
        currentStage = AddOrgStages.ADD_TEAMS;
        timeline.gotoPreviousStage();
        break;
      case AddOrgStages.ADD_ROOMS:
        setState(() {
          currentStageChild = employeesChild;
        });
        currentStage = AddOrgStages.ADD_EMPLOYEES;
        timeline.gotoPreviousStage();
        break;
      case AddOrgStages.SETUP_COMPLETE:
        setState(() {
          currentStageChild = roomsChild;
        });
        currentStage = AddOrgStages.ADD_ROOMS;
        timeline.gotoPreviousStage();
        break;
    }
  }

  void gotoNextStage() {
    switch (currentStage) {
      case AddOrgStages.ORG_SETUP:
        if (setupChild.formKey.currentState.validate()) {
          if (orgLogo != null) {
            timeline.gotoNextStage();
            setState(() {
              currentStageChild = teamsChild;
            });
            currentStage = AddOrgStages.ADD_TEAMS;
          } else {
            CommonUtils.showToastMessage("Select company logo");
          }
        }
        break;

      case AddOrgStages.ADD_TEAMS:
        if (teams.length > 0) {
          timeline.gotoNextStage();
          setState(() {
            currentStageChild = employeesChild;
          });
          currentStage = AddOrgStages.ADD_EMPLOYEES;
        } else {
          CommonUtils.showToastMessage("Add atleast 1 team");
        }
        break;
      case AddOrgStages.ADD_EMPLOYEES:
        if (employees.length > 0) {
          timeline.gotoNextStage();
          setState(() {
            currentStageChild = roomsChild;
          });
          currentStage = AddOrgStages.ADD_ROOMS;
        } else {
          CommonUtils.showToastMessage("Add atleast 1 employee");
        }
        break;
      case AddOrgStages.ADD_ROOMS:
        if (roomsChild.formKey.currentState.validate()) {
          timeline.gotoNextStage();
          setState(() {
//            currentStageChild = teamsChild;
          });
          currentStage = AddOrgStages.SETUP_COMPLETE;
        }
        break;
      case AddOrgStages.SETUP_COMPLETE:
        CommonUtils.showToastMessage("Setup Complete");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    this.admin = {"number": arguments["number"]};
    if (arguments != null) {
      print(arguments["number"]);
      log(arguments["number"]);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Strings.loginPageTitle,
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: AppColors.orange,
      ),
      bottomNavigationBar: TwoBottomButtons(
        btnOneText: "Previous",
        btnTwoText: "Next",
        btnOneFunction: gotoPreviousStage,
        btnTwoFunction: gotoNextStage,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 2.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              timeline,
              Text(
                " Add Organisation \n details:",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              currentStageChild,
            ],
          ),
        ),
      ),
    );
  }

  void addRooms() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AddRoomsDialog(
              allRooms: this.allRooms,
              onDone: (List<RoomModel> allRooms) {
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

  List<Map> convertList(List<dynamic> myList) {
    List<Map> listOfMaps = [];
    myList.forEach((object) {
      Map map = object.toMap();
      listOfMaps.add(map);
    });
    return listOfMaps;
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
    if (this.orgLogo == null) {
      error = "No logo selected";
    }
    if (this.orgName == "") {
      error = "Organisation Name not set.";
    }
    if (error == "") {
      this.setState(() {
//        this.isLoading = true;
      });

      CollectionReference users =
          Firestore.instance.collection("Organizations");

      users.add({
        this.orgName: {
          "orgName": this.orgName,
          "allRooms": convertList(this.allRooms),
          "allTeams": convertList(this.allTeams),
          "allEmployees": this.allEmployees,
          "admin": admin
        }
      }).then((value) async {
        log(value.toString());
        log("Added to firestore");
        StorageUploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("Orgs")
            .child(getFirebaseRefName(this.orgName))
            .child("logo")
            .putFile(this.orgLogo);
        await uploadTask.onComplete;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('orgName', this.orgName);
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
    }
  }
}

enum AddOrgStages {
  ORG_SETUP,
  ADD_ROOMS,
  ADD_TEAMS,
  ADD_EMPLOYEES,
  SETUP_COMPLETE
}
