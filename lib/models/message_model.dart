import 'package:hive/hive.dart';
class MessageModel {
  String type;
  String message;
  String time;

  MessageModel({
    required this.type,
    required this.message,
    required this.time,
  });
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final typeId = 0;

  @override
  MessageModel read(BinaryReader reader) {
    return MessageModel(
      type: reader.readString(),
      message: reader.readString(),
      time: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageModel obj) {
    writer
      ..writeString(obj.type)
      ..writeString(obj.message)
      ..writeString(obj.time);
  }
}
