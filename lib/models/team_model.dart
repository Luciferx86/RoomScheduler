import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true, includeIfNull: true)
class TeamModel {
  @JsonKey(defaultValue: '')
  String teamName;

  TeamModel({
    this.teamName,
  });

  Map<String, dynamic> toJson() => {
        'teamName': teamName,
      };

  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
    };
  }
}
