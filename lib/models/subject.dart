import 'package:timetableoptimizer/models/room_type.dart';

class Subject {
  String? subjectname;

  int? subjectclass;

  RoomType? preferredclass;

  int? strength;
  Subject(
      this.preferredclass, this.strength, this.subjectclass, this.subjectname);
}
