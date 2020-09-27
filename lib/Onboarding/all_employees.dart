import 'package:flutter/widgets.dart';

class AddEmployees extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  _AddEmployeesState createState() => _AddEmployeesState();
}

class _AddEmployeesState extends State<AddEmployees> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: widget.formKey,
        child: Container(
          child: Center(
            child: Text("Add Employees"),
          ),
        ));
  }
}
