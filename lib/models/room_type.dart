import 'package:hive/hive.dart';

class RoomType {
  bool? islab;

  RoomType(this.islab);
}

class RoomTypeAdapter extends TypeAdapter<RoomType> {
  @override
  final typeId = 0;

  @override
  RoomType read(BinaryReader reader) {
    return RoomType(reader.read());
  }

  @override
  void write(BinaryWriter writer, RoomType obj) {
    writer.write(obj.islab);
  }
}
