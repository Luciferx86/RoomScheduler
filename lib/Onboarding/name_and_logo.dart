import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:room_scheduler/utils/CustomEditText.dart';
import 'package:room_scheduler/utils/MyButton.dart';

class OrgNameAndLogo extends StatefulWidget {
  final Function onChangedOrgName;

  final formKey = GlobalKey<FormState>();

  final File orgLogo;
  final String iniOrgName;

  final Function onSavedOrgLogo;

  GlobalKey getFormKey() {
    return formKey;
  }

  OrgNameAndLogo(
      {this.onChangedOrgName,
      this.orgLogo,
      this.iniOrgName,
      this.onSavedOrgLogo});

  _OrgNameAndLogoState createState() => _OrgNameAndLogoState();
}

class _OrgNameAndLogoState extends State<OrgNameAndLogo> {
  String orgName;
  File orgLogo;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: DefTextFormField(
              validator: (val) {
                if (val.isEmpty)
                  return "Enter Organisation Name";
                else if (val.length < 3)
                  return "Organisation Name must be atleast 3 characters";
                else
                  return null;
              },
              iniValue: widget.iniOrgName,
              explicitReadOnly: false,
              icon: Icon(Icons.account_balance),
              fieldName: "Organisation Name",
              onChanged: (val) => widget.onChangedOrgName(val),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: orgLogo != null,
            child: orgLogo != null
                ? Image.file(
                    orgLogo,
                    width: 250,
                    height: 250,
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(
            height: 30,
          ),
          MyButton(
            text: "Select Organisation Logo",
            onTap: () async {
              File image = await getImageFromGallery();

              if (image != null) {
                setState(() {
                  orgLogo = image;
                });

                widget.onSavedOrgLogo(image);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<File> getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }
}
