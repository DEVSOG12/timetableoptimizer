import 'package:hive/hive.dart';
import 'package:timetableoptimizer/models/room_type.dart';

part 'subject.g.dart';
@HiveType(typeId: 1)
class Subject {
  @HiveField(0)
  String? subjectname;
  @HiveField(1)

  int? subjectclass;
  @HiveField(2)
  RoomType? preferredclass;
  @HiveField(3)

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

// class SubjectAdapter extends TypeAdapter<Subject> {
//   @override
//   final typeId = 1;

//   @override
//   Subject read(BinaryReader reader) {
//     return Subject(
//         RoomType(false), reader.read(), reader.read(), reader.read());
//   }

//   @override
//   void write(BinaryWriter writer, Subject obj) {
//     writer.write(obj.subjectname);
//     writer.write(obj.subjectclass);
//     writer.write(obj.strength);
//     writer.write(
//       obj.preferredclass,
//     );
//     // writer.
//   }
// }
