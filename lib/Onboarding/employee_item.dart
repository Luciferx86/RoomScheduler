import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/models/employee_model.dart';
import 'package:room_scheduler/utils/Colors.dart';

class EmployeeItem extends StatelessWidget {
  final EmployeeModel employee;

  final Function onRemove;

  EmployeeItem({this.employee, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 15.0,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 5.0,
          bottom: 5.0,
        ),
        color: Color(0x15000000),
        onPressed: () {},
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.person_outline,
                    size: 25.0,
                    color: Colors.blue[300],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                employee.empName,
                                maxLines: 3,
                                style: TextStyle(
                                  letterSpacing: 0.25,
                                  fontSize: 18.0,
                                  color: AppColors.gunMetal,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 14,
                                ),
                                Text(
                                  ": ${employee.empPhoneNumber}",
                                  maxLines: 3,
                                  style: TextStyle(
                                    letterSpacing: 0.25,
                                    fontSize: 12.0,
                                    color: AppColors.gunMetal,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.group,
                                  size: 14,
                                ),
                                Text(
                                  ": ${employee.empTeam}",
                                  maxLines: 3,
                                  style: TextStyle(
                                    letterSpacing: 0.25,
                                    fontSize: 12.0,
                                    color: AppColors.gunMetal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => onRemove(employee),
                  icon: Icon(
                    Icons.highlight_off,
                    size: 25.0,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
