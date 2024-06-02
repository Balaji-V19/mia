

class ChatModel {
  bool isClient;
  String message;

  ChatModel({
    required this.isClient,
    required this.message,
  });

  // Convert a Message object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'isClient': isClient,
      'message': message,
    };
  }

  // Create a Message object from a Map object
  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      isClient: map['isClient'] ?? false,
      message: map['message'] ?? '',
    );
  }

}
