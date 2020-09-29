import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true, includeIfNull: true)
class EmployeeModel {
  @JsonKey(defaultValue: '')
  String empName;
  @JsonKey(defaultValue: '')
  String empTeam;

  @JsonKey(defaultValue: '')
  String empPhoneNumber;

  EmployeeModel({this.empName, this.empTeam, this.empPhoneNumber});

  Map<String, dynamic> toJson() => {
        'empName': empName,
        'empTeam': empTeam,
      };

  Map<String, dynamic> toMap() {
    return {
      'empName': empName,
      'empTeam': empTeam,
    };
  }
}
