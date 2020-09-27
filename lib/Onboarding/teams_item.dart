import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:room_scheduler/utils/Colors.dart';

class TeamsItem extends StatelessWidget {
  final String teamName;
  final Function onDelete;

  TeamsItem({this.teamName, this.onDelete});

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
          top: 10.0,
          bottom: 10.0,
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
                    Icons.group,
                    size: 30.0,
                    color: Colors.blue[300],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      teamName,
                      overflow: TextOverflow.clip,
                      maxLines: 3,
                      style: TextStyle(
                        letterSpacing: 0.25,
                        fontSize: 22.0,
                        color: AppColors.gunMetal,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed:()=> onDelete(teamName),
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
