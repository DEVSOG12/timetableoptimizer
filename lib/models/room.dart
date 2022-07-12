import 'package:timetableoptimizer/models/room_type.dart';

class Room {
  String? rooomname;
  int? roomnumber;
  RoomType? type;

  Room(this.roomnumber, this.rooomname, this.type);
}
