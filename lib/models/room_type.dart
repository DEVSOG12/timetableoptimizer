import 'package:hive/hive.dart';

part 'room_type.g.dart';

@HiveType(typeId: 0)
class RoomType {
  @HiveField(0)
  bool? islab;

  RoomType(this.islab);
}

