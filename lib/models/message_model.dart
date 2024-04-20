class MessageModel {
  String id;
  String senderId;
  String receiverId;
  String type;
  String message;
  String time;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.message,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      type: json['type'],
      message: json['message'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_id': senderId,
        'receiver_id': receiverId,
        'type': type,
        'message': message,
        'time': time,
      };

  @override
  String toString() {
    return 'MessageModel(sender_id: $senderId, receiver_id: $receiverId, type: $type, message: $message, time: $time)';
  }
}
