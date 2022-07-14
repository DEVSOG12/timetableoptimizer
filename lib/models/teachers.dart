import 'package:timetableoptimizer/models/subject.dart';

class Teacher {
  String? name;
  List<Subject>? subjects;
  int? level;

  Teacher({this.level, this.name, this.subjects});
}
