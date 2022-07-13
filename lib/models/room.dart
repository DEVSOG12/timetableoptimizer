import 'package:timetableoptimizer/models/room_type.dart';

class Room {
  String? roomname;
  int? roomnumber;
  RoomType? type;

  Room({this.roomnumber, this.roomname, this.type});

  Room.fromMap(Map<String, dynamic> map)
      : roomnumber = map["roomnumber"],
        roomname = map["roomname"],
        type = map["type"];

  Map toMap(roomnumber, roomname, type) {
    return {"roomname": roomname, "roomnumber": roomnumber, "type": type};
  }
}
