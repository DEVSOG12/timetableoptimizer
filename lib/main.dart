import 'package:flutter/material.dart';
// import 'hive';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timetableoptimizer/UI/populaterooms.dart';
import 'package:timetableoptimizer/UI/subjectpopulate.dart';
import 'package:timetableoptimizer/models/room_type.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RoomTypeAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Subjects());
  }
}
