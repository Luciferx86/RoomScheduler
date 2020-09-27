import 'package:flutter/widgets.dart';

class AddRooms extends StatefulWidget {
  final formKey = GlobalKey<FormState>();

  _AddRoomsState createState() => _AddRoomsState();
}

class _AddRoomsState extends State<AddRooms> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        child: Center(
          child: Text("Add Rooms"),
        ),
      ),
    );
  }
}
