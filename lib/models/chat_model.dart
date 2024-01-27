import 'package:hive/hive.dart';

class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  int id;

  ChatModel({
    required this.name,
    required this.icon,
    required this.isGroup,
    required this.time,
    required this.currentMessage,
    required this.id,
  });
}

class ChatModelAdapter extends TypeAdapter<ChatModel> {
  @override
  final typeId = 1;

  @override
  ChatModel read(BinaryReader reader) {
    return ChatModel(
      name: reader.readString(),
      icon: reader.readString(),
      isGroup: reader.readBool(),
      time: reader.readString(),
      currentMessage: reader.readString(),
      id: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatModel obj) {
    writer
      ..writeString(obj.name)
      ..writeString(obj.icon)
      ..writeBool(obj.isGroup)
      ..writeString(obj.time)
      ..writeString(obj.currentMessage)
      ..writeInt(obj.id);
  }
}
