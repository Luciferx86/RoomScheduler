import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:room_scheduler/Onboarding/employee_item.dart';
import 'package:room_scheduler/common/commun-utils.dart';
import 'package:room_scheduler/models/employee_model.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/MyButton.dart';

class AddEmployees extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final Function addEmployee;
  final Function removeEmployee;
  final List<EmployeeModel> employeeList;
  final List<String> teamsList;

  AddEmployees(
      {this.addEmployee,
      this.removeEmployee,
      this.employeeList,
      this.teamsList});

  _AddEmployeesState createState() => _AddEmployeesState();
}

class _AddEmployeesState extends State<AddEmployees> {
  TextEditingController empNameController;
  TextEditingController empPhoneController;
  String selectedTeam;

  @override
  void initState() {
    empNameController = new TextEditingController();
    empPhoneController = new TextEditingController();
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
                    validator: (String val) {
                      if (val.isEmpty) return "Employee Name *";
                      if (val.length <= 2)
                        return "must be 3 characters or long";
                      return null;
                    },
                    controller: empNameController,
                    explicitReadOnly: false,
                    icon: Icon(Icons.person_outline),
                    fieldName: "Employee Name",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DefTextFormField(
                          validator: (String val) {
                            if (val.isEmpty) return "Phone Number *";
                            if (val.length < 10) return "Invalid Phone Number";
                            return null;
                          },
                          controller: empPhoneController,
                          maxLength: 10,
                          explicitReadOnly: false,
                          icon: Icon(Icons.phone),
                          fieldName: "Phone Number",
                          inputType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButton(
                        onChanged: (val) {
                          setState(() {
                            selectedTeam = val;
                          });
                        },
                        value: selectedTeam,
                        items: widget.teamsList
                            .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MyButton(
                  text: "Add",
                  onTap: () {
                    if (widget.formKey.currentState.validate()) {
                      if (selectedTeam != null) {
                        setState(() {
                          widget.addEmployee(new EmployeeModel(
                              empName: empNameController.text,
                              empPhoneNumber: empPhoneController.text,
                              empTeam: selectedTeam));
                          empNameController.text = "";
                          empPhoneController.text = "";
                        });
                      } else {
                        CommonUtils.showToastMessage("Select a Team");
                      }
                    }
                  },
                ),
                Container(
                  height: screendata.size.height / 3.2,
                  margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.employeeList.length,
                    itemBuilder: (context, index) {
                      return EmployeeItem(
                        employee: widget.employeeList[index],
                        onRemove: (EmployeeModel employee) {
                          setState(() {
                            widget.removeEmployee(employee);
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
