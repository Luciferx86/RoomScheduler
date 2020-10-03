import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_scheduler/Onboarding/teams_item.dart';
import 'package:room_scheduler/common/commun-utils.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/MyButton.dart';

class AddTeams extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final List<String> teams;
  final Function deleteTeam;
  final Function addTeam;

  AddTeams({this.addTeam,
    this.deleteTeam,
    this.teams});

  _AddTeamsState createState() => _AddTeamsState();
}

class _AddTeamsState extends State<AddTeams> {
  TextEditingController teamNameController;

  @override
  void initState() {
    teamNameController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screendata = MediaQuery.of(context);
    return Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: DefTextFormField(
                    controller: teamNameController,
                    explicitReadOnly: false,
                    icon: Icon(Icons.group),
                    fieldName: "Team Name",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyButton(
                  text: "Add",
                  onTap: () {
                    if (teamNameController.text.length > 2) {
                      setState(() {
                        widget.addTeam(teamNameController.text);
                        teamNameController.text = "";
                      });
                    } else {
                      CommonUtils.showToastMessage(
                          "Team name must be 3 characters");
                    }
                  },
                ),
                Container(
                  height: screendata.size.height / 2.8,
                  margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.teams.length,
                    itemBuilder: (context, index) {
                      return TeamsItem(
                        teamName: widget.teams[index],
                        onDelete: (String teamName) {
                          setState(() {
                            widget.deleteTeam(teamName);
                          });
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
