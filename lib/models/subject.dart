import 'package:hive_flutter/hive_flutter.dart';
import 'package:timetableoptimizer/models/room_type.dart';

class Subject {
  String? subjectname;

  int? subjectclass;

  RoomType? preferredclass;

  int? strength;
  Subject(
      this.preferredclass, this.strength, this.subjectclass, this.subjectname);

  Subject.fromMap(Map<String, dynamic> map)
      : subjectname = map["subjectname"],
        subjectclass = map["subjectclass"],
        strength = map["strength"],
        preferredclass = map["preferredclass"];

  Map toMap() {
    return {
      "subjectname": subjectname,
      "subjectclass": subjectclass,
      "strength": strength,
      "preferredclass": preferredclass
    };
  }
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final typeId = 1;

  @override
  Subject read(BinaryReader reader) {
    return Subject(reader.read(), reader.read(), reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer.write(obj.subjectname);
    writer.write(obj.subjectclass);
    writer.write(obj.strength);
    writer.write(obj.preferredclass);
  }
}
