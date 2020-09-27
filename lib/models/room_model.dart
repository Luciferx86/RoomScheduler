import 'package:json_annotation/json_annotation.dart';


@JsonSerializable(nullable: true, includeIfNull: true)
class RoomModel {
  @JsonKey(defaultValue: '')
  String roomName;
  @JsonKey(defaultValue: '')
  String roomDesc;

  RoomModel({
    this.roomName,
    this.roomDesc,
  });

  Map<String, dynamic> toJson() => {
    'roomName': roomName,
    'roomDesc': roomDesc,
  };

  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'roomDesc': roomDesc,
    };
  }
}
