import 'package:timetableoptimizer/models/room_type.dart';

class Subject {
  String? subjectname;

  int? subjectclass;

  RoomType? preferredclass;

  int? strength;
  Subject({
      this.preferredclass, this.strength, this.subjectclass, this.subjectname});

  Subject.fromMap(Map<String, dynamic> map)
      : subjectname = map["subjectname"],
        subjectclass = map["subjectclass"],
        strength = map["strength"],
        preferredclass = map["preferredclass"];

  Map toMap(subjectname, subjectclass, strength, preferredclass) {
    return {
      "subjectname": subjectname,
      "subjectclass": subjectclass,
      "strength": strength,
      "preferredclass": preferredclass
    };
  }
}
