import 'package:timetableoptimizer/models/subject.dart';

class Teacher {
  String? teachername;
  List<Subject>? teachingsubjects;
  int? maxnumber;

  Teacher(this.maxnumber, this.teachername, this.teachingsubjects);
}
